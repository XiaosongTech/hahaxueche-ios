//
//  HHLoadingViewUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/4/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface HHLoadingViewUtility : NSObject

+ (instancetype)sharedInstance;

- (void)showLoadingView;
- (void)showLoadingViewWithText:(NSString *)text;

- (void)dismissLoadingView;
- (BOOL)isVisible;

@end
