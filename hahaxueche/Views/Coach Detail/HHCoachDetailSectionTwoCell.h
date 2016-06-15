//
//  HHCoachDetailSectionTwoCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCollaborateCoachesView.h"
#import "HHCoachDetailSingleInfoView.h"
#import "HHCoach.h"

typedef void (^HHCoachDetailPeerCoachActionBlock)(NSInteger index);

@interface HHCoachDetailSectionTwoCell : UITableViewCell

@property (nonatomic, strong) HHCoachDetailSingleInfoView *satisfactionCell;
@property (nonatomic, strong) HHCoachDetailSingleInfoView *coachLevelCell;
@property (nonatomic, strong) HHCoachDetailSingleInfoView *coachTimeCell;
@property (nonatomic, strong) HHCollaborateCoachesView *coachesListCell;

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *secHorizontalLine;

@property (nonatomic, strong) HHCoachDetailCellActionBlock peerCoachAction;


- (void)setupWithCoach:(HHCoach *)coach;

@end
