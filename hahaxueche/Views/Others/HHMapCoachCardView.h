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
#import "HHGradientButton.h"


typedef void (^HHMapViewCoachCompletion)(HHCoach *coach);

@interface HHMapCoachCardView : UIView

- (instancetype)initWithCoach:(HHCoach *)coach field:(HHField *)field;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHCoachBadgeView *badgeView;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;

@property (nonatomic, strong) UIImageView *priceImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *moreLabel;

@property (nonatomic, strong) HHGradientButton *callButton;
@property (nonatomic, strong) UIButton *sendLocationButton;
@property (nonatomic, strong) UIButton *checkFieldButton;

@property (nonatomic, strong) HHCoach *coach;


@property (nonatomic, strong) HHMapViewCoachCompletion checkFieldBlock;
@property (nonatomic, strong) HHMapViewCoachCompletion sendLocationBlock;
@property (nonatomic, strong) HHMapViewCoachCompletion callBlock;
@property (nonatomic, strong) HHMapViewCoachCompletion coachBlock;

@end
