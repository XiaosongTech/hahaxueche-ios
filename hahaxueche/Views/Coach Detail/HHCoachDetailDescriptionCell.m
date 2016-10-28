//
//  HHCoachDetailDescriptionCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailDescriptionCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import <UIImageView+WebCache.h>

static CGFloat const avatarRadius = 30.0f;

@implementation HHCoachDetailDescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubview];
    }
    return self;
}

- (void)initSubview {
    self.avatarBackgroungView = [[UIView alloc] init];
    self.avatarBackgroungView.backgroundColor = [UIColor whiteColor];
    self.avatarBackgroungView.layer.cornerRadius = avatarRadius;
    self.avatarBackgroungView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarBackgroungView];
    
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = avatarRadius-2.0f;
    self.avatarView.layer.masksToBounds = YES;
    [self.avatarBackgroungView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor HHTextDarkGray];
    self.nameLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.contentView addSubview:self.nameLabel];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor HHLightTextGray];
    self.descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    self.descriptionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.descriptionLabel];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton addTarget:self action:@selector(likeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.likeButton.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:self.likeButton];
    
    self.likeCountLabel = [[UILabel alloc] init];
    self.likeCountLabel.text = @"77";
    self.likeCountLabel.textColor = [UIColor HHOrange];
    self.likeCountLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:self.likeCountLabel];
    
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.followButton setBackgroundImage:[UIImage imageNamed:@"ic_star_collect_click"] forState:UIControlStateNormal];
    [self.followButton addTarget:self action:@selector(followButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.followButton];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.avatarBackgroungView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.top);
        make.left.mas_equalTo(30.0f);
        make.width.mas_equalTo(avatarRadius * 2.0f);
        make.height.mas_equalTo(avatarRadius * 2.0);
    }];
    
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroungView);
        make.width.mas_equalTo((avatarRadius - 2.0f) * 2.0f);
        make.height.mas_equalTo((avatarRadius - 2.0f) * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarBackgroungView.right).offset(8.0f);
        make.bottom.equalTo(self.avatarBackgroungView.bottom).offset(5.0f);
    }];
    
    [self.descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarBackgroungView.bottom).offset(13.0f);
        make.centerX.equalTo(self.contentView.centerX);
        make.width.equalTo(self.contentView.width).offset(-40.0f);
    }];
    
    [self.likeCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel.bottom);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
    }];
    
    [self.likeButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel.bottom).offset(-1.0f);
        make.right.equalTo(self.likeCountLabel.left).offset(-3.0f);
    }];
    
    [self.followButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.likeButton.bottom);
        make.right.equalTo(self.likeButton.left).offset(-8.0f);
    }];
}

- (void)setupCellWithCoach:(HHCoach *)coach followed:(BOOL)followed {
    self.nameLabel.text = coach.name;
    [self.nameLabel sizeToFit];
    
    self.descriptionLabel.text = coach.bio;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
    
    if ([coach.liked boolValue]) {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_list_best_click"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_list_best_unclick"] forState:UIControlStateNormal];
    }
    self.likeCountLabel.text = [coach.likeCount stringValue];
    
    if (coach.drivingSchool && ![coach.drivingSchool isEqualToString:@""]) {
        [self.jiaxiaoView removeFromSuperview];
        self.jiaxiaoView = [[HHCoachTagView alloc] init];
        [self.contentView addSubview:self.jiaxiaoView];
        [self.jiaxiaoView setDotColor:[UIColor HHOrange] title:coach.drivingSchool];
        [self.jiaxiaoView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.centerY);
            make.left.equalTo(self.nameLabel.right).offset(3.0f);
            make.width.equalTo(self.jiaxiaoView.label.width).offset(20.0f);
            make.height.mas_equalTo(16.0f);
        }];
    } else {
        [self.jiaxiaoView removeFromSuperview];
    }
    
    if (followed) {
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"ic_star_collect_click"] forState:UIControlStateNormal];
    } else {
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"ic_star_colllect"] forState:UIControlStateNormal];
    }
    
}

- (void)setupCellWithCoach:(HHPersonalCoach *)coach {
    self.nameLabel.text = coach.name;
    [self.nameLabel sizeToFit];
    
    self.descriptionLabel.text = [coach getCoachDes];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
    
    if ([coach.liked boolValue]) {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_list_best_click"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_list_best_unclick"] forState:UIControlStateNormal];
    }
    self.likeCountLabel.text = [coach.likeCount stringValue];
    self.followButton.hidden = YES;
    self.jiaxiaoView.hidden = YES;

}

- (void)likeButtonTapped {
    if (self.likeBlock) {
        self.likeBlock(self.likeButton, self.likeCountLabel);
    }
}

- (void)followButtonTapped {
    if (self.followBlock) {
        self.followBlock();
    }
}

@end
