//
//  HHMyPageUserInfoView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageUserInfoView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHMyPageUserInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:14.0f] textColor:[UIColor HHOrange]];
        [self addSubview:self.titleLabel];
        
        self.valueLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightTextGray]];
        [self addSubview:self.valueLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
        self.arrowImageView.hidden = YES;
        [self addSubview:self.arrowImageView];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(15.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(10.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-15.0f);
    }];
}

- (UILabel *)buildLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    return label;
}

- (void)setupViewWithTitle:(NSString *)title value:(NSString *)value showArrow:(BOOL)showArror {
    self.titleLabel.text = title;
    self.valueLabel.text = value;
    self.arrowImageView.hidden = !showArror;
}

@end
