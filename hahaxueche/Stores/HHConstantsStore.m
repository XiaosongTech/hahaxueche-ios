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

- (NSArray *)getAllFieldsForCity:(NSNumber *)cityId {
    NSArray *fields = [HHConstantsStore sharedInstance].constants.fields;
    if ([fields count]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId == %ld", [cityId integerValue]];
        return [fields filteredArrayUsingPredicate:predicate];
    }
    return nil;
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


- (HHCity *)getCityWithId:(NSNumber *)cityId {
    NSArray *cities = [HHConstantsStore sharedInstance].constants.cities;
    if ([cities count]) {
        for (HHCity *city in cities) {
            if ([city.cityId integerValue] == [cityId integerValue]) {
                return city;
            }
        }
        
    }
    return nil;
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

- (void)getDrivingSchoolsWithCityId:(NSNumber *)cityId completion:(HHSchoolsCompletion)completion {
    if (self.drivingSchools.count > 0) {
        if (completion) {
            completion(self.drivingSchools);
        }
    }
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPICities, [cityId stringValue]]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *schoolsArray = response[@"driving_schools"];
            for (NSDictionary *schoolDic in schoolsArray) {
                HHDrivingSchool *school = [MTLJSONAdapter modelOfClass:[HHDrivingSchool class] fromJSONDictionary:schoolDic error:nil];
                if (school) {
                    [array addObject:school];
                }
            }
            self.drivingSchools = array;
            if (completion) {
                completion(array);
            }
        }
    }];

}

- (void)getFieldsWithCityId:(NSNumber *)cityId completion:(HHSchoolsCompletion)completion {
    if (self.fields.count > 0) {
        if (completion) {
            completion(self.fields);
        }
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
    for (HHDrivingSchool *school in self.drivingSchools) {
        if ([school.schoolName isEqualToString:schoolName]) {
            return school;
        }
    }
    return nil;
}

@end
