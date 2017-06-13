//
//  HHField.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHField : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy) NSString *fieldId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *district;
@property(nonatomic, copy) NSArray *businessAreas;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSNumber *longitude;
@property(nonatomic, copy) NSNumber *latitude;
@property(nonatomic, copy) NSNumber *cityId;
@property(nonatomic, copy) NSString *displayAddress;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSNumber *coachCount;
@property(nonatomic, copy) NSString *consultPhone;
@property(nonatomic, copy) NSArray *drivingSchoolIds;
@property(nonatomic, copy) NSNumber *zoneCenterLng;
@property(nonatomic, copy) NSNumber *zoneCenterLat;

@end
