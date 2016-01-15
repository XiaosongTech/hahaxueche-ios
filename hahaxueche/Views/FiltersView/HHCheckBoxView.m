//
//  HHCheckBoxView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCheckBoxView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

static CGFloat const kCheckBoxLength = 20.0f;
static CGFloat const kPadding = 10.0f;

@implementation HHCheckBoxView

- (instancetype)initWithTilte:(NSString *)title isChecked:(BOOL)isChecked {
    self = [super init];
    if (self) {
        self.containerView = [[UIView alloc] init];
        [self addSubview:self.containerView];
        
        self.checkBox = [[BEMCheckBox alloc] init];
        self.checkBox.on = isChecked;
        self.checkBox.boxType = BEMBoxTypeSquare;
        self.checkBox.onAnimationType = BEMAnimationTypeBounce;
        self.checkBox.offAnimationType = BEMAnimationTypeBounce;
        self.checkBox.onCheckColor = [UIColor whiteColor];
        self.checkBox.onTintColor = [UIColor HHOrange];
        self.checkBox.onFillColor = [UIColor HHOrange];
        self.checkBox.lineWidth = 1.0f;
        [self.containerView addSubview:self.checkBox];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.containerView addSubview:self.titleLabel];
        [self.titleLabel sizeToFit];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(kCheckBoxLength + kPadding + CGRectGetWidth(self.titleLabel.bounds));
        make.height.equalTo(self);
    }];
    
    [self.checkBox makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.centerY);
        make.left.equalTo(self.containerView.left);
        make.width.mas_equalTo(kCheckBoxLength);
        make.height.mas_equalTo(kCheckBoxLength);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkBox.right).offset(kPadding);
        make.centerY.equalTo(self.containerView.centerY);
    }];
    
}

@end
