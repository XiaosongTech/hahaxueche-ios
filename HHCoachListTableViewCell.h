//
//  HHCoachListTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/10/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HHRatingView.h"

@interface HHCoachListTableViewCell : UITableViewCell 

@property (nonatomic, strong) UIView *dataView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *locationPin;
@property (nonatomic, strong) HHRatingView *ratingView;
@property (nonatomic, strong) UILabel *teachedYearLabel;
@property (nonatomic, strong) UILabel *teachedStudentAmount;
@property (nonatomic, strong) UILabel *courseLabel;

@end
