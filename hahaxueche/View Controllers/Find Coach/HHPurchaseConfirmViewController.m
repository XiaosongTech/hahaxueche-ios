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

typedef NS_ENUM(NSInteger, StudentPaymentMethod) {
    StudentPaymentMethodAlipay, // 支付宝
    StudentPaymentMethodFql, //分期乐
    StudentPaymentMethodWeChatPay, // 微信支付
    StudentPaymentMethodBankCard, // 银行卡
    StudentPaymentMethodCount
};


@interface HHPurchaseConfirmViewController ()

@property (nonatomic, strong) HHCoachListView *coachView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *paymentViews;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic) StudentPaymentMethod selectedMethod;

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

- (void)buildPaymentViews {
    HHPaymentMethodView *view = nil;
    for (int i = 0; i < StudentPaymentMethodCount; i++) {
        switch (i) {
            case StudentPaymentMethodAlipay: {
                view = [[HHPaymentMethodView alloc] initWithTitle:@"支付宝" subTitle:@"推荐拥有支付宝账号的用户使用" icon:[UIImage imageNamed:@"ic_alipay_icon"] selected:YES enabled:YES];
            } break;
                
            case StudentPaymentMethodFql: {
                view = [[HHPaymentMethodView alloc] initWithTitle:@"分期乐" subTitle:@"推荐分期用户使用" icon:[UIImage imageNamed:@"fql"] selected:NO enabled:YES];
            } break;
                
            case StudentPaymentMethodWeChatPay: {
                view = [[HHPaymentMethodView alloc] initWithTitle:@"微信钱包" subTitle:@"暂未开通" icon:[UIImage imageNamed:@"ic_wechatpay_icon"] selected:NO enabled:NO];
            } break;
                
            case StudentPaymentMethodBankCard: {
                view = [[HHPaymentMethodView alloc] initWithTitle:@"银行卡" subTitle:@"暂未开通" icon:[UIImage imageNamed:@"ic_cardpay_icon"] selected:NO enabled:NO];
                
            } break;
                
            default:
                break;
        }
        view.tag = i;
        [self.paymentViews addObject:view];
        [self.scrollView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.top).offset(i * 60.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.scrollView.width);
            make.height.mas_equalTo(60.0f);
        }];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(methodSelected:)];
        [view addGestureRecognizer:tapRecognizer];
        
        if (i == StudentPaymentMethodCount - 1) {
            [self.payButton makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view.bottom).offset(40.0f);
                make.centerX.equalTo(self.scrollView.centerX);
                make.width.equalTo(self.view.width).offset(-30.0f);
                make.height.mas_equalTo(50.0f);
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
    __weak HHPurchaseConfirmViewController *weakSelf = self;
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHPaymentService sharedInstance] payWithCoachId:self.coach.coachId studentId:[HHStudentStore sharedInstance].currentStudent.studentId inController:self completion:^(BOOL succeed) {
        if (succeed) {
            [self fetchStudentAfterPurchase];
            [[HHEventTrackingManager sharedManager] sendEventWithId:kDidPurchaseCoachServiceEventId attributes:@{@"student_id":[HHStudentStore sharedInstance].currentStudent.studentId, @"coach_id":weakSelf.coach.coachId}];
        } else {
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

@end
