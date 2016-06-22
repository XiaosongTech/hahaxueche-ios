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
#import "HHCoachServiceTypeView.h"
#import "HHPopupUtility.h"
#import "HHPriceDetailView.h"


@interface HHPurchaseConfirmViewController ()

@property (nonatomic, strong) HHCoachListView *coachView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *paymentViews;
@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) UIView *serviceTypeTitleView;
@property (nonatomic, strong) UIView *paymenthodTitleView;

@property (nonatomic, strong) UIView *moreMethodsView;

@property (nonatomic, strong) HHCoachServiceTypeView *standardServiceView;
@property (nonatomic, strong) HHCoachServiceTypeView *VIPServiceView;

@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic) StudentPaymentMethod selectedMethod;

@property (nonatomic) CoachProductType selectedProduct;

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
    [self initSubviews];
}

- (void)initSubviews {
    self.coachView = [[HHCoachListView alloc] initWithCoach:self.coach field:[[HHConstantsStore sharedInstance] getFieldWithId:self.coach.fieldId]];
    [self.view addSubview:self.coachView];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payButton setTitle:[NSString stringWithFormat:@"确认支付%@", [self.coach.price generateMoneyString]] forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor HHOrange];
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.cornerRadius = 5.0f;
    [self.payButton addTarget:self action:@selector(payCoach) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.payButton];
    
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
        make.bottom.equalTo(self.view.bottom);
    }];

}

- (void)buildServiceTypeViews {
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    self.serviceTypeTitleView = [self buildTitleViewWithString:@"选择班级"];
    [self.scrollView addSubview:self.serviceTypeTitleView];

    [self.serviceTypeTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.top.equalTo(self.scrollView.top);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(40.0f);
    }];
    
    self.standardServiceView = [[HHCoachServiceTypeView alloc] initWithPrice:self.coach.price iconImage:[UIImage imageNamed:@"ic_chaozhi"] marketPrice:self.coach.marketPrice detailText:@"四人一车, 高性价比" selected:YES];
    self.standardServiceView.tag = CoachProductTypeStandard;
    self.standardServiceView.priceBlock = ^() {
        HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
        CGFloat height = 190.0f + (city.cityFixedFees.count + 1) * 50.0f;
        HHPriceDetailView *priceView = [[HHPriceDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-20.0f, height) title:@"价格明细" totalPrice:weakSelf.coach.price showOKButton:YES];
        priceView.cancelBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:priceView];
        [HHPopupUtility showPopup:weakSelf.popup];
    };
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.standardServiceView addGestureRecognizer:recognizer];
    [self.scrollView addSubview:self.standardServiceView];
    [self.standardServiceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serviceTypeTitleView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    if ([self.coach.VIPPrice floatValue] > 0) {
        self.VIPServiceView = [[HHCoachServiceTypeView alloc] initWithPrice:self.coach.VIPPrice iconImage:[UIImage imageNamed:@"ic_VIP_details"] marketPrice:self.coach.VIPMarketPrice detailText:@"一人一车, 极速拿证" selected:NO];
        self.VIPServiceView.tag = CoachProductTypeVIP;
        
        self.VIPServiceView.priceBlock = ^() {
            HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
            CGFloat height = 190.0f + (city.cityFixedFees.count + 1) * 50.0f;
            HHPriceDetailView *priceView = [[HHPriceDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-20.0f, height) title:@"价格明细" totalPrice:weakSelf.coach.VIPPrice showOKButton:YES];
            priceView.cancelBlock = ^() {
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:priceView];
            [HHPopupUtility showPopup:weakSelf.popup];
        };
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self.VIPServiceView addGestureRecognizer:recognizer];
        [self.scrollView addSubview:self.VIPServiceView];
        [self.VIPServiceView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.standardServiceView.bottom);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(70.0f);
        }];
    }
    
    
}

- (void)buildPaymentViews {
    self.paymenthodTitleView = [self buildTitleViewWithString:@"支付方式"];
    [self.scrollView addSubview:self.paymenthodTitleView];
    
    CGFloat offset = 10.0f + 70.0f;
    if ([self.coach.VIPPrice floatValue] > 0) {
        offset = offset + 70.0f;
    }
    [self.paymenthodTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.top.equalTo(self.serviceTypeTitleView.bottom).offset(offset);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(40.0f);
    }];
    
    HHPaymentMethodView *view = nil;
    for (int i = 0; i < 2; i++) {
        switch (i) {
            case StudentPaymentMethodAlipay: {
                view = [[HHPaymentMethodView alloc] initWithTitle:@"支付宝" subTitle:@"推荐拥有支付宝账号的用户使用" icon:[UIImage imageNamed:@"ic_alipay_icon"] selected:YES enabled:YES];
            } break;
                
            case StudentPaymentMethodFql: {
                view = [[HHPaymentMethodView alloc] initWithTitle:@"分期乐" subTitle:@"推荐分期用户使用" icon:[UIImage imageNamed:@"fql"] selected:NO enabled:YES];
            } break;
                
            default:
                break;
        }
        view.tag = i;
        [self.paymentViews addObject:view];
        [self.scrollView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymenthodTitleView.bottom).offset(i * 60.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(60.0f);
        }];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(methodSelected:)];
        [view addGestureRecognizer:tapRecognizer];
        
        if (i == 1) {
            
            self.moreMethodsView = [[UIView alloc] init];
            self.moreMethodsView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.moreMethodsView];
            [self.moreMethodsView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left);
                make.width.equalTo(self.scrollView.width);
                make.top.equalTo(view.bottom);
                make.height.mas_equalTo(40.0f);
            }];
            
            UIView *topLine = [[UIView alloc] init];
            topLine.backgroundColor = [UIColor HHLightLineGray];
            [self.moreMethodsView addSubview:topLine];
            [topLine makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moreMethodsView.top);
                make.left.equalTo(self.moreMethodsView.left);
                make.width.equalTo(self.moreMethodsView.width);
                make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            }];
            
            UILabel *moreMethodsLabel = [[UILabel alloc] init];
            moreMethodsLabel.text = @"更多支付方式";
            moreMethodsLabel.textColor = [UIColor HHLightTextGray];
            moreMethodsLabel.font = [UIFont systemFontOfSize:14.0f];
            [self.moreMethodsView addSubview:moreMethodsLabel];

            [moreMethodsLabel makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.moreMethodsView);
            }];
            
            UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_pull_down"]];
            [self.moreMethodsView addSubview:arrowView];
            
            [arrowView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(moreMethodsLabel.right).offset(10.0f);
                make.centerY.equalTo(moreMethodsLabel.centerY);
            }];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreMethodsViewTapped)];
            [self.moreMethodsView addGestureRecognizer:tapRecognizer];
            
            [self.payButton makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moreMethodsView.bottom).offset(40.0f);
                make.centerX.equalTo(self.scrollView.centerX);
                make.width.equalTo(self.view.width).offset(-30.0f);
                make.height.mas_equalTo(50.0f);
            }];
            
            [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.payButton.bottom).offset(60.0f);
            }];
        }
    }
}

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)methodSelected:(UITapGestureRecognizer *)recognizer {
    HHPaymentMethodView *view = (HHPaymentMethodView *)recognizer.view;
    if (view.enabled) {
        for (HHPaymentMethodView *view in self.paymentViews) {
            view.selected = NO;
        }
        view.selected = YES;
        self.selectedMethod = view.tag;
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
            [[HHToastManager sharedManager] showSuccessToastWithText:@"支付成功! 请到我的页面查看具体信息."];
            [HHStudentStore sharedInstance].currentStudent = student;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"coachPurchased" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
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

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    HHCoachServiceTypeView *view = (HHCoachServiceTypeView *)recognizer.view;
    NSString *buttonTitle;
    
    if (view.tag == CoachProductTypeStandard) {
        self.standardServiceView.selected = YES;
        self.VIPServiceView.selected = NO;
        buttonTitle = [NSString stringWithFormat:@"确认支付%@", [self.coach.price generateMoneyString]];
    } else {
        self.standardServiceView.selected = NO;
        self.VIPServiceView.selected = YES;
        buttonTitle = [NSString stringWithFormat:@"确认支付%@", [self.coach.VIPPrice generateMoneyString]];
    }
    
    [self.payButton setTitle:buttonTitle forState:UIControlStateNormal];
    self.selectedProduct = view.tag;
}


- (void)moreMethodsViewTapped {
    [self.moreMethodsView removeFromSuperview];
    
    HHPaymentMethodView *lastAddedView = [self.paymentViews lastObject];
    
    HHPaymentMethodView *weChatWalletView = [[HHPaymentMethodView alloc] initWithTitle:@"微信钱包" subTitle:@"暂未开通" icon:[UIImage imageNamed:@"ic_wechatpay_icon"] selected:NO enabled:NO];
    [self.scrollView addSubview:weChatWalletView];
    [self.paymentViews addObject:weChatWalletView];
    
    [weChatWalletView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAddedView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(60.0f);
    }];
    
    
    HHPaymentMethodView *bankView = [[HHPaymentMethodView alloc] initWithTitle:@"银行卡" subTitle:@"暂未开通" icon:[UIImage imageNamed:@"ic_cardpay_icon"] selected:NO enabled:NO];
    [self.scrollView addSubview:bankView];
    [self.paymentViews addObject:bankView];
    
    [bankView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weChatWalletView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.payButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.bottom).offset(40.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.view.width).offset(-30.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
}

@end
