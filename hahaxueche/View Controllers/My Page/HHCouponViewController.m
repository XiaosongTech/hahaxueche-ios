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
#import "HHStudentStore.h"
#import "HHStudent.h"
#import "HHCouponFAQView.h"
#import "HHWebViewController.h"

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


@end

@implementation HHCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.student = [HHStudentStore sharedInstance].currentStudent;
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.ticketView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ticket-normal"]];
    [self.view addSubview:self.ticketView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.titleLabel.text = @"哈哈学车免费试学券";
    [self.ticketView addSubview:self.titleLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
    self.statusLabel.hidden = YES;
    [self.ticketView addSubview:self.statusLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.subTitleLabel.textColor = [UIColor HHOrange];
    [self.ticketView addSubview:self.subTitleLabel];
    
    
    self.bonusLabel = [[UILabel alloc] init];
    self.bonusLabel.font = [UIFont systemFontOfSize:12.0f];
    self.bonusLabel.numberOfLines = 0;
    self.bonusLabel.textColor = [UIColor HHLightTextGray];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"使用后我们会致电联系接送事宜, 优质服务提前体验, 试学过程100%免费." attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    self.bonusLabel.attributedText = attributedString1;
    self.ticketView.userInteractionEnabled = YES;
    [self.ticketView addSubview:self.bonusLabel];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"立即\n使用" forState:UIControlStateNormal];
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
    
    [self.bonusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(10.0f);
        make.left.equalTo(self.titleLabel.left);
        make.width.equalTo(self.ticketView.width).multipliedBy(2.0f/3.0f);
    }];
    
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ticketView.centerY);
        make.right.equalTo(self.ticketView.right).offset(-25.0f);
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
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.faq5.bottom).offset(10.0f);
    }];
    
}


- (void)buttonTapped {
    
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

@end
