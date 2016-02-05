//
//  HHCoach.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCoach : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *coachId;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSNumber *averageRatig;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *marketPrice;
@property (nonatomic, strong) NSString *experienceYear;
@property (nonatomic, strong) NSNumber *reviewCount;
@property (nonatomic, strong) NSNumber *skillLevel;
@property (nonatomic, strong) NSNumber *totalStudentCount;
@property (nonatomic, strong) NSNumber *activeStudentCount;

@end
