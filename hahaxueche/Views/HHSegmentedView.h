//
//  HHSegmentedView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "HHCoachSchedule.h"
#import "HHTimeSlotView.h"

@interface HHSegmentedView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *schedules;
@property (nonatomic, strong) NSArray *groupedSchedules;
@property (nonatomic, strong) AvatarTappedBlock block;

- (instancetype)initWithSchedules:(NSArray *)schedules block:(AvatarTappedBlock)block;
- (void)setupScrollView;
@end
