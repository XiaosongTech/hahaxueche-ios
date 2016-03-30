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

@interface HHConstantsStore ()

@property (nonatomic, strong) HHConstants *constants;

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
    if ([HHConstantsStore sharedInstance].constants) {
        if (completion) {
            completion([HHConstantsStore sharedInstance].constants);
        }
    } else {
        HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIConstantsPath];
        [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
            if (!error) {
                HHConstants *constants = [MTLJSONAdapter modelOfClass:[HHConstants class] fromJSONDictionary:response error:nil];
                [HHConstantsStore sharedInstance].constants = constants;
                if (completion) {
                    completion([HHConstantsStore sharedInstance].constants);
                }
            } else {
                if (completion) {
                    completion(nil);
                }
            }
        }];

    }
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

@end
