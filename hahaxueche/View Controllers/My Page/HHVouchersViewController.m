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
#import "HHWebViewController.h"
#import "HHFreeTrialUtility.h"

static NSString *const kRuleString = @"1）什么是哈哈学车代金券\n哈哈学车代金券是哈哈学车平台对外发行和认可的福利活动，可凭此代金券券享受学车立减的优惠金额。\n2）如何激活哈哈学车代金券\n在页面上方输入框中输入活动对应优惠码, 点击激活即可。\n3）哈哈学车代金券使用说明\na.代金券仅限在哈哈学车APP支付学费时使用，每个订单只能使用一张代金券，且一次性使用，不能拆分，不能提现，不能转赠，不能与其他代金券叠加使用。\nb.代金券只能在有效期内使用。\nc.代金券的最终解释权归哈哈学车所有。\n";
static NSString *const kRuleString2 = @"1）什么是哈哈学车代金券\n哈哈学车代金券是哈哈学车平台对外发行和认可的福利活动，可凭此代金券券享受学车立减的优惠金额。\n2）如何激活哈哈学车代金券\n无门槛￥100代金券只要在哈哈学车免费试学即可激活。\n3）哈哈学车代金券使用说明\na.代金券仅限在哈哈学车APP支付学费时使用，每个订单只能使用一张代金券，且一次性使用，不能拆分，不能提现，不能转赠，不能与其他代金券叠加使用。\nb.代金券只能在有效期内使用。\nc.代金券的最终解释权归哈哈学车所有。\n";

static NSString *const kSupportString = @"\n*如有其他疑问请联系客服或您的专属学车顾问\n哈哈学车客服热线：400-001-6006\n哈哈学车在线客服";

@interface HHVouchersViewController () <TTTAttributedLabelDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HHStudent *student;
@property (nonatomic, strong) TTTAttributedLabel *supportLabel;
@property (nonatomic, strong) TTTAttributedLabel *rulesLabel;
@property (nonatomic, strong) UIView *getVoucherContainerView;
@property (nonatomic, strong) UIImageView *emptyImgView;
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
    
    if([self.student isLoggedIn]) {
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
    } else {
        [self buildGuestView];
    }
    
    
}

- (void)buildGuestView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    HHVoucher *fakeVoucher = [[HHVoucher alloc] init];
    fakeVoucher.title = @"试学就送代金券";
    fakeVoucher.amount = @(10000);
    fakeVoucher.status = @(0);
    HHVoucherView *voucherView = [[HHVoucherView alloc] initWithVoucher:fakeVoucher];
    [self.scrollView addSubview:voucherView];
    [voucherView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(90.0f);
        make.top.equalTo(self.scrollView.top).offset(20.0f);
    }];

    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"免费试学即可领取¥100元代金券-学车报名立减哦~\n赶快点击按钮申请免费试学吧!";
    textLabel.font = [UIFont systemFontOfSize:12.0f];
    textLabel.textColor = [UIColor HHOrange];
    [self.scrollView addSubview:textLabel];
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.top.equalTo(voucherView.bottom).offset(20.0f);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"免费试学" forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(freeTrial) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor HHOrange];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    [self.scrollView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.centerX);
        make.top.equalTo(textLabel.bottom).offset(10.0f);
        make.width.mas_equalTo(CGRectGetWidth(button.bounds) + 30.0f);
        make.height.mas_equalTo(CGRectGetHeight(button.bounds) + 8.0f);
    }];
    
    self.rulesLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.rulesLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.rulesLabel.attributedText = [self buildAttributeStringForRules];
    self.rulesLabel.delegate = self;
    self.rulesLabel.numberOfLines = 0;
    self.rulesLabel.textAlignment = NSTextAlignmentLeft;
    self.rulesLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.rulesLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    [self.scrollView addSubview:self.rulesLabel];
    [self.rulesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.bottom).offset(20.0f);
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
    [self.rulesLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[self.rulesLabel.attributedText.string rangeOfString:@"400-001-6006"]];
    [self.rulesLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[self.rulesLabel.attributedText.string rangeOfString:@"在线客服"]];


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
    
    self.emptyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_redbag"]];
    [self.view addSubview:self.emptyImgView];
    [self.emptyImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.centerY).offset(-20.0f);
    }];
    
    self.supportLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.supportLabel.attributedText = [self buildAttributeString];
    self.supportLabel.delegate = self;
    self.supportLabel.numberOfLines = 0;
    self.supportLabel.textAlignment = NSTextAlignmentCenter;
    self.supportLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    [self.view addSubview:self.supportLabel];
    [self.supportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImgView.bottom).offset(40.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-40.0f);
    }];
    
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[self.supportLabel.attributedText.string rangeOfString:@"400-001-6006"]];
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[self.supportLabel.attributedText.string rangeOfString:@"在线客服"]];
    
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
    
    [self buildVoucherViews];
    [self buildRulesView];
}


- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    self.rulesLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.rulesLabel.attributedText = [self buildAttributeStringForRules];
    self.rulesLabel.delegate = self;
    self.rulesLabel.numberOfLines = 0;
    self.rulesLabel.textAlignment = NSTextAlignmentLeft;
    self.rulesLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.rulesLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    [self.scrollView addSubview:self.rulesLabel];
    [self.rulesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top).offset(110.0f * self.vouchers.count + 40.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-40.0f);
    }];
    
    [self.rulesLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[self.rulesLabel.attributedText.string rangeOfString:@"400-001-6006"]];
    [self.rulesLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[self.rulesLabel.attributedText.string rangeOfString:@"在线客服"]];
    
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
    NSString *baseRuleString = kRuleString;
    if (![self.student isLoggedIn]) {
        baseRuleString = kRuleString2;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:baseRuleString attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paraStyle}];

    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:kSupportString attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paraStyle}];
    
    [attrString2 addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[kSupportString rangeOfString:@"400-001-6006"]];
    [attrString2 addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[kSupportString rangeOfString:@"在线客服"]];
    
    [attrString appendAttributedString:attrString2];
    
    
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
    self.voucherCodeField.returnKeyType = UIReturnKeyDone;
    self.voucherCodeField.delegate = self;
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
            if ([error.localizedFailureReason intValue] == 40023) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"您已经激活该代金券, 无需重复激活"];
            } else if ([error.localizedFailureReason intValue] == 40004) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"无效的优惠码"];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"激活出错, 请重试"];
            }
            
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
    self.voucherCodeField.text = @"";
    [self.voucherCodeField resignFirstResponder];
    [self.vouchers addObject:voucher];
    
    
    self.emptyImgView.hidden = YES;
    self.supportLabel.hidden = YES;
    if(!self.scrollView) {
        [self buildNormalViews];
    }
    
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


- (void)freeTrial {
    NSString *urlString = [[HHFreeTrialUtility sharedManager] buildFreeTrialURLStringWithCoachId:nil];
    HHWebViewController *vc = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.voucherCodeField resignFirstResponder];
    return YES;
}



@end
