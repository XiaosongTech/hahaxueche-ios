//
//  HHReceiptViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReceiptViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHReceiptItemView.h"
#import "HHStudentStore.h"
#import "HHPurchasedService.h"
#import "NSNumber+HHNumber.h"
#import "HHFormatUtility.h"
#import "HHReferFriendsViewController.h"

@interface HHReceiptViewController ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *supportLable;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HHReceiptItemView *coachView;
@property (nonatomic, strong) HHReceiptItemView *amountView;
@property (nonatomic, strong) HHReceiptItemView *dateView;
@property (nonatomic, strong) HHReceiptItemView *receiptNoView;
@property (nonatomic, strong) HHPurchasedService *ps;
@property (nonatomic, strong) HHCoach *coach;

@end

@implementation HHReceiptViewController

- (instancetype)initWithCoach:(id)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"付款明细";
    self.view.backgroundColor = [UIColor HHLightBackgroundYellow];
    self.ps = [[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray firstObject];
    self.navigationItem.leftBarButtonItem = nil;
    
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_pay_success_right"]];
    [self.scrollView addSubview:self.imgView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"付款成功";
    self.titleLabel.font = [UIFont systemFontOfSize:25.0f];
    self.titleLabel.textColor = [UIColor HHTextDarkGray];
    [self.scrollView addSubview:self.titleLabel];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setTitle:@"分享得现金!" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareButton setBackgroundColor:[UIColor HHOrange]];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = 25.0f;
    [self.shareButton addTarget:self action:@selector(shareReferral) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.shareButton];
    
    self.supportLable = [[UILabel alloc] init];
    self.supportLable.text = @"对订单有任何疑问可致电客服热线400-001-6006或在App首页点击在线客服";
    self.supportLable.textAlignment = NSTextAlignmentCenter;
    self.supportLable.textColor = [UIColor HHLightTextGray];
    self.supportLable.font = [UIFont systemFontOfSize:13.0f];
    self.supportLable.numberOfLines = 0;
    [self.scrollView addSubview:self.supportLable];
    
    self.coachView = [[HHReceiptItemView alloc] initWithTitle:@"付款教练" value:self.coach.name];
    [self.scrollView addSubview:self.coachView];
    
    self.amountView = [[HHReceiptItemView alloc] initWithTitle:@"付款金额" value:[self.ps.totalAmount generateMoneyString]];
    [self.scrollView addSubview:self.amountView];
    
    self.dateView = [[HHReceiptItemView alloc] initWithTitle:@"付款时间" value:[[HHFormatUtility chineseFullDateFormatter] stringFromDate:self.ps.paidAt]];
    [self.scrollView addSubview:self.dateView];
    
    self.receiptNoView = [[HHReceiptItemView alloc] initWithTitle:@"订单编号" value:self.ps.orderNo];
    [self.scrollView addSubview:self.receiptNoView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.bottom).offset(15.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.coachView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(200.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.amountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachView.bottom).offset(10.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(200.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.dateView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountView.bottom).offset(10.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(200.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.receiptNoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.bottom).offset(10.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(200.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiptNoView.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(280.0f);
        make.height.mas_equalTo(50.0f);

    }];
    
    [self.supportLable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(280.0f);
        
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.supportLable
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];
}

- (void)shareReferral {
    HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
    [self.navigationController setViewControllers:@[vc]];
}

@end
