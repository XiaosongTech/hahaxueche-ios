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
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"
#import "HHUploadIDViewController.h"

@interface HHReceiptViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *signContractButton;
@property (nonatomic, strong) TTTAttributedLabel *supportLable;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HHReceiptItemView *coachView;
@property (nonatomic, strong) HHReceiptItemView *amountView;
@property (nonatomic, strong) HHReceiptItemView *dateView;
@property (nonatomic, strong) HHReceiptItemView *receiptNoView;
@property (nonatomic, strong) HHPurchasedService *ps;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic) ReceiptViewType type;

@end

@implementation HHReceiptViewController

- (instancetype)initWithCoach:(id)coach type:(ReceiptViewType)type {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"付款成功";
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
    
    self.signContractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.type == ReceiptViewTypeContract) {
        [self.signContractButton setTitle:@"签署专属协议" forState:UIControlStateNormal];
    } else {
        [self.signContractButton setTitle:@"上传投保信息" forState:UIControlStateNormal];
    }
    
    [self.signContractButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signContractButton setBackgroundColor:[UIColor HHOrange]];
    self.signContractButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.signContractButton.layer.masksToBounds = YES;
    self.signContractButton.layer.cornerRadius = 25.0f;
    [self.signContractButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.signContractButton];
    
    self.supportLable = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.supportLable.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLable.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLable.delegate = self;
    self.supportLable.textAlignment = NSTextAlignmentCenter;
    self.supportLable.numberOfLines = 0;
    self.supportLable.attributedText = [self buildAttributeString];
    [self.scrollView addSubview:self.supportLable];
    
    self.coachView = [[HHReceiptItemView alloc] initWithTitle:@"购买教练" value:self.coach.name];
    [self.scrollView addSubview:self.coachView];
    
    self.amountView = [[HHReceiptItemView alloc] initWithTitle:@"付款金额" value:[self.ps.actualAmount generateMoneyString]];
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
    
    [self.signContractButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiptNoView.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(280.0f);
        make.height.mas_equalTo(50.0f);

    }];
    
    [self.supportLable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signContractButton.bottom).offset(20.0f);
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

- (void)buttonTapped {
    UploadViewType type;
    if (self.type == ReceiptViewTypeContract) {
        type = UploadViewTypeContract;
    } else {
        type = UploadViewTypePeifubao;
    }
    HHUploadIDViewController *vc = [[HHUploadIDViewController alloc] initWithType:type];
    [self.navigationController setViewControllers:@[vc] animated:YES];
}

- (NSMutableAttributedString *)buildAttributeString {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSString *baseString = @"对订单有任何疑问可致电客服热线400-001-6006 或 点击联系:在线客服";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paraStyle}];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange]} range:[baseString rangeOfString:@"400-001-6006"]];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[UIColor HHOrange]} range:[baseString rangeOfString:@"在线客服"]];
    
    [self.supportLable addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[baseString rangeOfString:@"400-001-6006"]];
    [self.supportLable addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[baseString rangeOfString:@"在线客服"]];

    
    return attrString;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
    } else {
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}

@end
