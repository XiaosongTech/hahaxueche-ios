//
//  HHPurchasedService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPurchasedService.h"
#import "HHFormatUtility.h"

@implementation HHPurchasedService

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"assignments": @"assignments",
             @"chargeId":@"charge_id",
             @"currentStage":@"current_payment_stage",
             @"purchasedServiceId":@"id",
             @"paidAmount":@"paid_amount",
             @"totalAmount":@"total_amount",
             @"unpaidAmount":@"unpaid_amount",
             @"paymentStages":@"payment_stages",
             @"paidAt":@"paid_at",
             @"orderNo":@"order_no",
             @"productType":@"product_type",
             };
}

+ (NSValueTransformer *)assignmentsJSONTransformer {
   return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCoachAssignment class]];
}

+ (NSValueTransformer *)paymentStagesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHPaymentStage class]];
}

+ (NSValueTransformer *)paidAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

- (HHPaymentStage *)getCurrentPaymentStage {
    if (![self isFinished]) {
        HHPaymentStage *currentStage = self.paymentStages[[self.currentStage integerValue] - 1];
        return currentStage;
    }
    return nil;
}

- (BOOL)isFinished {
    if ([self.currentStage integerValue] > self.paymentStages.count) {
        return YES;
    }
    return NO;
}


@end
