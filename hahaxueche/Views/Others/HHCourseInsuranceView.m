//
//  HHCourseInsuranceView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 30/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCourseInsuranceView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCourseInsuranceView

- (instancetype)initWithImage:(UIImage *)image count:(NSNumber *)count text:(NSString *)text buttonTitle:(NSString *)buttonTitle showSlotView:(BOOL)showSlotView peopleCount:(NSNumber *)peopleCount {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.cardView = [[UIImageView alloc] initWithImage:image];
        self.cardView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.cardView];
        [self.cardView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(20.0f);
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.width).offset(-20.0f);
        }];
        self.cardView.userInteractionEnabled = YES;
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
        [self.cardView addGestureRecognizer:rec];
        
        if (showSlotView) {
            NSNumber *finalCount = count;
            if ([count integerValue] >= 5) {
                finalCount = @(5);
            }
            self.slotView = [[HHScoreSlotView alloc] initWithCount:finalCount];
            [self addSubview:self.slotView];
            [self.slotView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.cardView.bottom).offset(10.0f);
                make.centerX.equalTo(self.centerX);
                make.width.mas_equalTo(275.0f);
                make.height.mas_equalTo(45.0f);
            }];
        }
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor HHOrange];
        self.label.text = text;
        self.label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            if (showSlotView) {
                make.top.equalTo(self.slotView.bottom).offset(20.0f);
            } else {
                make.top.equalTo(self.cardView.bottom).offset(20.0f);
            }
            make.centerX.equalTo(self.centerX);
        }];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:buttonTitle forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.button.backgroundColor = [UIColor HHOrange];
        self.button.layer.masksToBounds = YES;
        self.button.layer.cornerRadius = 5.0f;
        [self.button sizeToFit];
        [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        [self.button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.label.bottom).offset(10.0f);
            make.centerX.equalTo(self.centerX);
            make.width.mas_equalTo(CGRectGetWidth(self.button.bounds) + 30.0f);
            make.height.mas_equalTo(CGRectGetHeight(self.button.bounds) + 8.0f);
        }];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人", [peopleCount stringValue]] attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"已获得保过卡" attributes:@{NSForegroundColorAttributeName:[UIColor HHLightestTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        [string appendAttributedString:string2];
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.attributedText = string;
        [self addSubview:self.countLabel];
        [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).offset(-10.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
    }
    return self;
}

- (void)buttonTapped {
    if (self.buttonActionBlock) {
        self.buttonActionBlock();
    }
}

- (void)cardTapped {
    if (self.cardActionBlock) {
        self.cardActionBlock();
    }
}

@end
