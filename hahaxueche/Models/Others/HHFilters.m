//
//  HHFilters.m
//  hahaxueche
//
//  Created by Zixiao Wang on 27/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHFilters.h"

@implementation HHFilters

- (id)copyWithZone:(NSZone *)zone {
    HHFilters *newObject = [[HHFilters alloc] init];
    newObject.priceStart = self.priceStart;
    newObject.priceEnd = self.priceEnd;
    newObject.distance = self.distance;
    newObject.licenseType = self.licenseType;
    newObject.businessArea = self.businessArea;
    return newObject;
}

@end
