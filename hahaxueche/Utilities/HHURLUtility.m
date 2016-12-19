//
//  HHURLUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 17/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHURLUtility.h"
#import "HHAPIClient.h"

@implementation HHURLUtility

+ (HHURLUtility *)sharedManager {
    static HHURLUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHURLUtility alloc] init];
    });
    
    return manager;
}

- (NSString *)generateShortURLWithOriginalURL:(NSString *)string {
    return nil;
}

@end
