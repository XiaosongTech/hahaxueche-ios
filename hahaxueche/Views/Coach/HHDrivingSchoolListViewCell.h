//
//  HHDrivingSchoolListViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 02/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDrivingSchool.h"
#import "HHStarRatingView.h"
#import <MapKit/MapKit.h>
#import "HHField.h"
#import "HHCoachTagView.h"
#import "HHGradientButton.h"

typedef void (^HHSchooCallBlock)();

@interface HHDrivingSchoolListViewCell : UITableViewCell

- (void)setupCellWithSchool:(HHDrivingSchool *)school;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) HHGradientButton *callButton;
@property (nonatomic, strong) UILabel *consultNumLabel;

@property (nonatomic, strong) UIView *fieldContainerView;
@property (nonatomic, strong) UIView *fieldContainerLine;
@property (nonatomic, strong) UILabel *fieldLeftLabel;
@property (nonatomic, strong) UILabel *fieldRightLabel;

@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *priceArrow;
@property (nonatomic, strong) UIView *grouponView;

@property (nonatomic, strong) HHDrivingSchool *school;

@property (nonatomic, strong) HHSchooCallBlock callBlock;

@end
