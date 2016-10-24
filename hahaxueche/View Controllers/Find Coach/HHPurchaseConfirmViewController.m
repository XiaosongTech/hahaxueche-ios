//
//  HHPurchaseConfirmViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPurchaseConfirmViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCoachListView.h"
#import "HHConstantsStore.h"
#import "HHPaymentMethodView.h"
#import "NSNumber+HHNumber.h"
#import "HHPaymentService.h"
#import "HHStudentStore.h"
#import "HHEventTrackingManager.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentService.h"
#import "HHPopupUtility.h"
#import "HHReceiptViewController.h"
#import "HHPurchaseTagView.h"


@interface HHPurchaseConfirmViewController ()

@property (nonatomic, strong) HHCoachListView *coachView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *paymentViews;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) HHPurchaseTagView *licenseTypeView;
@property (nonatomic, strong) HHPurchaseTagView *classTypeView;
@property (nonatomic, strong) UIView *totalPriceContainerView;
@property (nonatomic, strong) UILabel *totalPriceLabel;

@property (nonatomic) StudentPaymentMethod selectedMethod;
@property (nonatomic) CoachProductType selectedProduct;

@property (nonatomic) LicenseType selectedLicense;
@property (nonatomic) ClassType selectedClass;

@property (nonatomic, strong) HHPaymentMethodView *aliPayView;
@property (nonatomic, strong) HHPaymentMethodView *bankCardView;
@property (nonatomic, strong) HHPaymentMethodView *fqlView;

@end

@implementation HHPurchaseConfirmViewController


- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.selectedMethod = StudentPaymentMethodAlipay;
        self.paymentViews = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.title = @"购买教练";
    self.selectedProduct = CoachProductTypeStandard;
    self.selectedClass = ClassTypeStandard;
    self.selectedLicense = LicenseTypeC1;
    [self initSubviews];
}

- (void)initSubviews {
    self.coachView = [[HHCoachListView alloc] initWithCoach:self.coach field:[[HHConstantsStore sharedInstance] getFieldWithId:self.coach.fieldId]];
    [self.view addSubview:self.coachView];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payButton setTitle:@"确认并付款" forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor HHDarkOrange];
    [self.payButton addTarget:self action:@selector(payCoach) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.payButton];
    
    [self makeConstraints];
    
    [self buildServiceTypeViews];
    [self buildPaymentViews];
}

- (void)makeConstraints {
    [self.coachView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(100.0f);
    }];

    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachView.bottom).offset(10.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom).offset(-50.0f);
    }];
    
    [self.payButton makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];

}

- (void)buildServiceTypeViews {
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    NSMutableArray *licenseTypes = [NSMutableArray arrayWithObject:@"C1手动挡"];
    if ([self.coach.c2Price floatValue] > 0 || [self.coach.c2VIPPrice floatValue] > 0) {
        [licenseTypes addObject:@"C2自动挡"];
    }
    self.licenseTypeView = [[HHPurchaseTagView alloc] initWithTags:licenseTypes title:@"驾照类型" defaultTag:licenseTypes[self.selectedLicense]];
    self.licenseTypeView.tagAction = ^(NSInteger selectedIndex){
        weakSelf.selectedLicense = selectedIndex;
        [weakSelf buildClassView];
    };
    [self.scrollView addSubview:self.licenseTypeView];
    [self.licenseTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(80.0f);
        
    }];
    
    [self buildClassView];
    
    self.totalPriceContainerView = [[UIView alloc] init];
    self.totalPriceContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.totalPriceContainerView];
    [self.totalPriceContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classTypeView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    self.totalPriceLabel = [[UILabel alloc] init];
    self.totalPriceLabel.font = [UIFont systemFontOfSize:20.0f];
    self.totalPriceLabel.textColor = [UIColor HHOrange];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总价: %@", [self.coach.price generateMoneyString]];
    [self.totalPriceContainerView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalPriceContainerView.centerY);
        make.right.equalTo(self.totalPriceContainerView.right).offset(-20.0f);
    }];
}

- (void)buildPaymentViews {
    __weak HHPurchaseConfirmViewController *weakSelf = self;

    self.aliPayView = [[HHPaymentMethodView alloc] initWithTitle:@"支付宝" subTitle:@"推荐拥有支付宝账号的用户使用" icon:[UIImage imageNamed:@"ic_alipay_icon"] selected:YES];
    self.aliPayView.viewSelectedBlock = ^() {
        weakSelf.selectedMethod = StudentPaymentMethodAlipay;
    };
    [self.scrollView addSubview:self.aliPayView];
    [self.aliPayView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPriceContainerView.bottom).offset(10.0f);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(60.0f);
    }];
    [self.paymentViews addObject:self.aliPayView];
    
    self.bankCardView = [[HHPaymentMethodView alloc] initWithTitle:@"银行卡" subTitle:@"安全极速支付, 无需开通网银" icon:[UIImage imageNamed:@"ic_cardpay_icon"] selected:NO];
    self.bankCardView.viewSelectedBlock = ^() {
        weakSelf.selectedMethod = StudentPaymentMethodBankCard;
    };
    [self.scrollView addSubview:self.bankCardView];
    [self.bankCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliPayView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(60.0f);
    }];
    [self.paymentViews addObject:self.bankCardView];
    
    self.fqlView = [[HHPaymentMethodView alloc] initWithTitle:@"分期乐" subTitle:@"推荐分期用户使用" icon:[UIImage imageNamed:@"fql"] selected:NO];
    self.fqlView.viewSelectedBlock = ^() {
        weakSelf.selectedMethod = StudentPaymentMethodFql;
    };
    [self.scrollView addSubview:self.fqlView];
    [self.fqlView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankCardView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(60.0f);
    }];
    [self.paymentViews addObject:self.fqlView];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.fqlView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-30.0f]];

    
}

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSelectedMethod:(StudentPaymentMethod)selectedMethod {
    _selectedMethod = selectedMethod;
    int i = 0;
    for (HHPaymentMethodView *view in self.paymentViews) {
        if (i == self.selectedMethod) {
            view.selected = YES;
        } else {
            view.selected = NO;
        }
        i++;
    }
}

- (void)payCoach {
    if ([[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray count]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"您已经有购买的教练，无需再次购买教练！"];
        return;
    }
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHPaymentService sharedInstance] payWithCoachId:self.coach.coachId studentId:[HHStudentStore sharedInstance].currentStudent.studentId paymentMethod:self.selectedMethod productType:self.selectedProduct inController:self completion:^(BOOL succeed) {
        if (succeed) {
            [self fetchStudentAfterPurchase];
        } else {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [[HHToastManager sharedManager] showErrorToastWithText:@"抱歉，支付失败或者您取消了支付。请重试！"];
        }
    }];
}

- (void)fetchStudentAfterPurchase {
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    if (![[HHLoadingViewUtility sharedInstance] isVisible]) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    [[HHStudentService sharedInstance] fetchStudentWithId:[HHStudentStore sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
        if ([student.purchasedServiceArray count]) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [HHStudentStore sharedInstance].currentStudent = student;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"coachPurchased" object:nil];
            
            HHReceiptViewController *vc = [[HHReceiptViewController alloc] initWithCoach:weakSelf.coach];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navVC animated:YES completion:^{
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }];
            
        } else {
            [self fetchStudentAfterPurchase];
        }
        
    }];
}

- (UIView *)buildTitleViewWithString:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor HHLightTextGray];
    label.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(20.0f);
    }];
    return view;
}

- (void)buildClassView {
    if(self.classTypeView) {
        self.classTypeView = nil;
        [self.classTypeView removeFromSuperview];
    }
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    NSMutableArray *classTags = [NSMutableArray array];
    if (self.selectedLicense == LicenseTypeC1) {
        if ([self.coach.price floatValue] > 0) {
            [classTags addObject:@"超值"];
        }
        
        if ([self.coach.VIPPrice floatValue] > 0) {
            [classTags addObject:@"VIP"];
        }
    } else {
        if ([self.coach.c2Price floatValue] > 0) {
            [classTags addObject:@"超值"];
        }
        
        if ([self.coach.c2VIPPrice floatValue] > 0) {
            [classTags addObject:@"VIP"];
        }
    }
    
    self.classTypeView = [[HHPurchaseTagView alloc] initWithTags:classTags title:@"班别" defaultTag:classTags[self.selectedClass]];
    self.classTypeView.tagAction = ^(NSInteger selectedIndex){
        weakSelf.selectedClass = selectedIndex;
    };
    [self.scrollView addSubview:self.classTypeView];
    [self.classTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.licenseTypeView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(80.0f);
    }];
}

- (void)setSelectedLicense:(LicenseType)selectedLicense {
    _selectedLicense = selectedLicense;
    self.selectedClass = 0;
    [self selectionChanged];
}

- (void)setSelectedClass:(ClassType)selectedClass {
    _selectedClass = selectedClass;
    [self selectionChanged];
}

- (void)selectionChanged {
    if (self.selectedLicense == LicenseTypeC1) {
        if (self.selectedClass == ClassTypeStandard) {
            self.totalPriceLabel.text = [NSString stringWithFormat:@"总价: %@", [self.coach.price generateMoneyString]];
            self.selectedProduct = CoachProductTypeStandard;
        } else {
            self.totalPriceLabel.text = [NSString stringWithFormat:@"总价: %@", [self.coach.VIPPrice generateMoneyString]];
            self.selectedProduct = CoachProductTypeVIP;
        }
    } else {
        if (self.selectedClass == ClassTypeStandard) {
            self.totalPriceLabel.text = [NSString stringWithFormat:@"总价: %@", [self.coach.c2Price generateMoneyString]];
            self.selectedProduct = CoachProductTypeC2Standard;
        } else {
            self.totalPriceLabel.text = [NSString stringWithFormat:@"总价: %@", [self.coach.c2VIPPrice generateMoneyString]];
            self.selectedProduct = CoachProductTypeC2VIP;
        }
    }
}


@end
