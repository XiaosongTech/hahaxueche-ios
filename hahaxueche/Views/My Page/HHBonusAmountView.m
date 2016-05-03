//
//  HHBonusAmountView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBonusAmountView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"

@implementation HHBonusAmountView

- (instancetype)initWithNumber:(NSNumber *)number title:(NSString *)title boldNumber:(BOOL)boldNumber showArror:(BOOL)showArror {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor HHOrange];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        if (boldNumber) {
            self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        } else {
            self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        
        [self addSubview:self.titleLabel];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.centerX.equalTo(self.centerX);
        }];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = [UIColor whiteColor];
        
        if (showArror) {
            valueLabel.text = [NSString stringWithFormat:@"%@ >", [number generateMoneyString]];
        } else {
            valueLabel.text = [number generateMoneyString];
        }
        
        if (boldNumber) {
            valueLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        } else {
            valueLabel.font = [UIFont systemFontOfSize:20.0f];
        }
        
        [self addSubview:valueLabel];
        
        [valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.centerX.equalTo(self.centerX);
        }];
    }
    return self;
}

@end
