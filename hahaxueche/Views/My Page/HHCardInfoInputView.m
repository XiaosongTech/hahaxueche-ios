//
//  HHCardInfoInputView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCardInfoInputView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCardInfoInputView

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.titleLabel.textColor = [UIColor darkTextColor];
        [self addSubview:self.titleLabel];
        
        
        self.textField = [[UITextField alloc] init];
        self.textField.placeholder = placeholder;
        self.textField.textColor = [UIColor HHTextDarkGray];
        self.textField.font = [UIFont systemFontOfSize:14.0f];
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.tintColor = [UIColor HHOrange];
        [self addSubview:self.textField];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(20.0f);
        }];
        
        [self.textField makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(70.0f);
            make.width.equalTo(self.width).offset(-70.0f);
            make.height.equalTo(self.height);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:line];
        
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    
    return self;
}

@end
