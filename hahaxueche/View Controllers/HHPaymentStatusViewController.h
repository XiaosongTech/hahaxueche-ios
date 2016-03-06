//
//  HHPaymentStatusViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPurchasedService.h"
#import "HHCoach.h"

typedef void (^HHPurchasedServiceBlock)(HHPurchasedService *updatedPurchasedService);

@interface HHPaymentStatusViewController : UIViewController

@property (nonatomic, strong) HHPurchasedServiceBlock updatePSBlock;

- (instancetype)initWithPurchasedService:(HHPurchasedService *)purchasedService coach:(HHCoach *)coach;

@end
