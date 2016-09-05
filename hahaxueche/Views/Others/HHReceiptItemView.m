//
//  HHReceiptItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReceiptItemView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHReceiptItemView

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHLightestTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.centerY.equalTo(self.centerY);
        }];
        
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.text = value;
        self.valueLabel.textColor = [UIColor HHTextDarkGray];
        self.valueLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.valueLabel];
        [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.right).offset(30.0f);
            make.centerY.equalTo(self.centerY);
        }];
    }
    return self;
}

@end

