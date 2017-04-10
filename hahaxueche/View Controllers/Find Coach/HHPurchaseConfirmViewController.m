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
#import "HHStudentStore.h"
#import "HHEventTrackingManager.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentService.h"
#import "HHPopupUtility.h"
#import "HHReceiptViewController.h"
#import "HHVoucher.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHSelectVoucherViewController.h"
#import "HHSpecialVouchersView.h"
#import "HHInsuranceSelectionView.h"
#import "HHPaymentMethodsView.h"
#import "HHIntroViewController.h"


@interface HHPurchaseConfirmViewController ()

@property (nonatomic, strong) HHCoachListView *coachView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIView *totalPriceContainerView;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
@property (nonatomic, strong) UILabel *priceDetailLabel;
@property (nonatomic, strong) UIView *voucherView;
@property (nonatomic, strong) UILabel *voucherTitleLabel;
@property (nonatomic, strong) UILabel *voucherAmountLabel;
@property (nonatomic, strong) HHSpecialVouchersView *specialVoucherView;
@property (nonatomic, strong) UIView *classTypeView;

@property (nonatomic) CoachProductType selectedProduct;

@property (nonatomic, strong) HHPaymentMethodsView *paymentMethodsView;
@property (nonatomic, strong) NSArray *validVouchers;
@property (nonatomic, strong) NSArray *specialVouchers;
@property (nonatomic, strong) HHVoucher *selectedVoucher;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic) BOOL selectedInsurance;
@property (nonatomic, strong) NSNumber *classPrice;

@end

@implementation HHPurchaseConfirmViewController


- (instancetype)initWithCoach:(HHCoach *)coach selectedType:(CoachProductType)type {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.selectedProduct = type;
        self.selectedInsurance = NO;
        if (type == CoachProductTypeC1Wuyou || type == CoachProductTypeC2Wuyou) {
            self.selectedInsurance = YES;
        }
        if ([self.validVouchers count] > 0) {
            self.selectedVoucher = [self.validVouchers firstObject];
        }
        self.classPrice = [self.coach getPriceProductType:self.selectedProduct];
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.title = @"购买教练";
    
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
    
    [self buildClassTypeView];
    [self buildPriceDetailView];
    [self buildPaymentViews];
    [self updatePriceLabels];
    
}

- (void)makeConstraints {
    [self.coachView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(100.0f);
    }];

    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachView.bottom);
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

- (void)buildClassTypeView {
    self.classTypeView = [[UIView alloc] init];
    self.classTypeView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.classTypeView];
    [self.classTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor HHLightLineGray];
    [self.classTypeView addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classTypeView.top);
        make.left.equalTo(self.classTypeView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor HHLightLineGray];
    [self.classTypeView addSubview:botLine];
    [botLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classTypeView.bottom);
        make.left.equalTo(self.classTypeView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor HHLightTextGray];
    titleLabel.font =  [UIFont systemFontOfSize:13.0f];
    [self.classTypeView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classTypeView.centerY);
        make.left.equalTo(self.classTypeView.left).offset(20.0f);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor HHOrange];
    priceLabel.font =  [UIFont systemFontOfSize:13.0f];
    [self.classTypeView addSubview:priceLabel];
    [priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classTypeView.centerY);
        make.right.equalTo(self.classTypeView.right).offset(-20.0f);
    }];
    
    priceLabel.text = [[self.coach getPriceProductType:self.selectedProduct] generateMoneyString];
    switch (self.selectedProduct) {
        case CoachProductTypeStandard: {
            titleLabel.text = @"C1超值班";
            
        } break;
            
        case CoachProductTypeVIP: {
            titleLabel.text = @"C1VIP班";
            
        } break;
            
        case CoachProductTypeC2Standard: {
            titleLabel.text = @"C2超值班";
            
        } break;
            
        case CoachProductTypeC2VIP: {
            titleLabel.text = @"C2VIP班";
        } break;
            
        case CoachProductTypeC1Wuyou: {
            titleLabel.text = @"C1无忧班";
            
        } break;
            
        case CoachProductTypeC2Wuyou: {
           titleLabel.text = @"C2无忧班";
        } break;
            
        default:
            break;
    }
}

- (void)buildPriceDetailView {
    UIView *preView = self.classTypeView;
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
    
    self.paymentMethodsView = [[HHPaymentMethodsView alloc] init];
    [self.scrollView addSubview:self.paymentMethodsView];
    [self.paymentMethodsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPriceContainerView.bottom).offset(10.0f);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(StudentPaymentMethodCount * 60.0f);
        make.left.equalTo(self.scrollView.left);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.paymentMethodsView
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


- (void)payCoach {
    
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [self showLoginSignupAlertView];
        return;
    }
    if ([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"您已经有购买的教练，无需再次购买教练！"];
        return;
    }
    
    [self makeChargeCall];
    
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

- (void)makeChargeCall {
    NSString *voucherId = nil;
    if (self.selectedVoucher) {
        voucherId = self.selectedVoucher.voucherId;
    }
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHPaymentService sharedInstance] payWithCoachId:self.coach.coachId studentId:[HHStudentStore sharedInstance].currentStudent.studentId paymentMethod:self.paymentMethodsView.selectedMethod productType:self.selectedProduct voucherId:voucherId needInsurance:self.selectedInsurance inController:self completion:^(BOOL succeed) {
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
            [weakSelf showInsuranceWarningAlert];
            
        } else {
            [weakSelf fetchStudentAfterPurchase];
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
    [self updatePriceLabels];
}



- (void)updatePriceLabels {
    self.totalPriceLabel.text = [[self getFinalPrice] generateMoneyString];
    if (self.selectedVoucher || self.specialVouchers.count > 0) {
        self.priceDetailLabel.text = [self getPriceDetailString];

    }
}

- (NSString *)getPriceDetailString {
    NSNumber *reducedAmount = self.selectedVoucher.amount;
    if (self.specialVouchers.count > 0) {
        for (HHVoucher *voucher in self.specialVouchers) {
            reducedAmount = @([reducedAmount floatValue] + [voucher.amount floatValue]);
        }
    }
    return [NSString stringWithFormat:@"总价%@  立减%@", [self.classPrice generateMoneyString], [reducedAmount generateMoneyString]];
}


- (NSNumber *)getFinalPrice{
    NSNumber *finalPrice = self.classPrice;
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




- (void)showInsuranceWarningAlert {
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    HHPurchasedService *ps = [[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray firstObject];
    if ([self.coach.isCheyouWuyou boolValue] || [ps.productType integerValue] == CoachProductTypeC1Wuyou || [ps.productType integerValue] == CoachProductTypeC2Wuyou) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无忧班购买提示" message:@"为了让您学车无忧，完成后续理赔等各项事宜，请购买无忧班后必须在预约第一次科目一考试的前一个工作日24点前，完成身份信息上传，否则无法获得理赔。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            HHReceiptViewController *vc = [[HHReceiptViewController alloc] initWithCoach:weakSelf.coach type:ReceiptViewTypePeifubao];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [weakSelf presentViewController:navVC animated:YES completion:^{
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }];
            
        }];
        
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        HHReceiptViewController *vc = [[HHReceiptViewController alloc] initWithCoach:weakSelf.coach type:ReceiptViewTypeContract];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [weakSelf presentViewController:navVC animated:YES completion:^{
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }];

        
    }
}


@end
