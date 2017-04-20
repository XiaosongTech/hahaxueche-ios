//
//  HHPrepayViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 13/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHPrepayViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHPurchaseTagView.h"
#import "NSNumber+HHNumber.h"
#import "HHPaymentMethodsView.h"
#import "HHPaymentService.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHGenericReceiptViewController.h"
#import "HHStudentService.h"
#import "HHStudentStore.h"
#import "HHConstantsStore.h"
#import "HHStudentStore.h"
#import "HHIntroViewController.h"
#import "HHEventTrackingManager.h"

@interface HHPrepayViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *warnLabel;
@property (nonatomic, strong) HHPurchaseTagView *prepayTagView;
@property (nonatomic, strong) UIView *totalPriceContainerView;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) HHPaymentMethodsView *paymentMethodsView;

@end

@implementation HHPrepayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"预付定金";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [self initSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:deposit_confirm_page_viewed attributes:nil];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-50.0f);
    }];
    
    self.prepayTagView = [[HHPurchaseTagView alloc] initWithTags:@[@"预付100得300"] title:@"定金类型" defaultTag:@"预付100得300"];
    [self.scrollView addSubview:self.prepayTagView];
    [self.prepayTagView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(80.0f);
    }];
    
    self.totalPriceContainerView = [[UIView alloc] init];
    self.totalPriceContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.totalPriceContainerView];
    [self.totalPriceContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.prepayTagView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    self.totalPriceLabel = [[UILabel alloc] init];
    self.totalPriceLabel.font = [UIFont systemFontOfSize:18.0f];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总价: %@", [@(10000) generateMoneyString]];
    self.totalPriceLabel.textColor = [UIColor HHOrange];
    [self.totalPriceContainerView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalPriceContainerView.centerY);
        make.right.equalTo(self.totalPriceContainerView.right).offset(-20.0f);
    }];
    
    self.paymentMethodsView = [[HHPaymentMethodsView alloc] init];
    [self.scrollView addSubview:self.paymentMethodsView];
    [self.paymentMethodsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPriceContainerView.bottom).offset(10.0f);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(60.0f * StudentPaymentMethodCount);
        make.left.equalTo(self.scrollView.left);
    }];
    
    self.warnLabel = [[UILabel alloc] init];
    self.warnLabel.numberOfLines = 0;
    self.warnLabel.text = @"预付定金说明:\n预付100元即可在哈哈学车报名立减300元\n红包只能用于哈哈学车App报名学车, 需一次性使用, 不能拆分, 不可退换, 不可折现, 不能转赠\n该红包长期有效, 无使用截止日期\n本活动优惠不与平台其他优惠叠加";
    self.warnLabel.textColor = [UIColor HHDarkOrange];
    self.warnLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.scrollView addSubview:self.warnLabel];
    [self.warnLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(15.0f);
        make.width.equalTo(self.view.width).offset(-30.0f);
        make.top.equalTo(self.paymentMethodsView.bottom).offset(30.0f);
    }];

    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.warnLabel
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor HHDarkOrange];
    [self.confirmButton addTarget:self action:@selector(prepay) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton setTitle:@"确认并购买" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    
}

- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prepay {
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [self showLoginSignupAlertView];
        return;
    }
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHPaymentService sharedInstance] prepayWithType:3 paymentMethod:self.paymentMethodsView.selectedMethod inController:self completion:^(BOOL succeed) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (succeed) {
            [self fetchStudentAfterPurchase];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:deposit_confirm_page_purchased attributes:nil];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"支付失败或您取消了支付, 请重试"];
            
        }

    }];
    
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:deposit_confirm_page_button_tapped attributes:nil];
}

- (void)fetchStudentAfterPurchase {
    if (![[HHLoadingViewUtility sharedInstance] isVisible]) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    [[HHStudentService sharedInstance] fetchStudentWithId:[HHStudentStore sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
        if ([student.prepayAmount floatValue] > 0) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [HHStudentStore sharedInstance].currentStudent = student;
            
            HHGenericReceiptViewController *vc = [[HHGenericReceiptViewController alloc] initWithType:ReceiptTypePrepay];
            [self.navigationController setViewControllers:@[vc]];
            
        } else {
            [self fetchStudentAfterPurchase];
        }
        
    }];
}

- (void)showLoginSignupAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先登陆或者注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
