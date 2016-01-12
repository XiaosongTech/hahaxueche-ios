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
            }
        }];

    }
}

@end
