//
//  HHAppInfoViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAppInfoViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHAppInfoViewController ()

@property(nonatomic, strong) UILabel *rightLabel;
@property(nonatomic, strong) UILabel *versionLabel;
@property(nonatomic, strong) UIImageView *logoView;


@end

@implementation HHAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"软件信息";
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [self initSubviews];
}

- (void)initSubviews {
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_aboutmsg_logo"]];
    [self.view addSubview:self.logoView];
    
    self.versionLabel = [[UILabel alloc] init];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本号: %@", version];
    self.versionLabel.font = [UIFont systemFontOfSize:15.0f];
    self.versionLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    [self.view addSubview:self.versionLabel];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.text = @"武汉小松科技有限公司 版权所有\nCopyright 2015-2016 All Rights Reserved";
    self.rightLabel.numberOfLines = 2;
    self.rightLabel.font = [UIFont systemFontOfSize:13.0f];
    self.rightLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    [self.view addSubview:self.rightLabel];
    
    [self.logoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(-50.0f);
    }];
    
    [self.versionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.logoView.bottom).offset(20.0f);

    }];
    
    [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(-20.0f);
    }];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
