//
//  HHToastManager.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHToastManager : NSObject

+ (HHToastManager *)sharedManager;

- (void)showErrorToastWithText:(NSString *)text;
- (void)showSuccessToastWithText:(NSString *)text;

@end
