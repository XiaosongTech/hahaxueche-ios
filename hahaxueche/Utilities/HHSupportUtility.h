//
//  HHOnlineSupportUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYSDK.h"

@interface HHSupportUtility : NSObject

+ (HHSupportUtility *)sharedManager;

- (QYSessionViewController *)buildOnlineSupportVCInNavVC:(UINavigationController *)navVC;
- (void)callSupport;

@end
