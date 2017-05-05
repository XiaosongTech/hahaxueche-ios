//
//  HHDrivingSchool.h
//  hahaxueche
//
//  Created by Zixiao Wang on 13/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHDrivingSchool : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *schoolId;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, strong) NSNumber *coachCount;
@property (nonatomic, strong) NSNumber *fieldCount;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *reviewCount;
@property (nonatomic, copy) NSString *passRate;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSNumber *lowestPrice;
@property (nonatomic, strong) NSNumber *consultCount;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *consultPhone;
@property (nonatomic, strong) NSArray *zones;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *nearestFieldZone;
@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, copy) NSString *bio;

@end
