//
//  HHTestSimuLandingViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTestQuestionManager.h"

@interface HHTestSimuLandingViewController : UIViewController

- (instancetype)initWithCourseMode:(CourseMode)courseMode;

@property (nonatomic) CourseMode courseMode;

@end
