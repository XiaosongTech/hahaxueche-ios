//
//  HHAlipayService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/30/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "HHAlipayOrder.h"


typedef void (^HHAliPayServiceGenericCompletionBlock)(NSDictionary *dictionary);

@interface HHAlipayService : NSObject

+ (instancetype)sharedInstance;

- (void)payByAlipayWith:(HHAlipayOrder *)order completion:(HHAliPayServiceGenericCompletionBlock) completion;

@end

