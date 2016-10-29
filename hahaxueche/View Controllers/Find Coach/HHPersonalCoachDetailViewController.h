//
//  HHPersonalCoachDetailViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 20/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPersonalCoach.h"

typedef void (^HHPersonalCoachUpdateBlock)(HHPersonalCoach *coach);

@interface HHPersonalCoachDetailViewController : UIViewController

- (instancetype)initWithCoach:(HHPersonalCoach *)coach;
- (instancetype)initWithCoachId:(NSString *)coachId;

@property (nonatomic, strong) HHPersonalCoachUpdateBlock coachUpdateBlock;

@end
