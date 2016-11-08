//
//  HHHomePageItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageItemView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHHomePageItemView

- (instancetype)initWithColor:(UIColor *)color title:(NSString *)title {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.dot = [[UIView alloc] init];
        self.dot.backgroundColor = color;
        self.dot.layer.masksToBounds = YES;
        self.dot.layer.cornerRadius = 1.5f;
        [self addSubview:self.dot];
        [self.dot makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.centerY.equalTo(self.centerY);
            make.width.mas_equalTo(3.0f);
            make.height.mas_equalTo(3.0f);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1.00];
        self.label.font = [UIFont systemFontOfSize:14.0f];
        self.label.text = title;
        [self addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dot.right).offset(3.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
    }
    return self;
}

@end
