//
//  HHConstantsStore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHConstants.h"
#import "HHField.h"
#import "HHCity.h"
#import "HHBank.h"
#import "HHDrivingSchool.h"

typedef void (^HHConstantsCompletion)(HHConstants *constants);
typedef void (^HHCityCompletion)(HHCity *city);
typedef void (^HHFieldsCompletion)(NSArray *data);

@interface HHConstantsStore : NSObject

@property (nonatomic, strong) HHConstants *constants;
@property (nonatomic, strong) NSMutableDictionary *cities;
@property (nonatomic, strong) NSArray *fields;

+ (instancetype)sharedInstance;
- (void)getConstantsWithCompletion:(HHConstantsCompletion)completion;
- (void)getCityWithCityId:(NSNumber *)cityId completion:(HHCityCompletion)completion;
- (void)getFieldsWithCityId:(NSNumber *)cityId completion:(HHFieldsCompletion)completion;

- (NSArray *)getDrivingSchools;
- (NSArray *)getSupporteCities;
- (HHField *)getFieldWithId:(NSString *)fieldId;
- (HHCity *)getAuthedUserCity;
- (HHDrivingSchool *)getDrivingSchoolWithName:(NSString *)schoolName;
- (HHDrivingSchool *)getDrivingSchoolWithId:(NSNumber *)schoolId;


- (NSArray *)getLoginBanners;
- (NSArray *)getNotifications;
- (NSNumber *)getCityReferrerBonus;
- (NSNumber *)getCityRefereeBonus;

- (NSArray *)getAllBanks;
- (NSArray *)getPopularBanks;
- (HHBank *)getCardBankWithCode:(NSString *)bankCode;

//type: 0, 1, 2
- (NSNumber *)getInsuranceWithType:(NSInteger)type;


@end
