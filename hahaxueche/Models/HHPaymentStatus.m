//
//  HHPaymentStatus.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/28/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStatus.h"

@implementation HHPaymentStatus

@dynamic transactionId;
@dynamic stageOneAmount;
@dynamic stageTwoAmount;
@dynamic stageThreeAmount;
@dynamic stageFourAmount;
@dynamic stageFiveAmount;
@dynamic currentStage;


+ (NSString *)parseClassName {
    return @"PaymentStatus";
}


@end
