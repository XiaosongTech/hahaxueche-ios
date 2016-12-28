//
//  HHGuardViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 23/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

@interface HHGuardViewController : UIViewController

- (instancetype)initWithCoach:(HHCoach *)coach;

@property (nonatomic, strong) HHCoach *coach;

@end
