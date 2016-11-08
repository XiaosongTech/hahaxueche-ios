//
//  HHMyCoachDetailViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

typedef NS_ENUM(NSInteger, CoachCell) {
    CoachCellDescription,
    CoachCellBasicInfo,
    CoachCellCourseInfo,
    CoachCellPartnerCoaches,
    CoachCellCount,
};

typedef void (^HHMyCoachUpdateBlock)(HHCoach *coach);

@interface HHMyCoachDetailViewController : UIViewController

- (instancetype)initWithCoach:(HHCoach *)coach;

@property (nonatomic, strong) HHMyCoachUpdateBlock updateCoachBlock;



@end
