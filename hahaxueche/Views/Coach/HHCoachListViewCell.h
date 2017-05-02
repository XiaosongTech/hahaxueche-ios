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
#import "HHGradientButton.h"

typedef void (^HHMapButtonActionBlock)();
typedef void (^HHDrivingSchoolBlock)(HHDrivingSchool *school);

@interface HHCoachListViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHCoachBadgeView *badgeView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) HHGradientButton *callButton;
@property (nonatomic, strong) UILabel *consultNumLabel;

@property (nonatomic, strong) HHCoachTagView *jiaxiaoView;
@property (nonatomic, strong) HHPriceView *priceView;
@property (nonatomic, strong) UIImageView *mapArrow;


@property (nonatomic, strong) HHField *field;
@property (nonatomic, strong) HHCoach *coach;

@property (nonatomic, strong) HHMapButtonActionBlock mapButtonBlock;
@property (nonatomic, strong) HHDrivingSchoolBlock drivingSchoolBlock;

- (void)setupCellWithCoach:(HHCoach *)coach field:(HHField *)field;

@end
