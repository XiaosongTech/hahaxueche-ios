//
//  HHAddBankCardViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAddBankCardViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHCardInfoInputView.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHAddBankCardViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHCardInfoInputView *nameView;
@property (nonatomic, strong) HHCardInfoInputView *cardNoView;

@end

@implementation HHAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"确认" titleColor:[UIColor whiteColor] action:@selector(confirm) target:self isLeft:NO];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请绑定持卡人本人的银行卡";
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.titleLabel.textColor = [UIColor HHLightTextGray];
    [self.view addSubview:self.titleLabel];
    
    self.nameView = [[HHCardInfoInputView alloc] initWithTitle:@"持卡人" placeholder:@"持卡人姓名"];
    [self.view addSubview:self.nameView];
    
    self.cardNoView = [[HHCardInfoInputView alloc] initWithTitle:@"卡号" placeholder:@"银行卡号"];
    self.cardNoView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.cardNoView];
    
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(20.0f);
        make.left.equalTo(self.view.left).offset(20.0f);
    }];
    
    [self.nameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(42.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(55.0f);
    }];
    
    [self.cardNoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(55.0f);
    }];
    
    
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm {
    
}


@end
