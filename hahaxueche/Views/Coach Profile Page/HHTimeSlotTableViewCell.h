//
//  HHTimeSlotTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachSchedule.h"
#import "HHStudent.h"

typedef void (^AvatarTappedBlock)(HHStudent *student);
typedef void (^EmptyAvatarTappedBlock)();

@interface HHTimeSlotTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *selectedIndicatorView;
@property (nonatomic, strong) UILabel *selectedInfoLabel;

@property (nonatomic, strong) HHCoachSchedule *schedule;
@property (nonatomic, strong) NSArray *students;
@property (nonatomic, strong) NSMutableArray *avatarViews;
@property (nonatomic, strong) AvatarTappedBlock block;
@property (nonatomic, strong) EmptyAvatarTappedBlock emptyAvatarblock;


@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *firstVerticalLine;
@property (nonatomic, strong) UIView *secondVerticalLine;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *courseLabel;
@property (nonatomic, strong) UILabel *amountLabel;

- (void)setupViews;
- (void)setupAvatars;

@end
