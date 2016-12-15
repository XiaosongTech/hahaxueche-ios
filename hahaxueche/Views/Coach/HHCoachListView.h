//
//  HHCoachListView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHField.h"
#import "HHStarRatingView.h"
#import "HHCoachTagView.h"
#import "HHCoachBadgeView.h"

@interface HHCoachListView : UIView

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHCoachBadgeView *badgeView;
@property (nonatomic, strong) UILabel *trainingYearLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) HHCoachTagView *jiaxiaoView;

@property (nonatomic, strong) HHField *field;
@property (nonatomic, strong) HHCoach *coach;

- (instancetype)initWithCoach:(HHCoach *)coach field:(HHField *)field;

@end
