//
//  HHPaymentStatus.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStage.h"

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
             };
}

@end
