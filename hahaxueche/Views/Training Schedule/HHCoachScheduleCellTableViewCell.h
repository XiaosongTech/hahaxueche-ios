//
//  HHCoachScheduleCellTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachSchedule.h"

static NSInteger kAvatarRadius = 25.0f;

typedef void (^HHBookScheduleBlock)(HHCoachSchedule *schedule);

@interface HHCoachScheduleCellTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *stickView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *coachNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *otherInfoLabel;
@property (nonatomic, strong) UIButton *botButton;

@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) HHBookScheduleBlock bookBlock;
@property (nonatomic, strong) HHCoachSchedule *schedule;

@property (nonatomic, strong) NSMutableArray *avaArray;


- (void)setupCellWithSchedule:(HHCoachSchedule *)schedule showLine:(BOOL)showLine showDate:(BOOL)showDate;

@end
