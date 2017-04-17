//
//  HHMapCoachCardView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 17/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHCoachBadgeView.h"
#import "HHCoachTagView.h"
#import "HHStarRatingView.h"

@interface HHMapCoachCardView : UIView

- (instancetype)initWithCoach:(HHCoach *)coach;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHCoachBadgeView *badgeView;
@property (nonatomic, strong) HHCoachTagView *drivingSchoolView;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;

@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *moreLabel;

@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIButton *onlineSupportButton;
@property (nonatomic, strong) UIButton *checkFieldButton;

@end
