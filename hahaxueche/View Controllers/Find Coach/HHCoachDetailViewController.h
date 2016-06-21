//
//  HHCoachDetailViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

typedef void (^HHCoachUpdateBlock)(HHCoach *coach);

@interface HHCoachDetailViewController : UIViewController

@property (nonatomic, strong) HHCoachUpdateBlock coachUpdateBlock;

- (instancetype)initWithCoach:(HHCoach *)coach;
- (instancetype)initWithCoachId:(NSString *)coachId;

@end
