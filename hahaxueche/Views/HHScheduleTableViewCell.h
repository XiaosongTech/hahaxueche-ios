//
//  HHScheduleTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHSegmentedView.h"
#import "HHCoach.h"

typedef void (^BookButtonBlock)();

@interface HHScheduleTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) HHSegmentedView *scheduleView;
@property (nonatomic, strong) NSArray *schedules;
@property (nonatomic, strong) UIButton *bookButton;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) AvatarTappedBlock block;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) BookButtonBlock bookButtonBlock;

@end
