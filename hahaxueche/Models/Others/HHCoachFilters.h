//
//  HHCoachFilters.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCoachFilters : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) NSNumber *price;

// 1: C1, 2: C2, 3: C1 and C2
@property (nonatomic, copy) NSNumber *licenseType;
@property (nonatomic, copy) NSNumber *onlyGoldenCoach;

@end
