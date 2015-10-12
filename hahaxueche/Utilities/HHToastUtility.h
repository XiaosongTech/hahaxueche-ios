//
//  HHToastUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHToastUtility : NSObject

+ (void)showToastWitiTitle:(NSString *)title isError:(BOOL)isError;
+ (void)showToastWitiTitle:(NSString *)title timeInterval:(NSNumber *)interval isError:(BOOL)isError;

@end
