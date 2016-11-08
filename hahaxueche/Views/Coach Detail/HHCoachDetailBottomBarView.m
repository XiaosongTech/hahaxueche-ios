//
//  HHCoachDetailBottomBarView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailBottomBarView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"


@implementation HHCoachDetailBottomBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    
    self.tryCoachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tryCoachButton setTitle:@"免费试学" forState:UIControlStateNormal];
    [self.tryCoachButton setBackgroundColor:[UIColor HHOrange]];
    [self.tryCoachButton addTarget:self action:@selector(tryCoachButtonTapped)
                  forControlEvents:UIControlEventTouchUpInside];
    self.tryCoachButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:self.tryCoachButton];
    
    self.purchaseCoachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.purchaseCoachButton setTitle:@"立即购买" forState:UIControlStateNormal];
    self.purchaseCoachButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.purchaseCoachButton setBackgroundColor:[UIColor HHDarkOrange]];
    [self.purchaseCoachButton addTarget:self action:@selector(purchaseCoachButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.purchaseCoachButton];
    
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.topLine];
    
    [self makeConstraints];

}

- (void)makeConstraints {
    
    [self.tryCoachButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.width.equalTo(self.width).multipliedBy(0.5f);
        make.height.equalTo(self.height);
    }];
    
    [self.purchaseCoachButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tryCoachButton.right);
        make.top.equalTo(self.top);
        make.width.equalTo(self.width).multipliedBy(0.5f);
        make.height.equalTo(self.height);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}


#pragma mark - Button Actions

- (void)tryCoachButtonTapped {
    if (self.tryCoachAction) {
        self.tryCoachAction();
    }
}

- (void)purchaseCoachButtonTapped {
    if (self.purchaseCoachAction) {
        self.purchaseCoachAction();
    }
}

@end
