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
    
    self.goldenCoachIcon = [[UIImageView alloc] init];
    self.goldenCoachIcon.contentMode = UIViewContentModeCenter;
    [self addSubview:self.goldenCoachIcon];
    
    self.trainingYearLabel = [self createLabelWithFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightTextGray]];
    [self.trainingYearLabel sizeToFit];
    [self addSubview:self.trainingYearLabel];
    
    self.priceLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHOrange]];
    [self.priceLabel sizeToFit];
    [self addSubview:self.priceLabel];
    
    self.VIPPriceLabel = [[UILabel alloc] init];
    self.VIPPriceLabel.textColor = [UIColor HHOrange];
    self.VIPPriceLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.VIPPriceLabel];
    
    self.vipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_VIP_listing"]];
    [self addSubview:self.vipIcon];
    
    if (self.coach.VIPPrice) {
        self.VIPPriceLabel.hidden = NO;
        self.vipIcon.hidden = NO;
    } else {
        self.VIPPriceLabel.hidden = YES;
        self.vipIcon.hidden = YES;
    }
    
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
    
    [self setupViewWithCoach:self.coach field:self.field userLocation:[HHStudentStore sharedInstance].currentLocation];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(20.0f);
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
    
    if (self.coach.VIPPrice) {
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarView.centerY).offset(-12.0f);
            make.right.equalTo(self.right).offset(-15.0f);
        }];
    } else {
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarView.centerY);
            make.right.equalTo(self.right).offset(-15.0f);
        }];
    }
    
    
    [self.VIPPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView.centerY).offset(12.0f);
        make.right.equalTo(self.right).offset(-15.0f);
    }];
    
    [self.vipIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.VIPPriceLabel.centerY);
        make.right.equalTo(self.VIPPriceLabel.left);
    }];
    
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.avatarView.right).offset(15.0f);
        make.right.equalTo(self.right);
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

- (void)setupViewWithCoach:(HHCoach *)coach field:(HHField *)field userLocation:(CLLocation *)location {
    self.field = field;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f (%@)",[coach.averageRating floatValue], [coach.reviewCount stringValue]];;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_coach_ava"]];
    self.nameLabel.text = coach.name;
    self.trainingYearLabel.text = [NSString stringWithFormat:@"%@年教龄", [coach.experienceYear stringValue]];
    if ([coach isGoldenCoach]) {
        self.goldenCoachIcon.hidden = NO;
        self.goldenCoachIcon.image = [UIImage imageNamed:@"ic_auth_golden"];
        [self.goldenCoachIcon remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(3.0f);
            make.centerY.equalTo(self.nameLabel.centerY);
        }];
        
        [self.trainingYearLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goldenCoachIcon.right).offset(3.0f);
            make.bottom.equalTo(self.nameLabel.bottom);
        }];
    } else {
        self.goldenCoachIcon.hidden = YES;
        [self.trainingYearLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(5.0f);
            make.bottom.equalTo(self.nameLabel.bottom);
        }];
    }
    self.starRatingView.value = [coach.averageRating floatValue];
    
    
    self.priceLabel.text = [coach.price generateMoneyString];
    
    if (self.coach.VIPPrice) {
        self.VIPPriceLabel.text = [self.coach.VIPPrice generateMoneyString];
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[field cityAndDistrict] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    
    
    if (location) {
        [attributedString appendAttributedString:[self generateDistanceStringWithField:field userLocation:location]];
        [self.mapButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    } else {
        [self.mapButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
}

- (NSMutableAttributedString *)generateDistanceStringWithField:(HHField *)field userLocation:(CLLocation *)location {
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
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
