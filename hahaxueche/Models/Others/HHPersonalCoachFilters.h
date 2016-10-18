//
//  HHPersonalCoachFilters.h
//  hahaxueche
//
//  Created by Zixiao Wang on 18/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHPersonalCoachFilters : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *price;

// 1: C1, 2: C2, 3: C1 and C2
@property (nonatomic, copy) NSNumber *licenseType;

@end
