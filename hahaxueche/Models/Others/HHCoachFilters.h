//
//  HHCoachFilters.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHCoachFilters : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSNumber *licenseType;
@property (nonatomic, copy) NSNumber *onlyGoldenCoach;

@end
