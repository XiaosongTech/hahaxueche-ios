//
//  HHNoCoachView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHNoCoachView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHNoCoachView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"您还没有选择教练哦~";
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(30.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.text = @"快去寻找教练, 开启快乐学车之旅吧!";
        self.subLabel.textColor = [UIColor HHOrange];
        self.subLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.subLabel];
        
        [self.subLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.bottom).offset(20.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        UIView *botLine = [[UIView alloc] init];
        botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:botLine];
        
        [botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).offset(-50.0f);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.okButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [self.okButton setTitleColor:[UIColor HHGreen] forState:UIControlStateNormal];
        [self addSubview:self.okButton];
        
        [self.okButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.top.equalTo(botLine.bottom);
        }];
        
        
    }
    return self;
}

@end
