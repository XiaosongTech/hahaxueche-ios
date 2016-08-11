//
//  HHTestQuestionBottomBar.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestQuestionBottomBar.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHTestQuestionBottomBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.prevButton.backgroundColor = [UIColor HHOrange];
        [self.prevButton setTitle:@"上一题" forState:UIControlStateNormal];
        self.prevButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.prevButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.prevButton addTarget:self action:@selector(prevButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.prevButton];
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextButton.backgroundColor = [UIColor HHOrange];
        [self.nextButton setTitle:@"下一题" forState:UIControlStateNormal];
        self.nextButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
        
        self.infoLabel = [[UILabel alloc] init];
        [self addSubview:self.infoLabel];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        
        [self.prevButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.mas_equalTo(100.0f);
            make.height.equalTo(self.height);
            make.top.equalTo(self.top);
        }];
        
        [self.nextButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right);
            make.width.mas_equalTo(100.0f);
            make.height.equalTo(self.height);
            make.top.equalTo(self.top);
        }];
        
        [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
        }];
        
        [self.topLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.prevButton.right);
            make.right.equalTo(self.nextButton.left);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}

- (void)prevButtonTapped {
    if (self.prevAction) {
        self.prevAction();
    }
}

- (void)nextButtonTapped {
    if (self.nextAction) {
        self.nextAction();
    }
}

@end
