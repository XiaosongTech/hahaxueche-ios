//
//  HHTransaction.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/27/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTransaction.h"

@implementation HHTransaction

@dynamic studentId;
@dynamic coachId;
@dynamic paidPrice;
@dynamic paymentMethod;


+ (NSString *)parseClassName {
    return @"Transaction";
}

@end
