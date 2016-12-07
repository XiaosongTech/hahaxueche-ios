//
//  HHCoachListViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import <MAMapKit/MAMapKit.h>
#import "HHField.h"
#import "HHCoach.h"
#import <MAMapKit/MAMapKit.h>
#import "HHCoachTagView.h"
#import "HHPriceView.h"
#import "HHCoachBadgeView.h"

typedef void (^HHMapButtonActionBlock)();

@interface HHCoachListViewCell : UITableViewCell <MAMapViewDelegate>

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHCoachBadgeView *badgeView;
@property (nonatomic, strong) UILabel *trainingYearLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;

@property (nonatomic, strong) HHCoachTagView *jiaxiaoView;
@property (nonatomic, strong) HHPriceView *priceView;


@property (nonatomic, strong) HHField *field;

@property (nonatomic, strong) HHMapButtonActionBlock mapButtonBlock;

- (void)setupCellWithCoach:(HHCoach *)coach field:(HHField *)field userLocation:(CLLocation *)location mapShowed:(BOOL)mapShowed;


@end
