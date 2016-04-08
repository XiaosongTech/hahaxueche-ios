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
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"您还没有选择教练哦~";
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:titleLabel];
        
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(30.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.text = @"快去寻找教练, 开启快乐学车之旅吧!";
        subLabel.textColor = [UIColor HHOrange];
        subLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:subLabel];
        
        [subLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.bottom).offset(20.0f);
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
