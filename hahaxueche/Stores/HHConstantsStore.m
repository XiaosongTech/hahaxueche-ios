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
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:kSavedConstants];
            [data writeToFile:filePath atomically:YES];
            
            HHConstants *constants = [MTLJSONAdapter modelOfClass:[HHConstants class] fromJSONDictionary:response error:nil];
            [HHConstantsStore sharedInstance].constants = constants;
            
            if (completion) {
                completion([HHConstantsStore sharedInstance].constants);
            }
        } else {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:kSavedConstants];
            
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSDictionary *constantDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            HHConstants *constants = [MTLJSONAdapter modelOfClass:[HHConstants class] fromJSONDictionary:constantDic error:nil];
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
    if ([HHConstantsStore sharedInstance].constants.cities) {
        return [HHConstantsStore sharedInstance].constants.cities;
    }
    return nil;
}

- (HHField *)getFieldWithId:(NSString *)fieldId {
    NSArray *fields = [HHConstantsStore sharedInstance].constants.fields;
    if ([fields count]) {
        for (HHField *field in fields) {
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

- (NSArray *)getHomePageBanners {
    return [HHConstantsStore sharedInstance].constants.homePageBanners;
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

@end
