//
//  HHWithdrawViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHWithdrawViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"
#import "HHPaymentMethodCell.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHPopupUtility.h"
#import <MMNumberKeyboard/MMNumberKeyboard.h>
#import "HHInputPaymentMethodView.h"
#import "HHToastManager.h"
#import "HHStudentService.h"
#import "HHAddBankCardViewController.h"
#import "HHWithdrawHistoryViewController.h"
#import "HHStudentStore.h"
#import "HHLoadingViewUtility.h"


static NSString *const kCellId = @"cellId";
static NSString *const kRulesString = @"1）每次最低提现金额不得小于100元\n\n2）具体到账时间以各大银行为准\n\n";

static NSString *const kLawString = @"＊在法律允许的范围内，哈哈学车有权对活动规则进行解释";

@interface HHWithdrawViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *availabeAmountTitleLabel;
@property (nonatomic, strong) UILabel *availabeAmountValueLabel;
@property (nonatomic, strong) UILabel *cashAmountTitleLabel;
@property (nonatomic, strong) UITextField *cashAmountField;

@property (nonatomic, strong) UIButton *withdrawButton;
@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic, strong) NSNumber *availableAmount;

@property (nonatomic, strong) UIView *noCardView;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *eventTitleImageView;
@property (nonatomic, strong) UILabel *eventRulesLabel;

@property (nonatomic, strong) HHBankCard *bankCard;

@end

@implementation HHWithdrawViewController

- (instancetype)initWithAvailableAmount:(NSNumber *)amount {
    self = [super init];
    if (self) {
        self.availableAmount = amount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankCard = [HHStudentStore sharedInstance].currentStudent.bankCard;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"提现记录" titleColor:[UIColor whiteColor] action:@selector(showHistoryVC) target:self isLeft:NO];
    [self initSubviews];
}

- (void)initSubviews {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self.view addSubview:self.topView];
    
    self.availabeAmountTitleLabel = [self buildLabelWithTitle:@"可提现" font:[UIFont systemFontOfSize:16.0f] textColor:[UIColor whiteColor]];
    [self.topView addSubview:self.availabeAmountTitleLabel];
    
    self.availabeAmountValueLabel = [self buildLabelWithTitle:[self.availableAmount generateMoneyString] font:[UIFont systemFontOfSize:45.0f] textColor:[UIColor whiteColor]];
    [self.topView addSubview:self.availabeAmountValueLabel];
    
    self.cashAmountTitleLabel = [self buildLabelWithTitle:@"本次提现" font:[UIFont systemFontOfSize:16.0f] textColor:[UIColor whiteColor]];
    [self.topView addSubview:self.cashAmountTitleLabel];
    
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    keyboard.allowsDecimalPoint = YES;
    keyboard.returnKeyTitle = @"完成";
    
    self.cashAmountField = [[UITextField alloc] init];
    self.cashAmountField.borderStyle = UITextBorderStyleNone;
    self.cashAmountField.layer.cornerRadius = 20.0f;
    self.cashAmountField.layer.masksToBounds = YES;
    self.cashAmountField.backgroundColor = [UIColor whiteColor];
    self.cashAmountField.textAlignment = NSTextAlignmentCenter;
    self.cashAmountField.tintColor = [UIColor HHOrange];
    self.cashAmountField.textColor = [UIColor HHOrange];
    self.cashAmountField.placeholder = @"本次想要提现金额";
    self.cashAmountField.inputView = keyboard;
    [self.topView addSubview:self.cashAmountField];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.withdrawButton setTitle:@"确认提现" forState:UIControlStateNormal];
    [self.withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.withdrawButton.backgroundColor = [UIColor HHOrange];
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    [self.withdrawButton addTarget:self action:@selector(withdrawCash) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.withdrawButton];
    
    if (self.bankCard) {
        [self buildCardView];
    } else {
        [self buildNoCardView];
    }
    
    
    self.eventTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_notice"]];
    [self.scrollView addSubview:self.eventTitleImageView];
    
    self.eventRulesLabel = [[UILabel alloc] init];
    self.eventRulesLabel.numberOfLines = 0;
    self.eventRulesLabel.attributedText = [self buildRulesString];
    [self.scrollView addSubview:self.eventRulesLabel];
    
    [self makeConstraints];
}

- (UILabel *)buildLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = textColor;
    label.font = font;
    return label;
}

- (NSMutableAttributedString *)buildRulesString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:kRulesString attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:kLawString attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    [attrString appendAttributedString:attrString2];
    return attrString;
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(210.0f);
    }];
    
    [self.availabeAmountTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.centerX.equalTo(self.topView.centerX);
    }];
    
    [self.availabeAmountValueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.availabeAmountTitleLabel.bottom).offset(10.0f);
        make.centerX.equalTo(self.topView.centerX);
    }];
    
    [self.cashAmountTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.availabeAmountValueLabel.bottom).offset(20.0f);
        make.centerX.equalTo(self.topView.centerX);
    }];
    
    [self.cashAmountField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cashAmountTitleLabel.bottom).offset(10.0f);
        make.centerX.equalTo(self.topView.centerX);
        make.width.mas_equalTo(250.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
    }];
    
    if (self.noCardView) {
        [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noCardView.bottom).offset(20.0f);
            make.width.equalTo(self.scrollView.width).offset(-40.0f);
            make.centerX.equalTo(self.scrollView.centerX);
            make.height.mas_equalTo (50.0f);
        }];
    } else {
        [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cardView.bottom).offset(20.0f);
            make.width.equalTo(self.scrollView.width).offset(-40.0f);
            make.centerX.equalTo(self.scrollView.centerX);
            make.height.mas_equalTo (50.0f);
        }];
    }
    
    [self.eventTitleImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawButton.bottom).offset(60.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);
        
    }];
    
    [self.eventRulesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventTitleImageView.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-60.0f);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventRulesLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.scrollView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:-20.0f]];
}

- (void)withdrawCash {
    __weak HHWithdrawViewController *weakSelf = self;
    if (!self.bankCard) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先添加银行卡"];
        return;
    }
    
    if ([self.cashAmountField.text floatValue] * 100 > [self.availableAmount floatValue]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"本次提现金额超过了您可提现金额"];
        return;
    }
    
    if ([self.cashAmountField.text floatValue] < 100 ) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"每次提现金额必须大于100元"];
        return;
    }
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] withdrawBonusWithAmount:@([self.cashAmountField.text floatValue] * 100) completion:^(BOOL succeed) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (succeed) {
            [[HHToastManager sharedManager] showSuccessToastWithText:@"提现提交成功, 请在提现记录里查看状态"];
            weakSelf.availableAmount = @([weakSelf.availableAmount floatValue] - [self.cashAmountField.text floatValue] * 100);
            weakSelf.cashAmountField.text = @"";
        } else {
            [[HHToastManager sharedManager] showSuccessToastWithText:@"提现失败!"];
        }
    }];
}


-(void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildCardView {
    if (self.cardView) {
        [self.cardView removeFromSuperview];
    }
    [self.noCardView removeFromSuperview];
    self.cardView = [[UIView alloc] init];
    [self.scrollView addSubview:self.cardView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_more"]];
    [self.cardView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.bankCard.bankName;
    label.textColor = [UIColor HHTextDarkGray];
    label.font = [UIFont systemFontOfSize:20.0f];
    [self.cardView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = [NSString stringWithFormat:@"%@, 尾号%@", self.bankCard.cardHolderName, [self.bankCard.cardNumber substringFromIndex:MAX((int)[self.bankCard.cardNumber length]-4, 0)]];
    label2.textColor = [UIColor HHLightTextGray];
    label2.font = [UIFont systemFontOfSize:12.0f];
    [self.cardView addSubview:label2];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHLightLineGray];
    [self.cardView addSubview:line];
    
    [self.cardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView.centerY);
        make.right.equalTo(self.cardView.right).offset(-20.0f);
    }];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardView.centerY);
        make.left.equalTo(self.cardView.left).offset(20.0f);
    }];
    
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.centerY).offset(5.0f);
        make.left.equalTo(self.cardView.left).offset(20.0f);
    }];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cardView.centerX);
        make.bottom.equalTo(self.cardView.bottom);
        make.width.equalTo(self.cardView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddCardView)];
    [self.cardView addGestureRecognizer:rec];
}

- (void)buildNoCardView {
    if (self.noCardView) {
        [self.noCardView removeFromSuperview];
    }
    [self.cardView removeFromSuperview];
    self.noCardView = [[UIView alloc] init];
    [self.scrollView addSubview:self.noCardView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_add"]];
    [self.noCardView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请先添加银行卡";
    label.textColor = [UIColor HHTextDarkGray];
    label.font = [UIFont systemFontOfSize:22.0f];
    [self.noCardView addSubview:label];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHLightLineGray];
    [self.noCardView addSubview:line];
    
    [self.noCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.noCardView.centerY);
        make.left.equalTo(self.noCardView.left).offset(20.0f);
    }];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.noCardView.centerY);
        make.left.equalTo(imgView.right).offset(20.0f);
    }];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noCardView.centerX);
        make.bottom.equalTo(self.noCardView.bottom);
        make.width.equalTo(self.noCardView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddCardView)];
    [self.noCardView addGestureRecognizer:rec];
    
}

- (void)showAddCardView {
    __weak HHWithdrawViewController *weakSelf = self;
    HHAddBankCardViewController *vc = [[HHAddBankCardViewController alloc] initWithCard:self.bankCard];
    vc.cardBlock = ^(HHBankCard *card) {
        weakSelf.bankCard = card;
        [weakSelf buildCardView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showHistoryVC {
    HHWithdrawHistoryViewController *vc = [[HHWithdrawHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setAvailableAmount:(NSNumber *)availableAmount {
    _availableAmount = availableAmount;
    self.availabeAmountValueLabel.text = [self.availableAmount generateMoneyString];
}

@end
