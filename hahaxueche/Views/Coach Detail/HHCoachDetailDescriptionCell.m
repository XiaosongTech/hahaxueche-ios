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
    [self.likeButton setImage:[UIImage imageNamed:@"ic_list_best_click"] forState:UIControlStateNormal];
    [self.likeButton addTarget:self action:@selector(likeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.likeButton];
    
    self.likeCountLabel = [[UILabel alloc] init];
    self.likeCountLabel.text = @"77";
    self.likeCountLabel.textColor = [UIColor HHOrange];
    self.likeCountLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:self.likeCountLabel];
    
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
        make.bottom.equalTo(self.nameLabel.bottom);
        make.right.equalTo(self.likeCountLabel.left).offset(-3.0f);
    }];
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    self.nameLabel.text = coach.name;
    [self.nameLabel sizeToFit];
    
    self.descriptionLabel.text = coach.bio;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
}

- (void)likeButtonTapped {
    
}

@end
