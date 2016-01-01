//
//  HHPhoneNumberUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPhoneNumberUtility.h"

@implementation HHPhoneNumberUtility

- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberUtil = [[NBPhoneNumberUtil alloc] init];
    }
    return self;
}

+ (HHPhoneNumberUtility *)sharedInstance {
    static HHPhoneNumberUtility *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHPhoneNumberUtility alloc] init];
    });
    
    return sharedInstance;
}

- (BOOL)isValidPhoneNumber:(NSString *)number {
    NSError *anError = nil;
    NBPhoneNumber *mobileNumber = [self.numberUtil parse:number defaultRegion:@"CN" error:&anError];
    return [self.numberUtil isValidNumber:mobileNumber];
}

@end
