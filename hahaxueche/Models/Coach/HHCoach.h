//
//  HHCoach.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHField.h"

@interface HHCoach : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSNumber *averageRating;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSNumber *marketPrice;
@property (nonatomic, copy) NSNumber *VIPPrice;
@property (nonatomic, copy) NSNumber *VIPMarketPrice;
@property (nonatomic, copy) NSNumber *experienceYear;
@property (nonatomic, copy) NSNumber *reviewCount;
@property (nonatomic, copy) NSNumber *skillLevel;
@property (nonatomic, copy) NSNumber *totalStudentCount;
@property (nonatomic, copy) NSNumber *activeStudentCount;
@property (nonatomic, copy) NSNumber *satisfactionRate;
@property (nonatomic, copy) NSNumber *serviceType;
@property (nonatomic, copy) NSNumber *licenseType;
@property (nonatomic, copy) NSString *consultant;
@property (nonatomic, copy) NSArray *peerCoaches;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *cellPhone;
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSString *fieldId;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSNumber *liked;
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSString *drivingSchool;

// 0 = 优秀教练; 1 = 金牌教练
- (BOOL)isGoldenCoach;
- (NSString *)licenseTypesName;
- (NSString *)serviceTypesName;
- (NSString *)satistactionString;
- (NSString *)skillLevelString;

- (HHField *)getCoachField;

@end
