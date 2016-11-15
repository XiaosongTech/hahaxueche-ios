//
//  HHPurchaseConfirmViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

typedef NS_ENUM(NSInteger, LicenseType) {
    LicenseTypeC1, // c1
    LicenseTypeC2, //c2
};

typedef NS_ENUM(NSInteger, ClassType) {
    ClassTypeStandard, // 超值
    ClassTypeVIP, //VIP
};

@interface HHPurchaseConfirmViewController : UIViewController

- (instancetype)initWithCoach:(HHCoach *)coach validVouchers:(NSArray *)validVouchers;

@end
