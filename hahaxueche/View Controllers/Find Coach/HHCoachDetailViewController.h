//
//  HHCoachDetailViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

@interface HHCoachDetailViewController : UIViewController

- (instancetype)initWithCoach:(HHCoach *)coach;
- (instancetype)initWithCoachId:(NSString *)coachId;

@end
