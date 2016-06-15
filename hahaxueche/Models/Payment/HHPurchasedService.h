//
//  HHPurchasedService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHCoachAssignment.h"
#import "HHPaymentStage.h"

@interface HHPurchasedService : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, copy) NSString *chargeId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSNumber *currentStage;
@property (nonatomic, copy) NSString *purchasedServiceId;
@property (nonatomic, copy) NSNumber *paidAmount;
@property (nonatomic, copy) NSNumber *totalAmount;
@property (nonatomic, copy) NSNumber *unpaidAmount;
@property (nonatomic, copy) NSNumber *productType;
@property (nonatomic, strong) NSArray *paymentStages;
@property (nonatomic, strong) NSDate *paidAt;

- (HHPaymentStage *)getCurrentPaymentStage;
- (BOOL)isFinished;

@end
