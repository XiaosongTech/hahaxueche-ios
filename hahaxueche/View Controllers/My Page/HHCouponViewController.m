//
//  HHCouponViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCouponViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHStudentStore.h"
#import "HHStudent.h"


@interface HHCouponViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HHStudent *student;
@property (nonatomic, strong) UIImageView *ticketView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *bonusLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *grayLine1;
@property (nonatomic, strong) UIView *grayLine2;
@property (nonatomic, strong) UIButton *ruleButton;

@end

@implementation HHCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼金券";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.student = [HHStudentStore sharedInstance].currentStudent;
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.ticketView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ticket"]];
    [self.scrollView addSubview:self.ticketView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.titleLabel.text = @"哈哈学车免费试学券";
    [self.ticketView addSubview:self.titleLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
    self.statusLabel.hidden = YES;
    [self.ticketView addSubview:self.statusLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.subTitleLabel.textColor = [UIColor HHOrange];
    [self.ticketView addSubview:self.subTitleLabel];
    
    
    self.bonusLabel = [[UILabel alloc] init];
    self.bonusLabel.font = [UIFont systemFontOfSize:12.0f];
    self.bonusLabel.numberOfLines = 0;
    self.bonusLabel.textColor = [UIColor HHLightTextGray];
    self.bonusLabel.text = @"使用后我们会致电联系接送事宜, 优质服务提前体验, 试学过程100%免费.";
    [self.ticketView addSubview:self.bonusLabel];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"立即\n使用" forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.button.titleLabel.numberOfLines = 0;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ticketView addSubview:self.button];
    
    self.grayLine1 = [[UIView alloc] init];
    self.grayLine1.backgroundColor = [UIColor HHLightLineGray];
    [self.scrollView addSubview:self.grayLine1];
    
    self.grayLine2 = [[UIView alloc] init];
    self.grayLine2.backgroundColor = [UIColor HHLightLineGray];
    [self.scrollView addSubview:self.grayLine2];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"礼金券使用规则" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic-explain"];
    textAttachment.bounds = CGRectMake(-2.0f, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    
    self.ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ruleButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self.scrollView addSubview:self.ruleButton];

    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.ticketView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top).offset(10.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-28.0f);
        
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ticketView.top).offset(15.0f);
        make.left.equalTo(self.ticketView.left).offset(17.0f);
        
    }];
    
    [self.bonusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(8.0f);
        make.left.equalTo(self.titleLabel.left);
        make.width.equalTo(self.ticketView.width).multipliedBy(2.0f/3.0f);
    }];
    
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ticketView.centerY);
        make.right.equalTo(self.ticketView.right).offset(-25.0f);
    }];
    
    [self.ruleButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ticketView.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.grayLine1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ruleButton.centerY);
        make.left.equalTo(self.ticketView.left);
        make.right.equalTo(self.ruleButton.left).offset(-5.0f);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.grayLine2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ruleButton.centerY);
        make.left.equalTo(self.ruleButton.right).offset(2.0f);
        make.right.equalTo(self.ticketView.right);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
    }];
}


- (void)buttonTapped {
    
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
