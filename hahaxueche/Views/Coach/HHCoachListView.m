//
//  HHCoachListView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachListView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHFormatUtility.h"
#import "NSNumber+HHNumber.h"
#import <UIImageView+WebCache.h>
#import "HHStudentStore.h"
#import <MapKit/MapKit.h>

static CGFloat const kAvatarRadius = 30.0f;

@implementation HHCoachListView

- (instancetype)initWithCoach:(HHCoach *)coach field:(HHField *)field {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.field = field;
        self.coach = coach;
        
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    self.avatarView.layer.masksToBounds = YES;
    [self addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1]];
    [self.nameLabel sizeToFit];
    [self addSubview:self.nameLabel];
    
    self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    self.starRatingView.value = 5.0;
    [self addSubview:self.starRatingView];
    
    self.ratingLabel = [[UILabel alloc] init];
    [self addSubview:self.ratingLabel];
    
    self.fieldLabel = [[UILabel alloc] init];
    [self addSubview:self.fieldLabel];
    
    if ([self.coach isGoldenCoach] || [self.coach.hasDeposit boolValue]) {
        self.badgeView = [[HHCoachBadgeView alloc] initWithCoach:self.coach];
        [self addSubview:self.badgeView];
        
    }
    
    if (self.coach.drivingSchool && ![self.coach.drivingSchool isEqualToString:@""]) {
        self.jiaxiaoView = [[HHCoachTagView alloc] init];
        [self.jiaxiaoView setupWithDrivingSchool:[self.coach getCoachDrivingSchool]];
        [self addSubview:self.jiaxiaoView];
        
    }
    [self makeConstraints];
    
    self.ratingLabel.attributedText = [self generateRatingText];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.coach.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_coach_ava"]];
    self.nameLabel.text = self.coach.name;
    self.starRatingView.value = [self.coach.averageRating floatValue];
    
    
    self.fieldLabel.attributedText = [self generateDistanceWithCoach:self.coach];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(15.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.right).offset(15.0f);
        make.top.equalTo(self.top).offset(16.0f);
    }];
    
    [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(3.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.ratingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starRatingView.right).offset(3.0f);
        make.centerY.equalTo(self.starRatingView.centerY);
    }];
    
    [self.fieldLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left).offset(3.0f);
        make.top.equalTo(self.starRatingView.bottom).offset(5.0f);
    }];

    
    if (self.badgeView) {
        [self.badgeView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(3.0f);
            make.centerY.equalTo(self.nameLabel.centerY);
            make.right.equalTo(self.badgeView.preView.right);
        }];
    }
    
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.avatarView.right).offset(15.0f);
        make.right.equalTo(self.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    if (self.jiaxiaoView) {
        [self.jiaxiaoView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-15.0f);
            make.centerY.equalTo(self.nameLabel.centerY);
            make.width.equalTo(self.jiaxiaoView.label.width).offset(20.0f);
            make.height.mas_equalTo(16.0f);
        }];
    }
   
}


- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


- (NSMutableAttributedString *)generateDistanceWithCoach:(HHCoach *)coach {
    HHField *field = [coach getCoachField];
    if (!field.district || !field.name) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSMutableAttributedString *baseString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@", field.district, field.name] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    
    
    if ([coach.distance doubleValue] > 50.0f) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"  距您" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:@"50+" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
        
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        [baseString appendAttributedString:attString];
        [baseString appendAttributedString:attString2];
        [baseString appendAttributedString:attString3];
    } else if ([coach.distance doubleValue] <= 50.0f && [coach.distance doubleValue] > 0) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"  距您" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[[HHFormatUtility floatFormatter] stringFromNumber:coach.distance] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
        
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        [baseString appendAttributedString:attString];
        [baseString appendAttributedString:attString2];
        [baseString appendAttributedString:attString3];
    }
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_list_local_btn"];
    textAttachment.bounds = CGRectMake(-2, -2, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [baseString insertAttributedString:attrStringWithImage atIndex:0];
    
    return baseString;
    
}

- (NSMutableAttributedString *)generateRatingText {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[self.coach.averageRating floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [self.coach.reviewCount stringValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    [attString appendAttributedString:attString2];
    return attString;
}


@end
