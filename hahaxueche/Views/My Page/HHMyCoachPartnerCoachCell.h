//
//  HHMyCoachPartnerCoachCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCollaborateCoachesView.h"

@interface HHMyCoachPartnerCoachCell : UITableViewCell

@property (nonatomic, strong) HHCollaborateCoachesView *coachListView;

- (void)setupWithCoachList:(NSArray *)coachList;

@end
