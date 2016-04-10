//
//  HHScheduleRateView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHScheduleRateView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHScheduleRateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"快来给你的教练评个分吧!";
        self.titleLabel.font = [UIFont systemFontOfSize:22.0f];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.titleLabel];
        
        self.ratingView = [[HHStarRatingView alloc] initWithInteraction:YES];
        self.ratingView.value = 5.0f;
        [self addSubview:self.ratingView];
        
        self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"稍后评价" rightTitle:@"确认评价"];
        [self.buttonsView.leftButton addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView.rightButton addTarget:self action:@selector(confirmRate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonsView];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.top).offset(40.0f);
        }];
        
        [self.ratingView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.titleLabel.bottom).offset(20.0f);
            make.width.mas_equalTo(200.0f);
            make.height.mas_equalTo(40.0f);
        }];
        
        [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(60.0f);

        }];
    }
    
    return self;
}


- (void)dissmissView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmRate {
    if (self.confirmBlock) {
        self.confirmBlock(@(self.ratingView.value));
    }
}

@end
