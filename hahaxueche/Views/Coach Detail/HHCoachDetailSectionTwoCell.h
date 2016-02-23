//
//  HHCoachDetailSectionTwoCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoachDetailSectionOneCell.h"
#import "HHCollaborateCoachesView.h"

typedef void (^HHCoachDetailCellActionBlock)();

@interface HHCoachDetailSectionTwoCell : UITableViewCell

@property (nonatomic, strong) HHCoachDetailSingleInfoView *satisfactionCell;
@property (nonatomic, strong) HHCoachDetailSingleInfoView *coachLevelCell;
@property (nonatomic, strong) HHCoachDetailSingleInfoView *coachTimeCell;
@property (nonatomic, strong) HHCollaborateCoachesView *coachesListCell;

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *secHorizontalLine;


- (void)setupWithCoach:(HHCoach *)coach;

@end
