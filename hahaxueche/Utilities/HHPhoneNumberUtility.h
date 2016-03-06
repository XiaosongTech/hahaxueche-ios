//
//  HHPhoneNumberUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBPhoneNumberUtil.h"

@interface HHPhoneNumberUtility : NSObject

@property (nonatomic, strong) NBPhoneNumberUtil *numberUtil;

+ (instancetype)sharedInstance;

- (BOOL)isValidPhoneNumber:(NSString *)number;

@end
