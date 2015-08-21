//
//  HHMyReservationTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachSchedule.h"
#import "HHStudent.h"

typedef void (^HHReservationGenericActionBlock)();
typedef void (^HHReservationAvatarActionBlock)(HHStudent *student);

@interface HHMyReservationTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *coachNameButton;
@property (nonatomic, strong) UILabel *courseLabel;
@property (nonatomic, strong) UILabel *studentsLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HHCoachSchedule *reservation;
@property (nonatomic, strong) NSMutableArray *avatarViewsArray;
@property (nonatomic, strong) NSMutableArray *students;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *firstVerticalLine;
@property (nonatomic, strong) UIView *secondVerticalLine;

@property (nonatomic, strong) HHReservationGenericActionBlock nameButtonBlock;
@property (nonatomic, strong) HHReservationGenericActionBlock avatarActionBlock;

- (void)setupViews;

@end
