//
//  HHInsuranceOrder.h
//  hahaxueche
//
//  Created by Zixiao Wang on 01/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHInsuranceOrder : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *paidAt;
@property (nonatomic, strong) NSDate *policyStartTime;
@property (nonatomic, copy) NSString *policyNum;
@property (nonatomic, strong) NSNumber *paidAmount;

- (BOOL)isPurchased;
- (BOOL)isInsured;

@end
