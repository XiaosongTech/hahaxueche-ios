//
//  HHCoachCellView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachCellView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HHColor.h"
#import "Masonry.h"

static CGFloat const kAvatarRadius = 20.0f;

@implementation HHCoachCellView

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    self.avatarView.layer.masksToBounds = YES;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.coach.avatarUrl]];
    [self addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.coach.name;
    self.nameLabel.textColor = [UIColor HHLightTextGray];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.nameLabel];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [self addSubview:self.arrowImageView];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.bottomLine];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(25.0f);
        make.width.mas_equalTo(kAvatarRadius * 2);
        make.height.mas_equalTo(kAvatarRadius * 2);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.avatarView.right).offset(15.0f);
    }];
    
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-15.0f);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.avatarView.left);
        make.right.equalTo(self.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

@end
