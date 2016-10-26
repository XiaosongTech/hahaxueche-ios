//
//  HHMyCoachPeerCoachesTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 26/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMyPageItemTitleView.h"
#import "HHCoach.h"

typedef void (^HHMyCoachPeerCoachActionBlock)(NSInteger index);

@interface HHMyCoachPeerCoachesTableViewCell : UITableViewCell

@property (nonatomic, strong) HHMyPageItemTitleView *titleView;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) HHMyCoachPeerCoachActionBlock coachAction;

- (void)setupWithCoach:(HHCoach *)coach;

@end
