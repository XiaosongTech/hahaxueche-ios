//
//  HHEditNameView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/31/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHEditNameView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHEditNameView

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.topView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"修改名称";
        self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        self.field = [[UITextField alloc] init];
        self.field.borderStyle = UITextBorderStyleNone;
        self.field.clearButtonMode = UITextFieldViewModeAlways;
        self.field.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.field.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.field.layer.masksToBounds = YES;
        self.field.layer.cornerRadius = 20.0f;
        self.field.text = name;
        self.field.textColor = [UIColor HHTextDarkGray];
        self.field.tintColor = [UIColor HHOrange];
        self.field.font = [UIFont systemFontOfSize:15.0f];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40.0f)];
        leftView.backgroundColor = [UIColor whiteColor];
        self.field.leftView = leftView;
        self.field.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.field];
        
        
        self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"取消" rightTitle:@"保存"];
        [self addSubview:self.buttonsView];
        
        
        [self.topView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(60.0f);
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topView.left).offset(15.0f);
            make.centerY.equalTo(self.topView.centerY);
        }];
        
        [self.field makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.topView.bottom).offset(20.0f);
            make.width.equalTo(self.width).offset(-40.0f);
            make.height.mas_equalTo(40.0f);
        }];
        
        [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.bottom);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(50.0f);
        }];
    }
    return self;
}

@end
