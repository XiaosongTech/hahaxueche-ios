//
//  HHScheduleViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHCoachListViewController.h"

typedef enum : NSUInteger {
    TimeSlotFilterAll,
    TimeSlotFilterCourseTwo,
    TimeSlotFilterCourseThree,
} TimeSlotFilter;

@interface HHTimeSlotsViewController : UIViewController

@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groupedSchedules;
@property (nonatomic, strong) NSArray *sectionTiltes;

- (void)fetchSchedulesWithCompletion:(HHGenericCompletion)completion;

@end
