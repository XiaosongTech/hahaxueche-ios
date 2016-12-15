//
//  HHAppVersionUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 13/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Harpy/Harpy.h>

@interface HHAppVersionUtility : NSObject

+ (HHAppVersionUtility *)sharedManager;
- (void)checkVersionInVC:(UIViewController *)inVC;

@end
