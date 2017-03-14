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
    
    self.prepayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prepayButton setTitle:@"预付100得300" forState:UIControlStateNormal];
    self.prepayButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.prepayButton setBackgroundColor:[UIColor HHDarkOrange]];
    [self.prepayButton addTarget:self action:@selector(prepayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.prepayButton];
    
    
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
    
    [self.prepayButton makeConstraints:^(MASConstraintMaker *make) {
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

- (void)prepayButtonTapped {
    if (self.prepayAction) {
        self.prepayAction();
    }
}

@end
