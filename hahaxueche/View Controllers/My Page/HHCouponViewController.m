//
//  HHCouponViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCouponViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCouponFAQView.h"
#import "HHWebViewController.h"
#import "HHSocialMediaShareUtility.h"
#import "HHActivateCouponView.h"
#import "HHPopupUtility.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHAddPromoCodeView.h"
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentStore.h"
#import "HHSupportUtility.h"

typedef void (^HHSupportViewBlock)();

@interface HHCouponViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HHStudent *student;
@property (nonatomic, strong) UIImageView *ticketView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *bonusLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *grayLine1;
@property (nonatomic, strong) UIView *grayLine2;
@property (nonatomic, strong) UIButton *ruleButton;

@property (nonatomic, strong) HHCouponFAQView *faq1;
@property (nonatomic, strong) HHCouponFAQView *faq2;
@property (nonatomic, strong) HHCouponFAQView *faq3;
@property (nonatomic, strong) HHCouponFAQView *faq4;
@property (nonatomic, strong) HHCouponFAQView *faq5;
@property (nonatomic, strong) UIView *supportNumberView;
@property (nonatomic, strong) UIView *onlineSupportView;
@property (nonatomic, strong) HHCoupon *coupon;
@property (nonatomic, strong) KLCPopup *popup;


@end

@implementation HHCouponViewController

- (instancetype)initWithStudent:(HHStudent *)student {
    self = [super init];
    if (self) {
        self.student = student;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    if (![self.student.purchasedServiceArray count] && ![self.student.coupons count]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"添加" titleColor:[UIColor whiteColor] action:@selector(addPromoCode) target:self isLeft:NO];
    }
    
    if ([self.student.coupons count]) {
        self.coupon = [self.student.coupons firstObject];
    }
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    NSString *title = @"哈哈学车免费试学券";
    NSString *bonusText = @"使用后我们会致电联系接送事宜, 优质服务提前体验, 试学过程100%免费.";
    NSString *subTitleText;
    
    if ([self hasCoupon]) {
        title = [NSString stringWithFormat:@"%@优惠券", self.coupon.channelName];
        bonusText = [self buildBonusString];
        subTitleText = @"即日起报名成功后即可获得:";
    }
    
    self.ticketView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ticket-normal"]];
    if ([self.coupon.status integerValue] == 2) {
        self.ticketView.image = [UIImage imageNamed:@"ticket-gray"];
    }
    [self.view addSubview:self.ticketView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.titleLabel.text = title;
    [self.ticketView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.subTitleLabel.text = subTitleText;
    self.subTitleLabel.textColor = [UIColor HHOrange];
    [self.ticketView addSubview:self.subTitleLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
    self.statusLabel.text = [self statusText];
    self.statusLabel.textColor = [self statusTextColor];
    self.statusLabel.layer.borderColor = [self statusTextColor].CGColor;
    self.statusLabel.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    [self.ticketView addSubview:self.statusLabel];
    
    
    self.bonusLabel = [[UILabel alloc] init];
    self.bonusLabel.font = [UIFont systemFontOfSize:12.0f];
    self.bonusLabel.numberOfLines = 0;
    self.bonusLabel.textColor = [UIColor HHLightTextGray];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:bonusText attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    self.bonusLabel.attributedText = attributedString1;
    self.ticketView.userInteractionEnabled = YES;
    [self.ticketView addSubview:self.bonusLabel];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:[self buildButtonTitle] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.button.titleLabel.numberOfLines = 0;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ticketView addSubview:self.button];
    
    self.grayLine1 = [[UIView alloc] init];
    self.grayLine1.backgroundColor = [UIColor HHLightLineGray];
    [self.view addSubview:self.grayLine1];
    
    self.grayLine2 = [[UIView alloc] init];
    self.grayLine2.backgroundColor = [UIColor HHLightLineGray];
    [self.view addSubview:self.grayLine2];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"优惠券使用规则" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic-explain"];
    textAttachment.bounds = CGRectMake(-2.0f, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    
    self.ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ruleButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self.ruleButton addTarget:self action:@selector(ruleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ruleButton];

    __weak HHCouponViewController *weakSelf = self;
    self.faq1 = [[HHCouponFAQView alloc] initWithTitle:@"1.什么是哈哈学车优惠券?" text:@"哈哈学车优惠券是指哈哈学车平台对外发行和认可的福利活动，在哈哈学车APP或哈哈学车官网上成功报名支付后，可凭此礼金券享受对应的礼金金额或奖励。" linkText:nil linkURL:nil];
    self.faq1.linkBlock = ^(NSURL *url){
        [weakSelf openWebViewWithURL:url];
    };
    [self.scrollView addSubview:self.faq1];
    
    self.faq2 = [[HHCouponFAQView alloc] initWithTitle:@"2.如何获得哈哈学车优惠券？" text:@"关注哈哈学车官方平台，哈哈学车会不定期在线上线下为学员争取最大福利。同时注册用户也可参加推荐有奖活动，每邀请一位好友学车，你和好友一起获得￥200元现金奖励，累计无上限，随时可提现！点击查看>> 推荐有奖详情" linkText:@"点击查看>>" linkURL:@"http://m.hahaxueche.com/invitations"];
    self.faq2.linkBlock = ^(NSURL *url){
        [weakSelf openWebViewWithURL:url];
    };
    [self.scrollView addSubview:self.faq2];
    
    self.faq3 = [[HHCouponFAQView alloc] initWithTitle:@"3.哈哈学车优惠券的使用条件？" text:@"-礼金券仅限领取时的账号使用，不可提现，买卖，转赠他人；\n-仅限在线支付使用，每个订单只能使用一张礼金券，不能与其他礼金券或优惠活动叠加使用；\n-使用礼金券时的注册手机号需与领取礼金券时的手机号一致，领取后在有效期内使用；\n-同一注册账号、手机号、支付账号、设备以及其他相同或相似的身份信息，均视为同一用户。" linkText:nil linkURL:nil];
    self.faq3.linkBlock = ^(NSURL *url){
        [weakSelf openWebViewWithURL:url];
    };
    [self.scrollView addSubview:self.faq3];
    
    self.faq4 = [[HHCouponFAQView alloc] initWithTitle:@"4.分期乐支付报名的用户，可以享受优惠活动吗？" text:@"哈哈学车携手国内领先的分期购物在线商城分期乐，达成战略合作，为大学生等年轻人提供“先消费后付款”、方便快捷的极致学车体验。采用分期方式报名的学员和支付全款的学员在学车过程中，同等享受优惠活动和哈哈学车的优质服务。点击查看>> 分期学车详情" linkText:@"点击查看>>" linkURL:@"http://meh-static.oss-cn-hangzhou.aliyuncs.com/fenqile/index.html"];
    self.faq4.linkBlock = ^(NSURL *url){
        [weakSelf openWebViewWithURL:url];
    };
    [self.scrollView addSubview:self.faq4];
    
    self.faq5 = [[HHCouponFAQView alloc] initWithTitle:@"5.报名支付后要求退学，优惠券金额或奖励还能享受吗？" text:@"哈哈学车所有的合作教练，都是我们专业团队经过暗访-明察-抽检-签约，以百里挑一的比例精选出来的，都签署了专门的合同，保证学员免费试学、灵活退学。如果学员由于某种原因要求退学，哈哈学车会全力保障学员权利、协助办理退学退费，退学的费用以扣去优惠券金额后的学员实际支付金额为准" linkText:nil linkURL:nil];
    self.faq5.linkBlock = ^(NSURL *url){
        [weakSelf openWebViewWithURL:url];
    };
    [self.scrollView addSubview:self.faq5];
    
    self.supportNumberView = [self buildSupportViewWithTitle:@"哈哈学车客服热线: " value:@"400-001-6006"];
    [self.scrollView addSubview:self.supportNumberView];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callSupport)];
    [self.supportNumberView addGestureRecognizer:rec];
    
    self.onlineSupportView = [self buildSupportViewWithTitle:@"哈哈客服: " value:@"在线客服"];
    [self.scrollView addSubview:self.onlineSupportView];
    
    UITapGestureRecognizer *rec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOnlineSupportVC)];
    [self.onlineSupportView addGestureRecognizer:rec2];
    
    
    [self makeConstraints];
    
}

- (void)makeConstraints {

    [self.ticketView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(10.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-28.0f);
        
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ticketView.top).offset(15.0f);
        make.left.equalTo(self.ticketView.left).offset(17.0f);
        
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(12.0f);
        make.left.equalTo(self.titleLabel.left);
    }];
    
    [self.bonusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.bottom).offset(5.0f);
        make.left.equalTo(self.titleLabel.left);
        make.width.equalTo(self.ticketView.width).multipliedBy(2.0f/3.0f);
    }];
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.centerX.equalTo(self.ticketView.centerX).multipliedBy(1.3f);
    }];
    
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ticketView.centerY);
        make.centerX.equalTo(self.ticketView.centerX).multipliedBy(1.75f);
    }];
    
    [self.ruleButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ticketView.bottom).offset(20.0f);
        make.centerX.equalTo(self.view.centerX);
    }];
    
    [self.grayLine1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ruleButton.centerY);
        make.left.equalTo(self.ticketView.left);
        make.right.equalTo(self.ruleButton.left).offset(-5.0f);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.grayLine2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ruleButton.centerY);
        make.left.equalTo(self.ruleButton.right).offset(2.0f);
        make.right.equalTo(self.ticketView.right);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ruleButton.bottom).offset(5.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [self.faq1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.bottom.equalTo(self.faq1.textLabel.bottom).offset(8.0f);
        make.width.equalTo(self.scrollView.width);
    }];

    [self.faq2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faq1.bottom).offset(6.0f);
        make.left.equalTo(self.scrollView.left);
        make.bottom.equalTo(self.faq2.textLabel.bottom).offset(8.0f);
        make.width.equalTo(self.scrollView.width);
    }];
    
    [self.faq3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faq2.bottom).offset(6.0f);
        make.left.equalTo(self.scrollView.left);
        make.bottom.equalTo(self.faq3.textLabel.bottom).offset(8.0f);
        make.width.equalTo(self.scrollView.width);
    }];
    
    [self.faq4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faq3.bottom).offset(6.0f);
        make.left.equalTo(self.scrollView.left);
        make.bottom.equalTo(self.faq4.textLabel.bottom).offset(8.0f);
        make.width.equalTo(self.scrollView.width);
    }];
    
    [self.faq5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faq4.bottom).offset(6.0f);
        make.left.equalTo(self.scrollView.left);
        make.bottom.equalTo(self.faq5.textLabel.bottom).offset(8.0f);
        make.width.equalTo(self.scrollView.width);
    }];
    
    [self.supportNumberView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faq5.bottom).offset(6.0f);
        make.left.equalTo(self.scrollView.left);
        make.height.mas_equalTo(50.0f);
        make.width.equalTo(self.scrollView.width);
    }];
    
    [self.onlineSupportView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportNumberView.bottom).offset(6.0f);
        make.left.equalTo(self.scrollView.left);
        make.height.mas_equalTo(50.0f);
        make.width.equalTo(self.scrollView.width);
    }];
    
    
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.onlineSupportView.bottom).offset(10.0f);
    }];
    
}


- (void)buttonTapped {
    __weak HHCouponViewController *weakSelf = self;
    if ([self hasCoupon]) {
        if ([self.coupon.status integerValue] == 0) {
            //立即激活
            HHActivateCouponView *view = [[HHActivateCouponView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-40.0f, 220)];
            view.actionBlock = ^(){
                [HHPopupUtility dismissPopup:weakSelf.popup];
                [weakSelf tryCoachForFree];
            };
            self.popup = [HHPopupUtility createPopupWithContentView:view];
            [HHPopupUtility showPopup:self.popup];
        } else if ([self.coupon.status integerValue] == 1) {
            //立即领取
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请尽快前往%@领取改优惠券.", self.coupon.channelName] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
            HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-40.0f, 270.0f) title:@"领取优惠券" subTitle:@"恭喜您获得该优惠券!" info:attributedString];
            view.cancelBlock = ^() {
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            self.popup = [HHPopupUtility createPopupWithContentView:view];
            [HHPopupUtility showPopup:self.popup];
        } else {
            //已领取
        }
    } else {
        //免费试学
        [self tryCoachForFree];
    }

}

- (void)ruleButtonTapped {
    self.scrollView.hidden = !self.scrollView.hidden;
    self.scrollView.scrollEnabled = YES;
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openWebViewWithURL:(NSURL *)url {
    HHWebViewController *vc = [[HHWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)buildSupportViewWithTitle:(NSString *)title value:(NSString *)value {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    [attributedString appendAttributedString:attributedString2];
    label.attributedText = attributedString;
    [view addSubview:label];
    [label sizeToFit];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(14.0f);
    }];
    
    return view;
}

- (void)showOnlineSupportVC {
    [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
}

- (void)callSupport {
    NSString *phNo = @"4000016006";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

- (NSString *)buildBonusString {
    NSMutableString * bonusString = [[NSMutableString alloc] initWithString:@""];
    for (NSString *bonus in self.coupon.content) {
        [bonusString appendString:[NSString stringWithFormat:@"- %@\n", bonus]];
    }
    return bonusString;
}

- (NSString *)buildButtonTitle {
    if ([self hasCoupon]) {
        if ([self.coupon.status integerValue] == 0) {
            return @"立即\n激活";
        } else if ([self.coupon.status integerValue] == 1) {
            return @"立即\n领取";
        } else {
            return @"已领取";
        }
    } else {
        return @"立即\n使用";
    }
}

- (void)tryCoachForFree {
    NSString *urlBase = @"http://m.hahaxueche.com/free_trial";
    NSString *paramString;
    NSString *url;
    if(self.student.studentId) {
        paramString = [NSString stringWithFormat:@"?name=%@&phone=%@&city_id=%@", self.student.name, self.student.cellPhone, [self.student.cityId stringValue]];
        url = [NSString stringWithFormat:@"%@%@", urlBase, paramString];
        [self openWebPage:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        [self openWebPage:[NSURL URLWithString:urlBase]];
    }
    
}

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.title = @"哈哈学车";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (BOOL)hasCoupon {
    if (!self.coupon) {
        return NO;
    } else {
        if ([self.coupon.content count]) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (NSString *)statusText {
    if ([self hasCoupon]) {
        if ([self.coupon.status integerValue] == 0) {
            return @"未激活";
        } else if ([self.coupon.status integerValue] == 1) {
            return @"待领取";
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

- (UIColor *)statusTextColor {
    if ([self hasCoupon]) {
        if ([self.coupon.status integerValue] == 0) {
            return [UIColor HHConfirmGreen];
        } else if ([self.coupon.status integerValue] == 1) {
            return [UIColor HHOrange];
        } else {
            return [UIColor whiteColor];
        }
    } else {
        return [UIColor whiteColor];
    }
}

- (void)addPromoCode {
    __weak HHCouponViewController *weakSelf = self;
    HHAddPromoCodeView *view = [[HHAddPromoCodeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-40.0f, 220.0f)];
    view.confirmBlock = ^(NSString *promoCode) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHStudentService sharedInstance] setupStudentInfoWithStudentId:self.student.studentId userName:self.student.name cityId:self.student.cityId promotionCode:promoCode completion:^(HHStudent *student, NSError *error) {
            if (!error) {
                [[HHStudentService sharedInstance] fetchStudentWithId:self.student.studentId completion:^(HHStudent *student, NSError *error) {
                    [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                    if (!error) {
                        [[HHToastManager sharedManager] showSuccessToastWithText:@"添加成功!"];
                        [HHStudentStore sharedInstance].currentStudent = student;
                        self.student = student;
                        self.coupon = [self.student.coupons firstObject];
                        [self updateView];
                    } else {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试！"];
                    }
                    
                }];
            } else {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                if ([error.localizedFailureReason isEqual:@(40022)]) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"请输入正确有效的优惠码"];
                } else {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试！"];
                }
                
            }

        }];
    };
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];

    
}

- (void)updateView {
    if ([self hasCoupon]) {
        [HHPopupUtility dismissPopup:self.popup];
        if ([self.coupon.status integerValue] == 2) {
            self.ticketView.image = [UIImage imageNamed:@"ticket-gray"];
        } else {
            self.ticketView.image = [UIImage imageNamed:@"ticket-normal"];
        }
        self.titleLabel.text = [NSString stringWithFormat:@"%@优惠券", self.coupon.channelName];
        
        self.statusLabel.text = [self statusText];
        self.statusLabel.textColor = [self statusTextColor];
        self.statusLabel.layer.borderColor = [self statusTextColor].CGColor;
        self.statusLabel.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        
        self.subTitleLabel.text = @"即日起报名成功后即可获得:";
        self.bonusLabel.text = [self buildBonusString];
        self.navigationItem.rightBarButtonItem = nil;
        
        [self.button setTitle:[self buildButtonTitle] forState:UIControlStateNormal];

    }
}


@end
