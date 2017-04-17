//
//  HHCoachListViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import <MapKit/MapKit.h>
#import "HHField.h"
#import "HHCoach.h"
#import "HHCoachTagView.h"
#import "HHPriceView.h"
#import "HHCoachBadgeView.h"
#import "HHDrivingSchool.h"

typedef void (^HHMapButtonActionBlock)();
typedef void (^HHDrivingSchoolBlock)(HHDrivingSchool *school);

@interface HHCoachListViewCell : UITableViewCell <MKMapViewDelegate>

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHCoachBadgeView *badgeView;
@property (nonatomic, strong) UILabel *trainingYearLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;

@property (nonatomic, strong) HHCoachTagView *jiaxiaoView;
@property (nonatomic, strong) HHPriceView *priceView;


@property (nonatomic, strong) HHField *field;

@property (nonatomic, strong) HHMapButtonActionBlock mapButtonBlock;
@property (nonatomic, strong) HHDrivingSchoolBlock drivingSchoolBlock;

- (void)setupCellWithCoach:(HHCoach *)coach field:(HHField *)field mapShowed:(BOOL)mapShowed;


@end
