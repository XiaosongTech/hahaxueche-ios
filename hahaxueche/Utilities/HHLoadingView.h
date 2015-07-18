//
//  HHLoadingViewUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHLoadingView : NSObject


+ (instancetype)sharedInstance;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
