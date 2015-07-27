//
//  HHCoachProfileViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/21/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHTrainingField.h"

@interface HHCoachProfileViewController : UIViewController

@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) HHTrainingField *field;

- (instancetype)initWithCoach:(HHCoach *)coach;


@end
