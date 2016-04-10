//
//  HHBookFailView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBookFailView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHBookFailView

- (instancetype)initWithFrame:(CGRect)frame type:(ErrorType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [self createLabelWithTitle:@"预约失败" font:[UIFont systemFontOfSize:22.0f] textColor:[UIColor HHTextDarkGray]];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.botLine];
        
        NSString *subTitle;
        NSString *expText;
        if (type == ErrorTypeNeedCoachReview) {
            subTitle = @"您还有待评级课程";
            expText = @"教练还没有对您的课程评级, 待教练评级后再预约新课程. 若长时间未评级,请及时联系教练为您评级.";
        } else {
            subTitle = @"您还有未完成课程";
            expText = @"您的课程列表还有未完成的课程, 请课程完成后再预约新的课程.";
        }
        self.subTitleLabel = [self createLabelWithTitle:subTitle font:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHOrange]];
        
        self.expLabel = [self createLabelWithTitle:expText font:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightestTextGray]];
        self.expLabel.textAlignment = NSTextAlignmentLeft;
        
        self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.okButton setTitle:@"知道了" forState:UIControlStateNormal];
        [self.okButton setTitleColor:[UIColor HHConfirmGreen] forState:UIControlStateNormal];
        self.okButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.okButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.okButton];
    
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(15.0f);
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
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-60.0f);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.okButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.botLine.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.f);
    }];
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

- (void)dismissView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
