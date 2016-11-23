//
//  HHUploadIDViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 23/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHUploadIDViewController.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHUploadIdView.h"

static NSString *const kLabelText = @"请上传您的身份证信息，我们将会生成您的哈哈学车专属学员电子协议，该协议将在您的学车途中保障您的利益，同时也有助于教练尽快开展教学活动！若不上传您的真实信息，我们将无法保障您的合法权益！";

@interface HHUploadIDViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) HHUploadIdView *faceView;
@property (nonatomic, strong) HHUploadIdView *backView;

@end

@implementation HHUploadIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签订协议";
    self.view.backgroundColor = [UIColor colorWithRed:1.00 green:0.98 blue:0.95 alpha:1.00];
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView  = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    style.lineSpacing = 5.0f;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kLabelText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:style}];
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor HHOrange];
    self.topContainerView.layer.masksToBounds = YES;
    self.topContainerView.layer.cornerRadius = 5.0f;
    [self.scrollView addSubview:self.topContainerView];
    [self.topContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.scrollView.top).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(CGRectGetHeight(rect) + 40.0f);

    }];

    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.attributedText = string;
    self.topLabel.numberOfLines = 0;
    self.topLabel.backgroundColor = [UIColor HHOrange];
    [self.topContainerView addSubview:self.topLabel];
    [self.topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topContainerView);
        make.width.equalTo(self.topContainerView.width).offset(-10.0f);
    }];
    
    self.faceView = [[HHUploadIdView alloc] initWithText:@"点击上传\n身份证\n正面" image:[UIImage imageNamed:@"idcard_a"]];
    [self.scrollView addSubview:self.faceView];
    [self.faceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.topContainerView.bottom).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(150.0f);
    }];
    
    self.backView = [[HHUploadIdView alloc] initWithText:@"点击上传\n身份证\n反面" image:[UIImage imageNamed:@"idcard_b"]];
    [self.scrollView addSubview:self.backView];
    [self.backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.faceView.bottom).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(150.0f);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.backView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];
    
}


@end
