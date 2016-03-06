//
//  HHPaymentStatus.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStage.h"
#import "HHFormatUtility.h"

@implementation HHPaymentStage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"paymentStageId": @"id",
             @"paidAt":@"paid_at",
             @"paymentMethodId":@"payment_method_id",
             @"reviewable":@"reviewable",
             @"stageAmount":@"stage_amount",
             @"stageNumber":@"stage_number",
             @"stageName":@"stage_name",
             @"reviewed":@"reviewed",
             @"readyForReview":@"ready_for_review",
             @"explanationText":@"description",
             @"coachUserId":@"coach_user_id",
             };
}

+ (NSValueTransformer *)paidAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

@end
