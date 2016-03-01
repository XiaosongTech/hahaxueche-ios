//
//  HHReviewListViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHReviews.h"
#import "HHCoach.h"

@interface HHReviewListViewController : UIViewController

- (instancetype)initWithReviews:(HHReviews *)reviews coach:(HHCoach *)coach;

@end
