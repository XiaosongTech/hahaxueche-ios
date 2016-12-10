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
    
    self.trainingYearLabel = [self createLabelWithFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightTextGray]];
    [self.trainingYearLabel sizeToFit];
    [self addSubview:self.trainingYearLabel];
    
    self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    self.starRatingView.value = 5.0;
    [self addSubview:self.starRatingView];
    
    self.ratingLabel = [self createLabelWithFont:[UIFont systemFontOfSize:14.0f] textColor:[UIColor HHOrange]];
    [self addSubview:self.ratingLabel];
    
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat insetAmount = 5.0f;
    self.mapButton.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    self.mapButton.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
    self.mapButton.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
    [self.mapButton setImage:[UIImage imageNamed:@"ic_list_local_btn"] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor HHLightTextGray] forState:UIControlStateNormal];
    self.mapButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.mapButton sizeToFit];
    [self addSubview:self.mapButton];
    self.mapButton.adjustsImageWhenHighlighted = NO;
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:[UIImage imageNamed:@"ic_list_best_small"] forState:UIControlStateNormal];
    self.likeButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.likeButton];
    
    self.likeCountLabel = [[UILabel alloc] init];
    self.likeCountLabel.textColor = [UIColor HHOrange];
    self.likeCountLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:self.likeCountLabel];
    
    if ([self.coach isGoldenCoach] || [self.coach.hasDeposit boolValue]) {
        self.badgeView = [[HHCoachBadgeView alloc] initWithCoach:self.coach];
        [self addSubview:self.badgeView];
        
    }
    
    if (self.coach.drivingSchool && ![self.coach.drivingSchool isEqualToString:@""]) {
        self.jiaxiaoView = [[HHCoachTagView alloc] init];
        [self.jiaxiaoView setDotColor:[UIColor HHOrange] title:self.coach.drivingSchool];
        [self addSubview:self.jiaxiaoView];
        
    }
    [self makeConstraints];
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f (%@)",[self.coach.averageRating floatValue], [self.coach.reviewCount stringValue]];;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.coach.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_coach_ava"]];
    self.nameLabel.text = self.coach.name;
    self.trainingYearLabel.text = [NSString stringWithFormat:@"%@年教龄", [self.coach.experienceYear stringValue]];
    self.starRatingView.value = [self.coach.averageRating floatValue];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self.field cityAndDistrict] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    
    
    if ([HHStudentStore sharedInstance].currentLocation) {
        [attributedString appendAttributedString:[self generateDistanceStringWithField:self.field userLocation:[HHStudentStore sharedInstance].currentLocation]];
        [self.mapButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    } else {
        [self.mapButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
    
    self.likeCountLabel.text = [self.coach.likeCount stringValue];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(10.0f);
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
    
    [self.mapButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left).offset(3.0f);
        make.top.equalTo(self.starRatingView.bottom).offset(5.0f);
    }];
    
    [self.trainingYearLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-15.0f);
        make.centerY.equalTo(self.nameLabel.centerY);
    }];

    
    [self.likeCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mapButton.centerY).offset(2.0f);
        make.right.equalTo(self.right).offset(-20.0f);
    }];
    
    [self.likeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mapButton.centerY);
        make.right.equalTo(self.likeCountLabel.left).offset(-3.0f);
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
            make.centerX.equalTo(self.avatarView.centerX);
            make.top.equalTo(self.avatarView.bottom).offset(5.0f);
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


- (NSMutableAttributedString *)generateDistanceStringWithField:(HHField *)field userLocation:(CLLocation *)location {
    //1.将两个经纬度点转成投影点
    MKMapPoint point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude));
    MKMapPoint point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]));
    //2.计算距离
    CLLocationDistance distance = MKMetersBetweenMapPoints(point1,point2);
    NSNumber *disNumber = @(distance/1000.0f);
    if ([disNumber doubleValue] > 50.0f) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"  距您" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:@"50+" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
        
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        [attString appendAttributedString:attString2];
        [attString appendAttributedString:attString3];
        return attString;
    } else {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"  距您" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[[HHFormatUtility floatFormatter] stringFromNumber:disNumber] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
        
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        [attString appendAttributedString:attString2];
        [attString appendAttributedString:attString3];
        return attString;
    }
    
}


@end
