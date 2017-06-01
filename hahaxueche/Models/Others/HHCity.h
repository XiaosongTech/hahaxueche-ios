//
//  HHCity.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCity : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *zipCode;
@property (nonatomic, copy) NSArray *priceRanges;
@property (nonatomic, copy) NSArray *distanceRanges;
@property (nonatomic, copy) NSArray *cityFixedFees;
@property (nonatomic, copy) NSArray *cityOtherFees;
@property (nonatomic, copy) NSString *referalBanner;
@property (nonatomic, copy) NSNumber *referrerBonus;
@property (nonatomic, copy) NSNumber *refereeBonus;
@property (nonatomic, copy) NSArray *drivingSchools;
@property (nonatomic, copy) NSArray *zones;
@property (nonatomic, copy) NSString *cityURLCode;

@end
