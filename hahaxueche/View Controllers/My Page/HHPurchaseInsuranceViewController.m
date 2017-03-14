//
//  HHPurchaseInsuranceViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHPurchaseInsuranceViewController.h"
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

@interface HHPurchaseInsuranceViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *warnLabel;
@property (nonatomic, strong) HHPurchaseTagView *insuranceTagView;
@property (nonatomic, strong) UIView *totalPriceContainerView;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) HHPaymentMethodsView *paymentMethodsView;

@end

@implementation HHPurchaseInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买赔付宝";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-80.0f);
    }];
    
    self.insuranceTagView = [[HHPurchaseTagView alloc] initWithTags:@[@"赔付宝"] title:@"保险类型" defaultTag:@"赔付宝"];
    [self.scrollView addSubview:self.insuranceTagView];
    [self.insuranceTagView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(80.0f);
    }];
    
    self.totalPriceContainerView = [[UIView alloc] init];
    self.totalPriceContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.totalPriceContainerView];
    [self.totalPriceContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.insuranceTagView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    NSNumber *price;
    if ([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        price = [[HHConstantsStore sharedInstance] getInsuranceWithType:1];
    } else {
        price = [[HHConstantsStore sharedInstance] getInsuranceWithType:2];
    }
    self.totalPriceLabel = [[UILabel alloc] init];
    self.totalPriceLabel.font = [UIFont systemFontOfSize:18.0f];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总价: %@", [price generateMoneyString]];
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
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.paymentMethodsView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor HHDarkOrange];
    [self.confirmButton addTarget:self action:@selector(showInsuranceWarningAlert) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.warnLabel = [[UILabel alloc] init];
    self.warnLabel.text = @"注: 请确认您还未参加科目一考试";
    self.warnLabel.textColor = [UIColor HHDarkOrange];
    self.warnLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:self.warnLabel];
    [self.warnLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(15.0f);
        make.width.equalTo(self.view.width).offset(-30.0f);
        make.height.mas_equalTo(30.0f);
        make.bottom.equalTo(self.confirmButton.top);
    }];
    
    
}

- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)purchaseInsurance {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHPaymentService sharedInstance] purchaseInsuranceWithpaymentMethod:self.paymentMethodsView.selectedMethod inController:self completion:^(BOOL succeed) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (succeed) {
            [self fetchStudentAfterPurchase];
            
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"支付失败或您取消了支付, 请重试"];
            
        }
    }];
}

- (void)fetchStudentAfterPurchase {
    if (![[HHLoadingViewUtility sharedInstance] isVisible]) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    [[HHStudentService sharedInstance] fetchStudentWithId:[HHStudentStore sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
        if ([student.insuranceOrder isPurchased]) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [HHStudentStore sharedInstance].currentStudent = student;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"studentUpdated" object:nil];
            
            HHGenericReceiptViewController *vc = [[HHGenericReceiptViewController alloc] initWithType:ReceiptTypeInsurance];
            [self.navigationController setViewControllers:@[vc]];
            
        } else {
            [self fetchStudentAfterPurchase];
        }
        
    }];
}

- (void)showInsuranceWarningAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"赔付宝购买提示" message:@"请确认您还未参加考科目一考试，购买后，必须在预约第一次科目一考试的前一个工作日24点前，完成身份信息上传。否则无法获得理赔." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self purchaseInsurance];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
