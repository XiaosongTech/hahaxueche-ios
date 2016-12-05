//
//  HHCourseInsuranceCardViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 01/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCourseInsuranceCardViewController.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHStudentStore.h"

@interface HHCourseInsuranceCardViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabelOne;
@property (nonatomic, strong) UILabel *titleLabelTwo;
@property (nonatomic, strong) UILabel *textLabelOne;
@property (nonatomic, strong) UILabel *textLabelTwo;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSNumber *count;

@end

@implementation HHCourseInsuranceCardViewController


- (instancetype)initWithValidCount:(NSNumber *)count {
    self = [super init];
    if (self) {
        self.count = count;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保过卡详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    self.titleLabelOne = [self buildLabelWithTitle:@"如何获得" font:[UIFont systemFontOfSize:20.0f] color:[UIColor HHOrange]];
    [self.scrollView addSubview:self.titleLabelOne];
    [self.titleLabelOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top).offset(20.0f);
        make.left.equalTo(self.scrollView.left).offset(20.0f);
    }];
    
    self.textLabelOne = [self buildLabelWithTitle:@"在哈哈学车平台上注册登录即可获得保过卡。" font:[UIFont systemFontOfSize:15.0f] color:[UIColor HHLightTextGray]];
    [self.scrollView addSubview:self.textLabelOne];
    [self.textLabelOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabelOne.bottom).offset(5.0f);
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.width.lessThanOrEqualTo(self.scrollView.width).offset(-40.0f);
    }];
    
    
    self.titleLabelTwo = [self buildLabelWithTitle:@"使用规则" font:[UIFont systemFontOfSize:20.0f] color:[UIColor HHOrange]];
    [self.scrollView addSubview:self.titleLabelTwo];
    [self.titleLabelTwo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabelOne.bottom).offset(20.0f);
        make.left.equalTo(self.scrollView.left).offset(20.0f);
    }];
    
    self.textLabelTwo = [self buildLabelWithTitle:@"学员在哈哈学车平台报名后，通过哈哈学车APP模拟科目一考试5次成绩均在90分以上，并分享至第三方平台即可发起理赔，当科目一考试未通过可凭借成绩单获得全额赔付¥120元。" font:[UIFont systemFontOfSize:15.0f] color:[UIColor HHLightTextGray]];
    [self.scrollView addSubview:self.textLabelTwo];
    [self.textLabelTwo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabelTwo.bottom).offset(5.0f);
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.width.lessThanOrEqualTo(self.scrollView.width).offset(-40.0f);
    }];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor HHOrange];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5.0f;
    [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    NSString *buttonTitle;
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        if([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
            if(self.count.integerValue > 0) {
                buttonTitle = @"晒成绩!";
            } else {
                buttonTitle = @"去模拟!";
            }
        } else {
            buttonTitle = @"去报名!";
        }
    } else {
        buttonTitle = @"去注册!";
    }
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.button sizeToFit];
    [self.scrollView addSubview:self.button];
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabelTwo.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(CGRectGetWidth(self.button.bounds) + 30.0f);
        make.height.mas_equalTo(CGRectGetHeight(self.button.bounds) + 8.0f);
    }];
}


- (UILabel *)buildLabelWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonTapped {
    
}


@end
