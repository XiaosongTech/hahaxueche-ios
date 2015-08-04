//
//  HHReviewViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/3/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

@interface HHReviewViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *reviews;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic) NSInteger initialIndex;

@end
