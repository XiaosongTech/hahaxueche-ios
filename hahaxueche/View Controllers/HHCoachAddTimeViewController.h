//
//  HHCoachAddTimeViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCoachAddTimeSuccessCompletion)();


@interface HHCoachAddTimeViewController : UIViewController

@property (nonatomic, strong) HHCoachAddTimeSuccessCompletion successCompletion;

@end
