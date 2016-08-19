//
//  HHOptionView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHOptionView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHOptionView

- (instancetype)initWithOptionTilte:(NSString *)title text:(NSString *)text {
    self = [super init];
    if (self) {
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleButton.layer.masksToBounds = YES;
        self.titleButton.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
        self.titleButton.layer.cornerRadius = 12.0f;
        self.titleButton.imageView.contentMode = UIViewContentModeCenter;
        self.titleButton.layer.borderColor = [UIColor HHLightestTextGray].CGColor;
        self.titleButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.titleButton.backgroundColor = [UIColor whiteColor];
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        [self.titleButton setTitleColor:[UIColor HHLightestTextGray] forState:UIControlStateNormal];
        [self addSubview:self.titleButton];
        
        [self.titleButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.centerY.equalTo(self.centerY);
            make.width.mas_equalTo(24.0f);
            make.height.mas_equalTo(24.0f);
        }];
        
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.text = text;
        self.textLabel.textColor = [UIColor HHLightTextGray];
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.textLabel];
        
        [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleButton.right).offset(8.0f);
            make.width.equalTo(self.width).offset(-10.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
    }
    return self;
}

@end
