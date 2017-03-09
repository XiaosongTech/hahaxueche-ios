//
//  HHPurchaseConfirmViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHPaymentService.h"


@interface HHPurchaseConfirmViewController : UIViewController

- (instancetype)initWithCoach:(HHCoach *)coach selectedType:(CoachProductType)type;

@end
