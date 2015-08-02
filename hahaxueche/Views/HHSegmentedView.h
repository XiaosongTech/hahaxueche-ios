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

@interface HHSegmentedView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *schedules;
@property (nonatomic, strong) NSArray *groupedSchedules;

- (instancetype)initWithSchedules:(NSArray *)schedules;

@end
