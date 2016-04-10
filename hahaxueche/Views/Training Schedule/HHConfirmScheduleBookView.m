//
//  HHConfirmScheduleBookView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHConfirmScheduleBookView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHConfirmScheduleBookView

- (instancetype)initWithFrame:(CGRect)frame schedule:(HHCoachSchedule *)schedule isBooking:(BOOL)booking {
    self = [super initWithFrame:frame];
    if (self) {
        self.schedule = schedule;
        self.backgroundColor = [UIColor whiteColor];
        
        NSString *title;
        NSString *subTitle;
        NSString *leftButtonTitle;
        NSString *rightButtonTitle;
        
        if (booking) {
            title = @"预约课程";
            subTitle = @"您预约了课程";
            leftButtonTitle = @"取消";
            rightButtonTitle = @"确认";
            
        } else {
            title = @"取消课程";
            subTitle = @"您是否要取消课程?";
            leftButtonTitle = @"取消课程";
            rightButtonTitle = @"暂不取消";
        }
        
        self.titleLabel = [self createLabelWithTitle:title font:[UIFont systemFontOfSize:22.0f] textColor:[UIColor HHTextDarkGray]];
        
        self.subTitleLabel = [self createLabelWithTitle:subTitle font:[UIFont systemFontOfSize:18.0f] textColor:[UIColor HHLightTextGray]];
        
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.numberOfLines = 3;
        self.infoLabel.attributedText = [self buildStringWithSchedule:schedule];
        [self addSubview:self.infoLabel];

    
        if (booking) {
            self.expLabel = [self createLabelWithTitle:@"一次只能预约一节课, 这节课完成后才可预约新课程, 确定预约这节课吗?" font:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightestTextGray]];
            self.expLabel.textAlignment = NSTextAlignmentLeft;
            
            self.midLine = [[UIView alloc] init];
            self.midLine.backgroundColor = [UIColor HHLightLineGray];
            [self addSubview:self.midLine];
        }
        
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        
        
        self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
        [self.buttonsView.leftButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView.rightButton addTarget:self action:@selector(confirmBook) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonsView];
        
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
    
    [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.bottom).offset(20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    if (self.midLine) {
        [self.midLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).offset(-135.0f);
            make.left.equalTo(self.left).offset(20.0f);
            make.width.equalTo(self.width).offset(-40.0f);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    
    if (self.expLabel) {
        [self.expLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.midLine.bottom).offset(15.0f);
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.midLine.width);
        }];
    }
    
    [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.0f);
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

- (NSMutableAttributedString *)buildStringWithSchedule:(HHCoachSchedule *)schedule {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"日期: 2015年10月10日\n时间: (7:00 - 12:00)\n科目: 科目二    阶段: 新手" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
     return attributedString;
}

- (void)confirmBook {
    if (self.confirmBlock) {
        self.confirmBlock(self.schedule);
    }
}

- (void)dismissView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
