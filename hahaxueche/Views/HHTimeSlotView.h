//
//  HHTimeSlotView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachSchedule.h"
#import "HHStudent.h"

typedef void (^AvatarTappedBlock)(HHStudent *student);

@interface HHTimeSlotView : UIView

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *courseLabel;
@property (nonatomic, strong) HHCoachSchedule *schedule;
@property (nonatomic, strong) AvatarTappedBlock block;

- (instancetype)initWithSchedule:(HHCoachSchedule *)schedule;

@end
