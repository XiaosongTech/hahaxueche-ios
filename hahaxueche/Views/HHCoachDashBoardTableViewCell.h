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



- (void)setupViewsWithCoach:(HHCoach *)coach;

@end
