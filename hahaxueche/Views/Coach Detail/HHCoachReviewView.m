//
//  HHCoachReviewView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachReviewView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import <UIImageView+WebCache.h>
#import "HHFormatUtility.h"

static CGFloat const kAvatarRadius = 25.0f;

@implementation HHCoachReviewView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    [self addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor HHOrange];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:self.nameLabel];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [UIColor HHLightestTextGray];
    self.dateLabel.font = [UIFont systemFontOfSize:12.0f];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.dateLabel];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.textColor = [UIColor HHLightTextGray];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:self.commentLabel];
    
    self.ratingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    [self addSubview:self.ratingView];
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.botLine];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY).offset(-10.0f);
        make.left.equalTo(self.left).offset(20.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.top).offset(5.0f);
        make.left.equalTo(self.avatarView.right).offset(10.0f);
    }];
    
    [self.ratingView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.centerY);
        make.right.equalTo(self.right).offset(-20.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.centerY);
        make.left.equalTo(self.nameLabel.right).offset(5.0f);
    }];
    
    [self.commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(5.0f);
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.right).offset(-20.0f);
        make.bottom.equalTo(self.bottom).offset(-15.0f);
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.avatarView.left);
        make.right.equalTo(self.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

- (void)setupViewWithReview:(HHReview *)review {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:review.reviewer.avatarUrl]];
    self.nameLabel.text = review.reviewer.reviewerName;
    self.dateLabel.text = [[HHFormatUtility fullDateFormatter] stringFromDate:review.updatedAt];;
    self.ratingView.value = [review.rating integerValue];
    self.commentLabel.text = review.comment;
}

@end
