//
//  HHCoachPriceDetailViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 24/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHPaymentService.h"

@interface HHCoachPriceDetailViewController : UIViewController

- (instancetype)initWithCoach:(HHCoach *)coach productType:(CoachProductType)type;

@end
