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
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.text = value;
        self.valueLabel.textColor = [UIColor whiteColor];
        self.valueLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.valueLabel];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.top).offset(10.0f);
        }];
        
        [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left);
            make.top.equalTo(self.titleLabel.bottom).offset(5.0f);
        }];
    }
    return self;
}

@end
