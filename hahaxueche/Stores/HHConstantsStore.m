//
//  HHConstantsStore.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHConstantsStore.h"
#import "HHAPIClient.h"
#import "APIPaths.h"
#import "HHStudentStore.h"
#import "HHPersistentDataUtility.h"
#import "HHLoadingViewUtility.h"

static NSString *const kSavedConstants = @"kSavedConstant";

@interface HHConstantsStore ()


@end

@implementation HHConstantsStore

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cities = [NSMutableDictionary dictionary];
    }
    return self;
}


+ (instancetype)sharedInstance {
    static HHConstantsStore *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHConstantsStore alloc] init];
    });
    
    return sharedInstance;
}

- (void)getConstantsWithCompletion:(HHConstantsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIConstantsPath];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [[HHPersistentDataUtility sharedManager] saveDataWithDic:response key:kSavedConstants];
            HHConstants *constants = [MTLJSONAdapter modelOfClass:[HHConstants class] fromJSONDictionary:response error:nil];
            [HHConstantsStore sharedInstance].constants = constants;
            
            if (completion) {
                completion([HHConstantsStore sharedInstance].constants);
            }
        } else {
            HHConstants *constants = [MTLJSONAdapter modelOfClass:[HHConstants class] fromJSONDictionary:[[HHPersistentDataUtility sharedManager] getDataWithKey:kSavedConstants] error:nil];
            [HHConstantsStore sharedInstance].constants = constants;
            if (completion) {
                completion([HHConstantsStore sharedInstance].constants);
            }
        }
    }];

}


- (NSArray *)getSupporteCities {
    if ([HHConstantsStore sharedInstance].constants.cities.count > 0) {
        return [HHConstantsStore sharedInstance].constants.cities;
    }
    return nil;
}

- (HHField *)getFieldWithId:(NSString *)fieldId {
    if ([self.fields count]) {
        for (HHField *field in self.fields) {
            if ([field.fieldId isEqualToString:fieldId]) {
                return field;
            }
        }
        
    }
    return nil;
}

- (HHCity *)getAuthedUserCity {
    NSArray *cities = [HHConstantsStore sharedInstance].constants.cities;
    NSNumber *cityId = [HHStudentStore sharedInstance].currentStudent.cityId;
    if ([cities count]) {
        for (HHCity *city in cities) {
            if ([city.cityId integerValue] == [cityId integerValue]) {
                return city;
            }
        }
        
    }
    return nil;
}

- (NSArray *)getLoginBanners {
    return [HHConstantsStore sharedInstance].constants.loginBanners;
}


- (NSArray *)getNotifications {
    return [HHConstantsStore sharedInstance].constants.notifications;
}

- (NSNumber *)getCityReferrerBonus {
    HHCity *city = [self getAuthedUserCity];
    return city.referrerBonus;
}

- (NSNumber *)getCityRefereeBonus {
    HHCity *city = [self getAuthedUserCity];
    return city.refereeBonus;
}

- (NSArray *)getAllBanks {
    return [HHConstantsStore sharedInstance].constants.banks;
}

- (NSMutableArray *)getPopularBanks {
    NSMutableArray *array = [NSMutableArray array];
    for (HHBank *bank in [HHConstantsStore sharedInstance].constants.banks) {
        if ([bank.isPopular boolValue]) {
            [array addObject:bank];
        }
    }
    return array;
}

- (HHBank *)getCardBankWithCode:(NSString *)bankCode {
    for (HHBank *bank in [HHConstantsStore sharedInstance].constants.banks) {
        if ([bank.bankCode isEqualToString:bankCode]) {
            return bank;
        }
    }
    return nil;
}

- (NSNumber *)getInsuranceWithType:(NSInteger)type {
    NSNumber *price;
    if (type == 0) {
        price = self.constants.insurancePrices[@"pay_with_new_coach_price"];
    } else if (type == 1) {
        price = self.constants.insurancePrices[@"pay_with_paid_coach_price"];
    } else {
        price = self.constants.insurancePrices[@"pay_without_coach_price"];
    }
    return price;
}

- (void)getCityWithCityId:(NSNumber *)cityId completion:(HHCityCompletion)completion {
    if (self.cities[cityId]) {
        if (completion) {
            completion(self.cities[cityId]);
        }
    } else {
        HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPICities, [cityId stringValue]]];
        [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
            if (!error) {
                HHCity *city = [MTLJSONAdapter modelOfClass:[HHCity class] fromJSONDictionary:response error:nil];
                self.cities[city.cityId] = city;
                if (completion) {
                    completion(city);
                }
            } else {
                if (completion) {
                    completion(nil);
                }
            }
        }];
    }
}

- (void)getFieldsWithCityId:(NSNumber *)cityId completion:(HHFieldsCompletion)completion {
    if (self.fields.count > 0) {
        if (completion) {
            completion(self.fields);
        }
        return;
    }
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIFields];
    [APIClient getWithParameters:@{@"city_id":cityId} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *fieldsArray = response[@"data"];
            for (NSDictionary *fieldDic in fieldsArray) {
                HHDrivingSchool *field = [MTLJSONAdapter modelOfClass:[HHField class] fromJSONDictionary:fieldDic error:nil];
                if (field) {
                    [array addObject:field];
                }
            }
            self.fields = array;
            if (completion) {
                completion(array);
            }
        }
    }];
    
}

- (HHDrivingSchool *)getDrivingSchoolWithName:(NSString *)schoolName {
    HHCity *city = self.cities[[HHStudentStore sharedInstance].selectedCityId];
    for (HHDrivingSchool *school in city.drivingSchools) {
        if ([school.schoolName isEqualToString:schoolName]) {
            return school;
        }
    }
    return nil;
}

- (HHDrivingSchool *)getDrivingSchoolWithId:(NSNumber *)schoolId {
    HHCity *city = self.cities[[HHStudentStore sharedInstance].selectedCityId];
    for (HHDrivingSchool *school in city.drivingSchools) {
        if ([school.schoolId integerValue] ==  [schoolId integerValue]) {
            return school;
        }
    }
    return nil;
}

- (NSArray *)getDrivingSchools {
    HHCity *city = self.cities[[HHStudentStore sharedInstance].selectedCityId];
    return city.drivingSchools;
}

@end
