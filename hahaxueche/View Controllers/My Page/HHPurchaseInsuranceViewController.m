//
//  HHPurchaseInsuranceViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHPurchaseInsuranceViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHPurchaseInsuranceViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *warnLabel;

@end

@implementation HHPurchaseInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买赔付宝";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-70.0f);
    }];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确认并购买" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    self.warnLabel = [[UILabel alloc] init];
    self.warnLabel.text = @"注: 请确认您还未参加科目一考试";
    self.warnLabel.textColor = [UIColor HHDarkOrange];
    self.warnLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:self.warnLabel];
    [self.warnLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(15.0f);
        make.width.equalTo(self.view.width).offset(-30.0f);
        make.height.mas_equalTo(20.0f);
        make.bottom.equalTo(self.confirmButton.top);
    }];
    
}

- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
