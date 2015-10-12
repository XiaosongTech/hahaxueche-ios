//
//  HHCoachDashBoardTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDashView.h"
#import "HHCoach.h"
#import "HHTrainingField.h"

typedef void (^HHDashViewTappedCompletion)();

@interface HHCoachDashBoardTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) HHDashView *priceView;
@property (nonatomic, strong) HHDashView *courseView;
@property (nonatomic, strong) HHDashView *yearView;
@property (nonatomic, strong) HHDashView *passedStudentAmountView;
@property (nonatomic, strong) HHDashView *currentStudentAmountView;
@property (nonatomic, strong) HHDashView *phoneNumberView;
@property (nonatomic, strong) HHDashView *addressView;

@property (nonatomic, strong) UIView *firstHorizontalLine;
@property (nonatomic, strong) UIView *secondHorizontalLine;
@property (nonatomic, strong) UIView *thirdHorizontalLine;

@property (nonatomic, strong) HHDashViewTappedCompletion phoneTappedCompletion;
@property (nonatomic, strong) HHDashViewTappedCompletion addressTappedCompletion;
@property (nonatomic, strong) HHDashViewTappedCompletion priceTappedCompletion;

- (void)setupViewsWithCoach:(HHCoach *)coach trainingFielf:(HHTrainingField *)field;

@end
