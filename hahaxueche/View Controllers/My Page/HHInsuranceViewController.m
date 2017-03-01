//
//  HHInsuranceViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHInsuranceViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "HHRootViewController.h"
#import "HHPurchaseInsuranceViewController.h"
#import "HHStudentStore.h"
#import "HHIntroViewController.h"

static NSString *const kStepString = @"1.点击下载二维码\n2.打开微信扫描此二维码关注哈哈学车官方公众号\n3.进入公众号点击右下角\"哈哈学车\"选择子菜单\"我要理赔\"";
static NSString *const kSupportString = @"如果问题请联系400-001-6006或联系在线客服";

@interface HHInsuranceViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *insuranceInfoTitleView;
@property (nonatomic, strong) UIView *insuranceDetailTitleView;
@property (nonatomic, strong) UIView *insuranceClaimTitleView;

@property (nonatomic, strong) UIView *insuranceInfoView;
@property (nonatomic, strong) UIView *insuranceDetailView;
@property (nonatomic, strong) UIView *insuranceClaimView;

@end

@implementation HHInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的赔付宝";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];

    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    self.insuranceInfoTitleView = [self buildTitleViewWithTitle:@"您还没购买赔付宝服务, 请根据实际情况选购."];
    [self.scrollView addSubview:self.insuranceInfoTitleView];
    [self.insuranceInfoTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self buildInsuranceInfoView];
    
    self.insuranceDetailTitleView = [self buildTitleViewWithTitle:@"理赔范围"];
    [self.scrollView addSubview:self.insuranceDetailTitleView];
    [self.insuranceDetailTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.insuranceInfoView.bottom).offset(15.0f);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self buildInsuranceDetailView];
    
    self.insuranceClaimTitleView = [self buildTitleViewWithTitle:@"如何理赔"];
    [self.scrollView addSubview:self.insuranceClaimTitleView];
    [self.insuranceClaimTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.insuranceDetailView.bottom).offset(15.0f);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self buildInsuranceClaimView];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.insuranceClaimView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0]];

}


- (UIView *)buildTitleViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor HHOrange];
    [view addSubview:label];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(15.0f);
    }];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:botLine];
    [botLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.bottom);
        make.left.equalTo(view.left);
        make.width.equalTo(view.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    return view;
}

- (void)buildInsuranceInfoView {
    self.insuranceInfoView = [[UIView alloc] init];
    self.insuranceInfoView .backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.insuranceInfoView ];
    [self.insuranceInfoView  makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.insuranceInfoTitleView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(115.0f);
    }];
    
    UIButton *optionOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [optionOne setImage:[UIImage imageNamed:@"botton_149peifubaby_wei"] forState:UIControlStateNormal];
    [optionOne addTarget:self action:@selector(optionOneTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.insuranceInfoView  addSubview:optionOne];
    [optionOne makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.insuranceInfoView .centerX).multipliedBy(1.0f/3.0f);
        make.centerY.equalTo(self.insuranceInfoView .centerY);
        make.width.mas_equalTo((CGRectGetWidth(self.view.frame)-40.0f)/3.0f);
    }];
    
    UIButton *optionTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [optionTwo addTarget:self action:@selector(optionTwoTapped) forControlEvents:UIControlEventTouchUpInside];
    [optionTwo setImage:[UIImage imageNamed:@"botton_149peifubaby_yi"] forState:UIControlStateNormal];
    [self.insuranceInfoView  addSubview:optionTwo];
    [optionTwo makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.insuranceInfoView .centerX);
        make.centerY.equalTo(self.insuranceInfoView .centerY);
        make.width.mas_equalTo((CGRectGetWidth(self.view.frame)-40.0f)/3.0f);
    }];
    
    UIButton *optionThree = [UIButton buttonWithType:UIButtonTypeCustom];
    [optionThree setImage:[UIImage imageNamed:@"botton_169peifubaby"] forState:UIControlStateNormal];
    [optionThree addTarget:self action:@selector(optionThreeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.insuranceInfoView  addSubview:optionThree];
    [optionThree makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.insuranceInfoView .centerX).multipliedBy(5.0f/3.0f);
        make.centerY.equalTo(self.insuranceInfoView .centerY);
        make.width.mas_equalTo((CGRectGetWidth(self.view.frame)-40.0f)/3.0f);
    }];
    
}

- (void)buildInsuranceDetailView {
    self.insuranceDetailView = [[UIView alloc] init];
    self.insuranceDetailView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.insuranceDetailView];
    [self.insuranceDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.insuranceDetailTitleView.bottom);
        make.width.equalTo(self.scrollView.width);
        make.left.equalTo(self.scrollView.left);
        make.height.mas_equalTo(230.0f);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_lipeifanwei"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.insuranceDetailView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.insuranceDetailView);
        make.width.lessThanOrEqualTo(self.insuranceDetailView.width).offset(-30.0f);
    }];
}


- (void)buildInsuranceClaimView {
    self.insuranceClaimView = [[UIView alloc] init];
    self.insuranceClaimView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.insuranceClaimView];
    [self.insuranceClaimView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.insuranceClaimTitleView.bottom);
        make.width.equalTo(self.scrollView.width);
        make.left.equalTo(self.scrollView.left);
        make.height.mas_equalTo(310.0f);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_lipeierweima"]];
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.insuranceClaimView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.insuranceClaimView.top).offset(10.0f);
        make.width.lessThanOrEqualTo(self.insuranceDetailView.width).offset(-30.0f);
        make.centerX.equalTo(self.insuranceClaimView.centerX);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadQRCode)];
    [imgView addGestureRecognizer:tapRec];
    
    UILabel *stepLabel = [[UILabel alloc] init];
    stepLabel.textColor = [UIColor HHTextDarkGray];
    stepLabel.font = [UIFont systemFontOfSize:13.0f];
    stepLabel.text = kStepString;
    stepLabel.numberOfLines = 0;
    [self.insuranceClaimView addSubview:stepLabel];
    [stepLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.bottom).offset(10.0f);
        make.left.equalTo(self.insuranceClaimView.left).offset(15.0f);
        make.width.equalTo(self.insuranceClaimView.width).offset(-30.0f);
    }];
    
    TTTAttributedLabel *supportLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    supportLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    supportLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    supportLabel.numberOfLines = 0;
    supportLabel.delegate = self;
    supportLabel.textAlignment = NSTextAlignmentCenter;
    supportLabel.attributedText = [self buildAttributeString];
    [supportLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[kSupportString rangeOfString:@"400-001-6006"]];
    [supportLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[kSupportString rangeOfString:@"在线客服"]];
    [self.insuranceClaimView addSubview:supportLabel];
    [supportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(stepLabel.bottom).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
    }];
}


- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSMutableAttributedString *)buildAttributeString {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0f;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:kSupportString attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:style}];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange]} range:[kSupportString rangeOfString:@"400-001-6006"]];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange]} range:[kSupportString rangeOfString:@"在线客服"]];
    
    return attrString;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
    } else {
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}

- (void)downloadQRCode {
    [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"保存中..."];
    UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"hhxc.jpeg"], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
    if (!error) {
        [[HHToastManager sharedManager] showSuccessToastWithText:@"图片保存成功"];
    } else {
        [[HHToastManager sharedManager] showErrorToastWithText:@"保存失败, 请重试"];
    }
    
}

- (void)optionOneTapped {
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [self showLoginAlert];
        return;
    }
    HHRootViewController *vc = [[HHRootViewController alloc] initWithDefaultIndex:TabBarItemCoach];
    [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
}

- (void)optionTwoTapped {
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [self showLoginAlert];
        return;
    }
    [self showInsurancePurchaseVC];
}

- (void)optionThreeTapped {
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [self showLoginAlert];
        return;
    }
    [self showInsurancePurchaseVC];
}

- (void)showInsurancePurchaseVC {
    HHPurchaseInsuranceViewController *vc = [[HHPurchaseInsuranceViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)showLoginAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册/登录后即可购买" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去注册/登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jumpToIntroVC];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)jumpToIntroVC {
    HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
    [self presentViewController:navVC animated:YES completion:nil];
}


@end
