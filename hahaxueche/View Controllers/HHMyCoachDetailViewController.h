//
//  HHMyCoachDetailViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CoachCell) {
    CoachCellDescription,
    CoachCellBasicInfo,
    CoachCellCourseInfo,
    CoachCellPartnerCoach,
    CoachCellCount,
};

@interface HHMyCoachDetailViewController : UIViewController

- (instancetype)initWithCoachId:(NSString *)coachId;



@end
