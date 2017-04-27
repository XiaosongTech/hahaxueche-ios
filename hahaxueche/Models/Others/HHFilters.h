//
//  HHFilters.h
//  hahaxueche
//
//  Created by Zixiao Wang on 27/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHFilters : NSObject <NSCopying>

@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) NSString *zone;
@property (nonatomic, copy) NSNumber *priceStart;
@property (nonatomic, copy) NSNumber *priceEnd;

// 1: C1, 2: C2, 3: C1 and C2
@property (nonatomic, copy) NSNumber *licenseType;

@end
