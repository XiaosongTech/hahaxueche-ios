//
//  HHVouchersViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 10/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHVouchersViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHStudentStore.h"
#import "HHVoucher.h"
#import "HHVoucherView.h"
#import "HHStudentService.h"
#import "HHLoadingViewUtility.h"
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"
#import "HHStudentService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"

static NSString *const kRuleString = @"1）什么是哈哈学车代金券\n哈哈学车代金券是哈哈学车平台对外发行和认可的福利活动，可凭此代金券券享受学车立减的优惠金额。\n2）如何激活哈哈学车代金券\n在页面上方输入框中输入活动对应优惠码, 点击激活即可。\n3）哈哈学车代金券使用说明\na.代金券仅限在哈哈学车APP支付学费时使用，每个订单只能使用一张代金券，且一次性使用，不能拆分，不能提现，不能转赠，不能与其他代金券叠加使用。\nb.代金券只能在有效期内使用。\nc.代金券的最终解释权归哈哈学车所有。\n";

static NSString *const kSupportString = @"\n*如有其他疑问请联系客服或您的专属学车顾问\n哈哈学车客服热线：400-001-6006\n哈哈学车在线客服";

@interface HHVouchersViewController () <TTTAttributedLabelDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HHStudent *student;
@property (nonatomic, strong) TTTAttributedLabel *supportLabel;
@property (nonatomic, strong) TTTAttributedLabel *rulesLabel;
@property (nonatomic, strong) UIView *getVoucherContainerView;
@property (nonatomic, strong) UITextField *voucherCodeField;
@property (nonatomic, strong) UIButton *activateButton;
@property (nonatomic, strong) NSMutableArray *vouchers;

@end

@implementation HHVouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代金券";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.student = [HHStudentStore sharedInstance].currentStudent;
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] fetchStudentWithId:self.student.studentId completion:^(HHStudent *student, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            self.student = student;
            self.vouchers = [NSMutableArray arrayWithArray:self.student.vouchers];
            if ([self.vouchers count] > 0) {
                [self buildNormalViews];
            } else {
                [self buildEmptyView];
            }
        }
    }];
    
}

- (void)buildEmptyView {
    
    self.getVoucherContainerView = [self buildGetVoucherView];
    [self.view addSubview:self.getVoucherContainerView];
    [self.getVoucherContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_redbag"]];
    [self.view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.centerY).offset(-20.0f);
    }];
    
    self.supportLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.supportLabel.attributedText = [self buildAttributeString];
    self.supportLabel.delegate = self;
    self.supportLabel.numberOfLines = 0;
    self.supportLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.supportLabel];
    [self.supportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.bottom).offset(40.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-40.0f);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapRec];
    
}

- (void)buildNormalViews {
    self.getVoucherContainerView = [self buildGetVoucherView];
    [self.view addSubview:self.getVoucherContainerView];
    [self.getVoucherContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getVoucherContainerView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:tapRec];
    
    [self buildVoucherViews];
    [self buildRulesView];
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildVoucherViews {
    int i = 0;
    for (HHVoucher *voucher in self.vouchers) {
        HHVoucherView *view = [[HHVoucherView alloc] initWithVoucher:voucher];
        [self.scrollView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.left).offset(20.0f);
            make.width.equalTo(self.scrollView.width).offset(-40.0f);
            make.height.mas_equalTo(90.0f);
            make.top.equalTo(self.scrollView.top).offset(20.0f + i * 110.0f);
        }];
        i++;
    }
}

- (void)buildRulesView {
    self.rulesLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.rulesLabel.attributedText = [self buildAttributeStringForRules];
    self.rulesLabel.delegate = self;
    self.rulesLabel.numberOfLines = 0;
    self.rulesLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.rulesLabel];
    [self.rulesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top).offset(110.0f * self.vouchers.count + 40.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-40.0f);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.rulesLabel
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];

}

- (NSMutableAttributedString *)buildAttributeString {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 3.0f;
    NSString *baseString = @"Sorry,您还没有代金券\n联系学车顾问400-001-6006或在线客服咨询代金券\n抓住这个磨人的小妖精";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paraStyle}];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:[baseString rangeOfString:@"400-001-6006"]];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:[baseString rangeOfString:@"在线客服"]];
    
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[baseString rangeOfString:@"400-001-6006"]];
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[baseString rangeOfString:@"在线客服"]];
    
    
    return attrString;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
    } else {
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}

- (NSMutableAttributedString *)buildAttributeStringForRules {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:kRuleString attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paraStyle}];

    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:kSupportString attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paraStyle}];
    
    [attrString2 addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[kSupportString rangeOfString:@"400-001-6006"]];
    [attrString2 addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[kSupportString rangeOfString:@"在线客服"]];
    
    [attrString appendAttributedString:attrString2];
    
    [self.rulesLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[[kRuleString stringByAppendingString:kSupportString] rangeOfString:@"400-001-6006"]];
    [self.rulesLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[[kRuleString stringByAppendingString:kSupportString] rangeOfString:@"在线客服"]];
    
    
    return attrString;
}

- (UIView *)buildGetVoucherView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor HHBackgroundGary];
    
    self.activateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.activateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.activateButton setTitle:@"激活" forState:UIControlStateNormal];
    [self.activateButton setBackgroundColor:[UIColor HHOrange]];
    self.activateButton.layer.masksToBounds = YES;
    self.activateButton.layer.cornerRadius = 5.0f;
    [self.activateButton addTarget:self action:@selector(activateVoucher) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.activateButton];
    [self.activateButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right).offset(-20.0f);
        make.width.mas_equalTo(75.0f);
        make.height.mas_equalTo(35.0f);
    }];
    
    self.voucherCodeField = [[UITextField alloc] init];
    self.voucherCodeField.borderStyle = UITextBorderStyleRoundedRect;
    self.voucherCodeField.placeholder = @"输入优惠码";
    self.voucherCodeField.font = [UIFont systemFontOfSize:13.0f];
    self.voucherCodeField.tintColor = [UIColor HHOrange];
    self.voucherCodeField.textColor = [UIColor darkTextColor];
    [view addSubview:self.voucherCodeField];
    [self.voucherCodeField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(self.activateButton.left).offset(-10.0f);
        make.left.equalTo(view.left).offset(20.0f);
        make.height.mas_equalTo(35.0f);
    }];
    
    
    return view;
}

- (void)activateVoucher {
    if ([self.voucherCodeField.text isEqualToString:@""]) {
        return;
    }
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] activateVoucherWithCode:self.voucherCodeField.text completion:^(HHVoucher *voucher, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            [[HHToastManager sharedManager] showSuccessToastWithText:@"激活成功"];
            [self didAddNewVoucher:voucher];
            
        } else {
            [[HHToastManager sharedManager] showSuccessToastWithText:@"优惠码无效或者已过期"];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.voucherCodeField resignFirstResponder];
}

- (void)hideKeyboard {
    [self.voucherCodeField resignFirstResponder];
}

- (void)didAddNewVoucher:(HHVoucher *)voucher {
    [self.voucherCodeField resignFirstResponder];
    [self.vouchers addObject:voucher];
    HHVoucherView *view = [[HHVoucherView alloc] initWithVoucher:voucher];
    [self.scrollView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(90.0f);
        make.top.equalTo(self.scrollView.top).offset(20.0f + (self.vouchers.count - 1) * 110.0f);
    }];
    
    [self.rulesLabel removeFromSuperview];
    self.rulesLabel = nil;
    [self buildRulesView];
    
}




@end
