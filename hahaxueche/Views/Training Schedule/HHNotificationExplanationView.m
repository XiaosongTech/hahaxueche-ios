//
//  HHNotificationExplanationView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHNotificationExplanationView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHNotificationExplanationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [self createLabelWithTitle:@"教练课程" font:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHTextDarkGray]];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];


        self.subTitleLabel = [self createLabelWithTitle:@"您还没有选择教练" font:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHOrange]];
        
        self.expLabel = [self createLabelWithTitle:@"来看看大家都在哈哈学车上做什么吧!" font:[UIFont systemFontOfSize:15.0f] textColor:[UIColor HHLightestTextGray]];
        
        self.okButtonView = [[HHOkButtonView alloc] init];
        __weak HHNotificationExplanationView *weakSelf = self;
        self.okButtonView.okAction = ^() {
            if (weakSelf.okBlock) {
                weakSelf.okBlock();
            }
        };
        [self addSubview:self.okButtonView];
        
        [self makeConstraints];
        
    }
    return self;
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label sizeToFit];
    [self addSubview:label];
    return label;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(18.0f);
        make.left.equalTo(self.left).offset(20.0f);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(60.0f);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.bottom).offset(20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.expLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.bottom).offset(25.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
    }];

    
    [self.okButtonView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.f);
    }];
}

@end
