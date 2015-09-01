//
//  HHCoachListTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/10/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HHStarRatingView.h"
#import "HHAvatarView.h"
#import "HHCoach.h"

typedef void (^HHAddressTappedBlock)();

@interface HHCoachListTableViewCell : UITableViewCell 

@property (nonatomic, strong) UIView *dataView;
@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *actualPriceLabel;
@property (nonatomic, strong) UIImageView *locationPin;
@property (nonatomic, strong) HHStarRatingView *ratingView;
@property (nonatomic, strong) UILabel *teachedYearLabel;
@property (nonatomic, strong) UILabel *teachedStudentAmount;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) HHAddressTappedBlock addressBlock;

- (void)setupCellWithCoach:(HHCoach *)coach;
- (void)setupAddressViewWithTitle:(NSString *)title;

@end
