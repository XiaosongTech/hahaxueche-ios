//
//  HHPersonalCoachTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 17/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

static CGFloat const kAvatarRadius = 30.0f;

#import "HHPersonalCoachTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"


@implementation HHPersonalCoachTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    self.avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1]];
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    
    
    self.trainingYearLabel = [self createLabelWithFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightTextGray]];
    [self.trainingYearLabel sizeToFit];
    [self.contentView addSubview:self.trainingYearLabel];
    
    self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    self.starRatingView.value = 5.0;
    [self.contentView addSubview:self.starRatingView];
    
    self.ratingLabel = [self createLabelWithFont:[UIFont systemFontOfSize:14.0f] textColor:[UIColor HHOrange]];
    [self.contentView addSubview:self.ratingLabel];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.bottomLine];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:[UIImage imageNamed:@"ic_list_best_small"] forState:UIControlStateNormal];
    self.likeButton.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:self.likeButton];
    
    self.likeCountLabel = [[UILabel alloc] init];
    self.likeCountLabel.textColor = [UIColor HHOrange];
    self.likeCountLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.likeCountLabel];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.right).offset(20.0f);
        make.top.equalTo(self.avatarView.top);
    }];
    
    [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(10.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.ratingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starRatingView.right).offset(3.0f);
        make.centerY.equalTo(self.starRatingView.centerY);
    }];
    
    [self.trainingYearLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15.0f);
        make.centerY.equalTo(self.nameLabel.centerY);
    }];
    
    
    [self.likeCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ratingLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
    }];
    
    [self.likeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ratingLabel.centerY);
        make.right.equalTo(self.likeCountLabel.left).offset(-3.0f);
    }];
    
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.avatarView.left);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
}


- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)setupCellWithCoach:(HHPersonalCoach *)coach {
   
    self.ratingLabel.text = @"(32)";
    self.avatarView.image = [UIImage imageNamed:@"ic_coach_ava"];
    self.nameLabel.text = @"唐骏";
    self.trainingYearLabel.text = [NSString stringWithFormat:@"%@年驾龄", @"10"];
    self.starRatingView.value = 5.0f;
    self.likeCountLabel.text = @"20";
    
    if (self.priceView) {
        [self.priceView removeFromSuperview];
        self.priceView = nil;
    }
    self.priceView = [[HHPriceView alloc] initWithTitle:@"9h" subTitle:@"短期速成, 高性价比" price:@(50000)];
    [self.contentView addSubview:self.priceView];
    [self.priceView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(40.0f);
    }];
    
}

@end
