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
#import "HHVoucher.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHSelectVoucherViewController.h"
#import "HHSpecialVouchersView.h"
#import "HHInsuranceSelectionView.h"


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
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
@property (nonatomic, strong) UILabel *priceDetailLabel;
@property (nonatomic, strong) UIView *voucherView;
@property (nonatomic, strong) UILabel *voucherTitleLabel;
@property (nonatomic, strong) UILabel *voucherAmountLabel;
@property (nonatomic, strong) HHSpecialVouchersView *specialVoucherView;
@property (nonatomic, strong) UILabel *insurancePriceLabel;

@property (nonatomic) StudentPaymentMethod selectedMethod;
@property (nonatomic) CoachProductType selectedProduct;

@property (nonatomic) LicenseType selectedLicense;
@property (nonatomic) ClassType selectedClass;

@property (nonatomic, strong) HHPaymentMethodView *aliPayView;
@property (nonatomic, strong) HHPaymentMethodView *bankCardView;
@property (nonatomic, strong) HHPaymentMethodView *wechatPayView;
@property (nonatomic, strong) HHPaymentMethodView *fqlView;
@property (nonatomic, strong) NSArray *validVouchers;
@property (nonatomic, strong) NSArray *specialVouchers;
@property (nonatomic, strong) HHVoucher *selectedVoucher;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic) BOOL selectedInsurance;

@end

@implementation HHPurchaseConfirmViewController


- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.paymentViews = [NSMutableArray array];
        if ([self.validVouchers count] > 0) {
            self.selectedVoucher = [self.validVouchers firstObject];
        }
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
    self.selectedMethod = StudentPaymentMethodAlipay;
    self.selectedInsurance = YES;
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] getVouchersWithType:@(1) coachId:self.coach.coachId completion:^(NSArray *vouchers) {
        self.specialVouchers = vouchers;
        [[HHStudentService sharedInstance] getVouchersWithType:@(0) coachId:self.coach.coachId completion:^(NSArray *vouchers) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            self.validVouchers = vouchers;
            if (self.validVouchers.count > 0) {
                self.selectedVoucher = [self.validVouchers firstObject];
            }
            [self initSubviews];
        }];
        
    }];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:purchase_confirm_page_viewed attributes:@{@"coach_id":self.coach.coachId}];
}

- (void)initSubviews {
    self.coachView = [[HHCoachListView alloc] initWithCoach:self.coach field:[[HHConstantsStore sharedInstance] getFieldWithId:self.coach.fieldId]];
    [self.view addSubview:self.coachView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
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
    [self updatePriceLabelsWithSelectedPrice:self.coach.price];
    
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
    UIView *preView = self.classTypeView;
    
    UIView *insuranceView = [self buildInsuranceView];
    [self.scrollView addSubview:insuranceView];
    [insuranceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    preView = insuranceView;
    
    if (self.specialVouchers.count > 0) {
        self.specialVoucherView = [[HHSpecialVouchersView alloc] initWithVouchers:self.specialVouchers];
        [self.scrollView addSubview:self.specialVoucherView];
        [self.specialVoucherView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(preView.bottom);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(30.0f * self.specialVouchers.count);
        }];
        preView = self.specialVoucherView;
    }
    
    if (self.validVouchers.count > 0) {
        self.voucherView = [self buildVoucherView];
        [self.scrollView addSubview:self.voucherView];
        [self.voucherView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(preView.bottom);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(50.0f);
        }];
        preView = self.voucherView;
    }
    
    self.totalPriceContainerView = [[UIView alloc] init];
    self.totalPriceContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.totalPriceContainerView];
    [self.totalPriceContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];

    
    self.totalPriceLabel = [[UILabel alloc] init];
    self.totalPriceLabel.font = [UIFont systemFontOfSize:20.0f];
    self.totalPriceLabel.textColor = [UIColor HHOrange];
    [self.totalPriceContainerView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalPriceContainerView.centerY);
        make.right.equalTo(self.totalPriceContainerView.right).offset(-20.0f);
    }];
    
    self.totalPriceTitleLabel = [[UILabel alloc] init];
    self.totalPriceTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.totalPriceTitleLabel.textColor = [UIColor HHLightTextGray];
    
    if (self.validVouchers.count > 0) {
        self.totalPriceTitleLabel.text = @"实付";
    } else {
        self.totalPriceTitleLabel.text = @"总价";
    }
    
    [self.totalPriceContainerView addSubview:self.totalPriceTitleLabel];
    [self.totalPriceTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalPriceContainerView.centerY);
        make.right.equalTo(self.totalPriceLabel.left).offset(-5.0f);
    }];
    
    if (self.validVouchers.count > 0 || self.specialVouchers.count > 0) {
        self.priceDetailLabel = [[UILabel alloc] init];
        self.priceDetailLabel.font = [UIFont systemFontOfSize:13.0f];
        self.priceDetailLabel.textColor = [UIColor HHLightTextGray];
        self.priceDetailLabel.text = [self getPriceDetailString];
        [self.totalPriceContainerView addSubview:self.priceDetailLabel];
        [self.priceDetailLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.totalPriceContainerView.centerY);
            make.left.equalTo(self.totalPriceContainerView.left).offset(20.0f);
        }];
    }
    
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
    
    self.wechatPayView = [[HHPaymentMethodView alloc] initWithTitle:@"微信支付" subTitle:@"推荐拥有微信账号的用户使用" icon:[UIImage imageNamed:@"ic_wechatpay_icon"] selected:NO];
    self.wechatPayView.viewSelectedBlock = ^() {
        weakSelf.selectedMethod = StudentPaymentMethodWechatPay;
    };
    [self.scrollView addSubview:self.wechatPayView];
    [self.wechatPayView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliPayView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(60.0f);
    }];
    [self.paymentViews addObject:self.wechatPayView];
    
    self.bankCardView = [[HHPaymentMethodView alloc] initWithTitle:@"银行卡" subTitle:@"一网通支付，支持所有主流借记卡/信用卡" icon:[UIImage imageNamed:@"cmcc_icon"] selected:NO];
    self.bankCardView.viewSelectedBlock = ^() {
        weakSelf.selectedMethod = StudentPaymentMethodBankCard;
    };
    [self.scrollView addSubview:self.bankCardView];
    [self.bankCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatPayView.bottom);
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
    for (HHPaymentMethodView *view in self.paymentViews) {
        view.selected = NO;
    }
    switch (selectedMethod) {
        case StudentPaymentMethodBankCard: {
            self.bankCardView.selected = YES;
        } break;
            
        case StudentPaymentMethodAlipay: {
            self.aliPayView.selected = YES;
        } break;
            
        case StudentPaymentMethodFql: {
            self.fqlView.selected = YES;
        } break;
            
        case StudentPaymentMethodWechatPay: {
            self.wechatPayView.selected = YES;
        } break;
        default:
            break;
    }
}

- (void)payCoach {
    if ([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"您已经有购买的教练，无需再次购买教练！"];
        return;
    }
    
    [self makeChargeCall];
    
}

- (void)makeChargeCall {
    NSString *voucherId = nil;
    if (self.selectedVoucher) {
        voucherId = self.selectedVoucher.voucherId;
    }
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHPaymentService sharedInstance] payWithCoachId:self.coach.coachId studentId:[HHStudentStore sharedInstance].currentStudent.studentId paymentMethod:self.selectedMethod productType:self.selectedProduct voucherId:voucherId inController:self completion:^(BOOL succeed) {
        if (succeed) {
            [self fetchStudentAfterPurchase];
        } else {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [[HHToastManager sharedManager] showErrorToastWithText:@"抱歉，支付失败或者您取消了支付。请重试！"];
        }
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:purchase_confirm_page_purchase_button_tapped attributes:@{@"coach_id":self.coach.coachId}];
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
            
            ReceiptViewType type;
            if (self.selectedInsurance) {
                type = ReceiptViewTypePeifubao;
            } else {
                type = ReceiptViewTypeContract;
            }
            HHReceiptViewController *vc = [[HHReceiptViewController alloc] initWithCoach:weakSelf.coach type:type];
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
    NSNumber *price;
    if (self.selectedLicense == LicenseTypeC1) {
        if (self.selectedClass == ClassTypeStandard) {
            price = self.coach.price;
            self.selectedProduct = CoachProductTypeStandard;
        } else {
            price = self.coach.VIPPrice;
            self.selectedProduct = CoachProductTypeVIP;
        }
    } else {
        if (self.selectedClass == ClassTypeStandard) {
            price = self.coach.c2Price;
            self.selectedProduct = CoachProductTypeC2Standard;
        } else {
            price = self.coach.c2VIPPrice;
            self.selectedProduct = CoachProductTypeC2VIP;
        }
    }
    [self updatePriceLabelsWithSelectedPrice:price];
}

- (void)updatePriceLabelsWithSelectedPrice:(NSNumber *)price {
    self.totalPriceLabel.text = [[self getFinalPriceWithPrice:price] generateMoneyString];
    self.priceDetailLabel.text = [self getPriceDetailString];
}

- (NSNumber *)getFinalPriceWithPrice:(NSNumber *)price {
    NSNumber *finalPrice = price;
    if (self.selectedInsurance) {
        finalPrice = @([finalPrice floatValue] + 12000);
    }
    if ([self.selectedVoucher.amount floatValue] > 0) {
        finalPrice = @([finalPrice floatValue] - [self.selectedVoucher.amount floatValue]);
    }
    
    if(self.specialVouchers.count > 0) {
        for (HHVoucher *voucher in self.specialVouchers) {
            finalPrice = @([finalPrice floatValue] - [voucher.amount floatValue]);
        }
    }
    return finalPrice;
}

- (UIView *)buildVoucherView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.voucherTitleLabel = [[UILabel alloc] init];
    
    self.voucherTitleLabel.numberOfLines = 1;
    self.voucherTitleLabel.textColor = [UIColor HHLightTextGray];
    self.voucherTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:self.voucherTitleLabel];
    [self.voucherTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(20.0f);
        make.right.equalTo(view.right).offset(-100.0f);
    }];
    
    self.voucherAmountLabel = [[UILabel alloc] init];
    self.voucherAmountLabel.numberOfLines = 1;
    self.voucherAmountLabel.textAlignment = NSTextAlignmentRight;
    self.voucherAmountLabel.textColor = [UIColor HHConfirmRed];
    self.voucherAmountLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:self.voucherAmountLabel];
    [self.voucherAmountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right).offset(-20.0f);
        make.left.equalTo(view.right).offset(-100.0f);
    }];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:botLine];
    [botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left);
        make.width.equalTo(view.width);
        make.bottom.equalTo(view.bottom);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [view addSubview:arrowView];
    [arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(self.voucherAmountLabel.right).offset(5.0f);
    }];
    
    self.voucherTitleLabel.text = self.selectedVoucher.title;
    self.voucherAmountLabel.text = [NSString stringWithFormat:@"-%@", [self.selectedVoucher.amount generateMoneyString]];
    
    if ([self.validVouchers count] == 1) {
        arrowView.hidden = YES;
        
    } else {
        arrowView.hidden = NO;
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showValidVouchers)];
        [view addGestureRecognizer:tapRec];
    }
    
    
    return view;
}

- (void)showValidVouchers {
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    HHSelectVoucherViewController *vc = [[HHSelectVoucherViewController alloc] initWithVouchers:self.validVouchers selectedIndex:[self.validVouchers indexOfObject:self.selectedVoucher]];
    vc.selectedBlock = ^(NSInteger selectedIndex) {
        weakSelf.selectedVoucher = weakSelf.validVouchers[selectedIndex];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setSelectedVoucher:(HHVoucher *)selectedVoucher {
    _selectedVoucher = selectedVoucher;
    self.voucherTitleLabel.text = self.selectedVoucher.title;
    self.voucherAmountLabel.text = [NSString stringWithFormat:@"-%@", [self.selectedVoucher.amount generateMoneyString]];
    [self updatePriceLabelsWithSelectedPrice:[self getSelectedOriginalPrice]];
}

- (NSString *)getPriceDetailString {
    NSNumber *reducedAmount = self.selectedVoucher.amount;
    if (self.specialVouchers.count > 0) {
        for (HHVoucher *voucher in self.specialVouchers) {
            reducedAmount = @([reducedAmount floatValue] + [voucher.amount floatValue]);
        }
    }
    return [NSString stringWithFormat:@"总价%@  立减%@", [[self getPriceWithoudDiscount] generateMoneyString], [reducedAmount generateMoneyString]];
}

- (NSNumber *)getPriceWithoudDiscount {
    NSNumber *price = [self getSelectedOriginalPrice];
    if (self.selectedInsurance) {
        price = @([price floatValue] + 12000);
    }
    return price;
}

- (NSNumber *)getSelectedOriginalPrice {
    NSNumber *price = self.coach.price;
    switch (self.selectedProduct) {
        case CoachProductTypeStandard: {
            price = self.coach.price;
        } break;
            
        case CoachProductTypeVIP: {
            price = self.coach.VIPPrice;
        } break;
            
        case CoachProductTypeC2Standard: {
            price = self.coach.c2Price;
        } break;
            
        case CoachProductTypeC2VIP: {
            price = self.coach.c2VIPPrice;
        } break;
            
        default: {
            price = self.coach.price;
        } break;
    }
    return price;
}

- (UIView *)buildInsuranceView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"赔付宝";
    label.textColor = [UIColor HHLightTextGray];
    label.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(20.0f);
    }];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:botLine];
    [botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left);
        make.width.equalTo(view.width);
        make.bottom.equalTo(view.bottom);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    self.insurancePriceLabel = [[UILabel alloc] init];
    self.insurancePriceLabel.textAlignment = NSTextAlignmentRight;
    self.insurancePriceLabel.text = [@(12000) generateMoneyString];
    self.insurancePriceLabel.textColor = [UIColor HHOrange];
    self.insurancePriceLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:self.insurancePriceLabel];
    [self.insurancePriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right).offset(-20.0f);
        make.left.equalTo(view.right).offset(-100.0f);
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [view addSubview:arrowView];
    [arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(self.insurancePriceLabel.right).offset(5.0f);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInsuranceDetailView)];
    [view addGestureRecognizer:tapRec];


    return view;
}

- (void)showInsuranceDetailView {
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    HHInsuranceSelectionView *view = [[HHInsuranceSelectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*0.5f) selected:self.selectedInsurance];
    view.buttonAction = ^(BOOL confirmed, BOOL checked) {
        if (confirmed) {
            weakSelf.selectedInsurance = checked;
        }
        [weakSelf.popup dismiss:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    self.popup.shouldDismissOnBackgroundTouch = YES;
    self.popup.shouldDismissOnContentTouch = NO;
    self.popup.showType = KLCPopupShowTypeSlideInFromBottom;
    self.popup.dismissType = KLCPopupDismissTypeSlideOutToBottom;
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (void)setSelectedInsurance:(BOOL)selectedInsurance {
    _selectedInsurance = selectedInsurance;
    if (selectedInsurance) {
        self.insurancePriceLabel.text = [@(12000) generateMoneyString];
        self.insurancePriceLabel.textColor = [UIColor HHOrange];
    } else {
        self.insurancePriceLabel.text = @"未选择";
        self.insurancePriceLabel.textColor = [UIColor HHTextDarkGray];
    }
    [self updatePriceLabelsWithSelectedPrice:[self getSelectedOriginalPrice]];
}


@end
