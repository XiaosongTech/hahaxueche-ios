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


static NSString *const kCellId = @"cellId";

@interface HHWithdrawViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *availabeAmountTitleLabel;
@property (nonatomic, strong) UILabel *availabeAmountValueLabel;
@property (nonatomic, strong) UILabel *cashAmountTitleLabel;
@property (nonatomic, strong) UITextField *cashAmountField;

@property (nonatomic, strong) UIButton *withdrawButton;
@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic, strong) NSNumber *withdrawAmount;
@property (nonatomic, strong) NSNumber *availableAmount;

@property (nonatomic, strong) UIView *noCardView;
@property (nonatomic, strong) UIView *cardView;


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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
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
    
    self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.withdrawButton setTitle:@"确认提现" forState:UIControlStateNormal];
    [self.withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.withdrawButton.backgroundColor = [UIColor HHOrange];
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    [self.withdrawButton addTarget:self action:@selector(withdrawCash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.withdrawButton];
    
    [self buildNoCardView];
    
    [self makeConstraints];
}

- (UILabel *)buildLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = textColor;
    label.font = font;
    return label;
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
    
    
    [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-50.0f);
        make.width.mas_equalTo(315.0f);
        make.centerX.equalTo(self.view.centerX);
        make.height.mas_equalTo (50.0f);
    }];
}

- (void)withdrawCash {
    
}



//- (void)showConfirmPopup {
//    if (!self.alipayAccount || !self.ownerName) {
//        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入支付宝账户信息"];
//        return;
//    }
//    
//    __weak HHWithdrawViewController *weakSelf = self;
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    paragraphStyle.lineSpacing = 8.0f;
//    
//    NSNumber *alipayFee = @([self.withdrawAmount floatValue] * 0.005);
//    if ([alipayFee floatValue] < 100.0f) {
//        alipayFee = @(100);
//    }
//    
//    if ([alipayFee floatValue] > 2500.0f) {
//        alipayFee = @(2500);
//    }
//    
//    NSNumber *trueAmount = @([self.withdrawAmount floatValue] - [alipayFee floatValue]);
//    
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"提现金额: %@\n支付宝手续费: %@\n实际提现: %@", [self.withdrawAmount generateMoneyString], [alipayFee generateMoneyString], [trueAmount generateMoneyString]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
//    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 300.0f) title:@"确认提现" subTitle:@"提现明细" info:attrString leftButtonTitle:@"取消返回" rightButtonTitle:@"确认提现"];
//    view.cancelBlock = ^() {
//        [HHPopupUtility dismissPopup:weakSelf.popup];
//    };
//    view.confirmBlock = ^() {
//        [[HHStudentService sharedInstance] withdrawBonusWithAmount:self.withdrawAmount accountName:self.ownerName account:self.alipayAccount completion:^(HHWithdraw *withdraw, NSError *error) {
//            if (!error) {
//                [HHPopupUtility dismissPopup:weakSelf.popup];
//                [[HHToastManager sharedManager] showSuccessToastWithText:@"客官请稍等,已奔赴银行取钱!"];
//                self.availableAmount = @([self.availableAmount floatValue] - [withdraw.amount floatValue]);
//                self.availabeAmountValueLabel.text = [self.availableAmount generateMoneyString];
//                if (self.updateAmountsBlock) {
//                    self.updateAmountsBlock(withdraw.amount);
//                }
//            } else {
//                [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
//            }
//        }];
//    };
//    self.popup = [HHPopupUtility createPopupWithContentView:view];
//    [HHPopupUtility showPopup:self.popup];
//    
//}

-(void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildNoCardView {
    self.noCardView = [[UIView alloc] init];
    [self.view addSubview:self.noCardView];
    
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
        make.top.equalTo(self.topView.bottom).offset(20.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
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
        make.width.equalTo(self.noCardView.width).offset (-40.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddCardView)];
    [self.noCardView addGestureRecognizer:rec];
    
}

- (void)showAddCardView {
    HHAddBankCardViewController *vc = [[HHAddBankCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
