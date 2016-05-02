//
//  HHBonusSummary.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHBonusSummary : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *pendingAmount;
@property (nonatomic, strong) NSNumber *availableAmount;
@property (nonatomic, strong) NSNumber *redeemedAmount;

@end
