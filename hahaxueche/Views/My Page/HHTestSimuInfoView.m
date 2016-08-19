//
//  HHTestSimuInfoView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestSimuInfoView.h"
#import "Masonry.h"

@implementation HHTestSimuInfoView

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value showBotLine:(BOOL)showBotLine {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.textColor = [UIColor whiteColor];
        self.valueLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.valueLabel.text = value;
        [self addSubview:self.valueLabel];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.hidden = !showBotLine;
        self.botLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.botLine];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left);
        }];
        
        [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right.equalTo(self.right);
        }];
        
        
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}

@end
