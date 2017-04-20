//
//  HHMapCoachCardView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 17/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHMapCoachCardView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSNumber+HHNumber.h"

@implementation HHMapCoachCardView

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coach = coach;
        
        __weak HHMapCoachCardView *weakSelf = self;
        
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(100.0f);
        }];
        
        
        UIView *botView = [[UIView alloc] init];
        [self addSubview:botView];
        [botView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.bottom);
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(40.0f);
        }];
        
        self.avatarView = [[UIImageView alloc] init];
        self.avatarView.contentMode = UIViewContentModeScaleAspectFit;
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
        [topView addSubview:self.avatarView];
        [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.top).offset(15.0f);
            make.left.equalTo(topView.left).offset(15.0f);
            make.width.mas_equalTo(70.0f);
            make.height.mas_equalTo(70.0f);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.text = coach.name;
        self.nameLabel.textColor = [UIColor HHTextDarkGray];
        self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [topView addSubview:self.nameLabel];
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.right).offset(10.0f);
            make.top.equalTo(self.avatarView.top).offset(5.0f);
        }];
        
        self.badgeView = [[HHCoachBadgeView alloc] initWithCoach:coach];
        [topView addSubview:self.badgeView];
        [self.badgeView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.centerY);
            make.left.equalTo(self.nameLabel.right).offset(3.0f);
        }];
        
        self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
        self.starRatingView.value = [coach.averageRating floatValue];
        [topView addSubview:self.starRatingView];
        [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.top.equalTo(self.nameLabel.bottom);
            make.height.mas_equalTo(20.0f);
            make.width.mas_equalTo(80.0f);
        }];
        
        self.ratingLabel = [[UILabel alloc] init];
        self.ratingLabel.attributedText = [self generateRatingTextWithCoach:coach];
        [topView addSubview:self.ratingLabel];
        [self.ratingLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.starRatingView.right).offset(3.0f);
            make.centerY.equalTo(self.starRatingView.centerY);
        }];
        
        self.priceTitleLabel = [[UILabel alloc] init];
        self.priceTitleLabel.textColor = [UIColor whiteColor];
        self.priceTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.priceTitleLabel.backgroundColor = [UIColor HHOrange];
        self.priceTitleLabel.font = [UIFont systemFontOfSize:10.0f];
        self.priceTitleLabel.layer.masksToBounds = YES;
        self.priceTitleLabel.text = @"超值";
        self.priceTitleLabel.layer.cornerRadius = 5.0f;
        [topView addSubview:self.priceTitleLabel];
        [self.priceTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.bottom.equalTo(self.avatarView.bottom).offset(-2.0f);
            make.height.mas_equalTo(15.0f);
            make.width.mas_equalTo(25.0f);
        }];

        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = [UIColor HHOrange];
        self.priceLabel.font = [UIFont systemFontOfSize:15.0f];
        self.priceLabel.text = [coach.price generateMoneyString];
        [topView addSubview:self.priceLabel];
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceTitleLabel.right).offset(5.0f);
            make.centerY.equalTo(self.priceTitleLabel.centerY);
        }];

        
        self.drivingSchoolView = [[HHCoachTagView alloc] init];
        self.drivingSchoolView.tapAction = ^(HHDrivingSchool *school) {
            if (weakSelf.schoolBlock) {
                weakSelf.schoolBlock([weakSelf.coach getCoachDrivingSchool]);
            }
        };
        [self.drivingSchoolView setupWithDrivingSchool:[coach getCoachDrivingSchool]];
        [topView addSubview:self.drivingSchoolView];
        [self.drivingSchoolView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.top);
            make.right.equalTo(topView.right).offset(-15.0f);
            make.width.equalTo(self.drivingSchoolView.label.width).offset(20.0f);
            make.height.mas_equalTo(16.0f);
        }];
        
        self.moreLabel = [[UILabel alloc] init];
        self.moreLabel.attributedText = [self generateMoreButtonText];
        [topView addSubview:self.moreLabel];
        [self.moreLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.drivingSchoolView.right);
            make.centerY.equalTo(self.priceTitleLabel.centerY);
        }];
        
        
        self.checkFieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkFieldButton setTitle:@"看看训练场" forState:UIControlStateNormal];
        [self.checkFieldButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.checkFieldButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.checkFieldButton.layer.masksToBounds = YES;
        self.checkFieldButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.checkFieldButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        [botView addSubview:self.checkFieldButton];
        [self.checkFieldButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(botView.left);
            make.width.equalTo(botView.width).multipliedBy(1.0f/3.0f);
            make.height.equalTo(botView.height);
            make.top.equalTo(botView.top);
        }];
        
        [self.checkFieldButton addTarget:self action:@selector(checkFieldTapped) forControlEvents:UIControlEventTouchUpInside];
        
        self.onlineSupportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.onlineSupportButton setTitle:@"在线客服" forState:UIControlStateNormal];
        [self.onlineSupportButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.onlineSupportButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.onlineSupportButton.layer.masksToBounds = YES;
        self.onlineSupportButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.onlineSupportButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        [botView addSubview:self.onlineSupportButton];
        [self.onlineSupportButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.checkFieldButton.right);
            make.width.equalTo(botView.width).multipliedBy(1.0f/3.0f);
            make.height.equalTo(botView.height);
            make.top.equalTo(botView.top);
        }];
        [self.onlineSupportButton addTarget:self action:@selector(onlineSupportTapped) forControlEvents:UIControlEventTouchUpInside];
        
        self.callButton = [[HHGradientButton alloc] initWithType:0];
        [self.callButton setAttributedTitle:[self generateCallButtonText] forState:UIControlStateNormal];
        self.callButton.layer.masksToBounds = YES;
        self.callButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.callButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        
        [botView addSubview:self.callButton];
        [self.callButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.onlineSupportButton.right);
            make.width.equalTo(botView.width).multipliedBy(1.0f/3.0f);
            make.height.equalTo(botView.height);
            make.top.equalTo(botView.top);
        }];
        [self.callButton addTarget:self action:@selector(callTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coachTapped)];
        topView.userInteractionEnabled = YES;
        [topView addGestureRecognizer:rec];
        
        
    }
    return self;
}

- (NSMutableAttributedString *)generateRatingTextWithCoach:(HHCoach *)coach {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[coach.averageRating floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [coach.reviewCount stringValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    [attString appendAttributedString:attString2];
    return attString;
}


- (NSMutableAttributedString *)generateMoreButtonText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"详情" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"arrow_map_pricedetails"];
    textAttachment.bounds = CGRectMake(2.0f, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString appendAttributedString:attrStringWithImage];
    return attributedString;
}


- (NSMutableAttributedString *)generateCallButtonText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"联系教练" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_map_phone"];
    textAttachment.bounds = CGRectMake(-2.0f, -3.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;
}


- (void)checkFieldTapped {
    if (self.checkFieldBlock) {
        self.checkFieldBlock(self.coach);
    }
}

- (void)onlineSupportTapped {
    if (self.supportBlock) {
        self.supportBlock(self.coach);
    }
}

- (void)callTapped {
    if (self.callBlock) {
        self.callBlock(self.coach);
    }
}

- (void)coachTapped {
    if (self.coachBlock) {
        self.coachBlock(self.coach);
    }
}





@end
