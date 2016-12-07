//
//  HHCoachListViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachListViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIView+HHRect.h"
#import "HHFormatUtility.h"
#import "NSNumber+HHNumber.h"
#import <UIImageView+WebCache.h>

static CGFloat const kAvatarRadius = 30.0f;

@implementation HHCoachListViewCell

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
    
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat insetAmount = 5.0f;
    self.mapButton.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    self.mapButton.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
    self.mapButton.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
    [self.mapButton setImage:[UIImage imageNamed:@"ic_list_local_btn"] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor HHLightTextGray] forState:UIControlStateNormal];
    self.mapButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.mapButton sizeToFit];
    [self.mapButton addTarget:self action:@selector(mapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.mapButton];
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.hidden = YES;
    self.mapView.delegate = self;
    self.mapView.layer.cornerRadius = 5.0f;
    self.mapView.layer.masksToBounds = YES;
    self.mapView.layer.borderColor = [UIColor HHOrange].CGColor;
    self.mapView.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    self.mapView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.mapView];
    [self.contentView bringSubviewToFront:self.mapView];
    
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
    
    self.jiaxiaoView = [[HHCoachTagView alloc] init];
    [self.contentView addSubview:self.jiaxiaoView];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(20.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.right).offset(15.0f);
        make.top.equalTo(self.contentView.top).offset(16.0f);
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
        make.right.equalTo(self.contentView.right).offset(-15.0f);
        make.centerY.equalTo(self.nameLabel.centerY);
    }];
    
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapButton.bottom).offset(5.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.width.equalTo(self.contentView.width).offset(-30.0f);
        make.height.mas_equalTo(200.0f);
    }];
    
    [self.likeCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mapButton.centerY);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
    }];
    
    [self.likeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mapButton.centerY);
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

- (void)mapButtonTapped {
    if (self.mapButtonBlock) {
        self.mapButtonBlock();
    }

    MACoordinateRegion mapRegion;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    mapRegion.center = CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]);
    
    [self.mapView setRegion:mapRegion animated: YES];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]) animated:NO];
    
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]);
    pointAnnotation.title = self.field.name;
    pointAnnotation.subtitle = self.field.address;
    [self.mapView addAnnotation:pointAnnotation];
}

- (void)setupCellWithCoach:(HHCoach *)coach field:(HHField *)field userLocation:(CLLocation *)location mapShowed:(BOOL)mapShowed {
    self.field = field;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f (%@)",[coach.averageRating floatValue], [coach.reviewCount stringValue]];;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_coach_ava"]];
    self.nameLabel.text = coach.name;
    self.trainingYearLabel.text = [NSString stringWithFormat:@"%@年教龄", [coach.experienceYear stringValue]];
    
    self.starRatingView.value = [coach.averageRating floatValue];
    
    NSMutableAttributedString *attributedString;
    if ([field cityAndDistrict]) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:[field cityAndDistrict] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    }
    
    if (location) {
        [attributedString appendAttributedString:[self generateDistanceStringWithField:field userLocation:location]];
        [self.mapButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    } else {
        [self.mapButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
    
    self.likeCountLabel.text = [coach.likeCount stringValue];
    
    if (coach.drivingSchool && ![coach.drivingSchool isEqualToString:@""]) {
        [self.jiaxiaoView setDotColor:[UIColor HHOrange] title:coach.drivingSchool];
        self.jiaxiaoView.hidden = NO;
    } else {
        self.jiaxiaoView.hidden = YES;
    }
    
    if ([coach isGoldenCoach] || [coach.hasDeposit boolValue]) {
        if (self.badgeView) {
            [self.badgeView removeFromSuperview];
        }
        self.badgeView = [[HHCoachBadgeView alloc] initWithCoach:coach];
        [self.contentView addSubview:self.badgeView];
        [self.badgeView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(3.0f);
            make.centerY.equalTo(self.nameLabel.centerY);
            make.right.equalTo(self.badgeView.preView.right);
        }];
    }
    
    [self.jiaxiaoView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarView.centerX);
        make.top.equalTo(self.avatarView.bottom).offset(8.0f);
        make.width.equalTo(self.jiaxiaoView.label.width).offset(20.0f);
        make.height.mas_equalTo(16.0f);
    }];
    
    
    if (self.priceView) {
        [self.priceView removeFromSuperview];
        self.priceView = nil;
    }
    
    UIView *baseView = self.mapButton;
    if (mapShowed) {
        baseView = self.mapView;
    }
    self.priceView = [[HHPriceView alloc] initWithTitle:@"超值" subTitle:@"四人一车, 性价比高" price:coach.price];
    [self.contentView addSubview:self.priceView];
    [self.priceView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView.bottom).offset(15.0f);
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(40.0f);
    }];
    
}

#pragma mark - MapView Delegate Methods

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    } else {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"ic_map_local_choseon"];
        annotationView.canShowCallout = YES;
        return annotationView;
        
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MAAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
            continue;
        }
        [mapView selectAnnotation:view.annotation animated:NO];
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
