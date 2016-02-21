//
//  HHMoneyAmountView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMoneyAmountView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHMoneyAmountView

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor HHOrange];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = value;
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:valueLabel];
        
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.top).offset(10.0f);
        }];
        
        [valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.left);
            make.top.equalTo(titleLabel.bottom).offset(5.0f);
        }];
    }
    return self;
}

@end
