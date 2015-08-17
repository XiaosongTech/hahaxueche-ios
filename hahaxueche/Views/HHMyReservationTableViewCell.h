//
//  HHMyReservationTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachSchedule.h"

typedef void (^HHReservationGenericActionBlock)();

@interface HHMyReservationTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *coachNameButton;
@property (nonatomic, strong) UILabel *courseLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HHCoachSchedule *reservation;
@property (nonatomic, strong) NSMutableArray *avatarViewsArray;
@property (nonatomic, strong) NSArray *students;

@property (nonatomic, strong) HHReservationGenericActionBlock nameButtonBlock;

- (void)setupViews;

@end
