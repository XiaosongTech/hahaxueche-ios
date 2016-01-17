//
//  HHAskLocationPermissionViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAskLocationPermissionViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"

@implementation HHAskLocationPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.title = @"定位服务";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.view addSubview:self.scrollView];
    
    self.titleLabel = [self createLabelWithTitle:@"开启定位" font:[UIFont systemFontOfSize:20.0f] textColor:[UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]];
    [self.scrollView addSubview:self.titleLabel];
    
    self.subtitleLabel = [self createLabelWithTitle:@"搜索自己最近的训练场" font:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightTextGray]];
    [self.scrollView addSubview:self.subtitleLabel];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_local"]];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.scrollView addSubview:self.imageView];
    
    self.explanationLabel = [self createLabelWithTitle:@"为了让哈哈学车更好的帮助您提供距离您最近的训练场信息，现在需要您开启位置服务" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor HHLightTextGray]];
    [self.scrollView addSubview:self.explanationLabel];
    
    self.button = [[HHButton alloc] init];
    [self.button setTitle:@"好的，去开启" forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.layer.cornerRadius = 5.0f;
    self.button.layer.masksToBounds = YES;
    self.button.backgroundColor = [UIColor HHOrange];
    [self.button addTarget:self action:@selector(grantPermission) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.button];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.subtitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.bottom).offset(25.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.explanationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.bottom).offset(25.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(280.0f);
    }];
    
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explanationLabel.bottom).offset(25.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(280.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.button.bottom).offset(40.0f);
    }];
    
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}

#pragma mark - Button Actions
- (void)grantPermission {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
