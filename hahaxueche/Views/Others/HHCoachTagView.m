//
//  HHCoachTagView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachTagView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachTagView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor HHLightBackgroudGray];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0f;
        self.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        
        self.dot = [[UIView alloc] init];
        self.dot.layer.masksToBounds = YES;
        self.dot.layer.cornerRadius = 2.5f;
        [self addSubview:self.dot];
        
        [self.dot makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(5.0f);
            make.centerY.equalTo(self.centerY);
            make.width.mas_equalTo(5.0f);
            make.height.mas_equalTo(5.0f);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor HHLightTextGray];
        self.label.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dot.right).offset(4.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
    }
    return self;
}

- (void)setDotColor:(UIColor *)dotColor title:(NSString *)title {
    self.dot.backgroundColor = dotColor;
    self.label.text = title;
}

@end
