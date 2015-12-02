//
//  HHCoachScheduleCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/25/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachSchedule.h"
#import "HHTimeSlotTableViewCell.h"

@interface HHCoachScheduleCell : UITableViewCell

@property (nonatomic, strong) HHCoachSchedule *schedule;
@property (nonatomic, strong) NSArray *students;
@property (nonatomic, strong) NSMutableArray *avatarViews;
@property (nonatomic, strong) NSMutableArray *nameButtons;
@property (nonatomic, strong) AvatarTappedBlock block;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *firstVerticalLine;
@property (nonatomic, strong) UIView *secondVerticalLine;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *courseLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *progressLabel;

@end
