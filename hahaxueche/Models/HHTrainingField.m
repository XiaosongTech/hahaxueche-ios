//
//  HHTrainingField.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTrainingField.h"

@implementation HHTrainingField

@dynamic name;
@dynamic address;
@dynamic district;
@dynamic city;
@dynamic latitude;
@dynamic longitude;
@dynamic province;

+ (NSString *)parseClassName {
    return @"TrainingField";
}


@end
