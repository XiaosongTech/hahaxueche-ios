//
//  HHKeychainStore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSKeychain/SSKeychain.h>

@interface HHKeychainStore : NSObject

+ (BOOL)saveAccessToken:(NSString *)accessToken forStudentId:(NSString *)studentId;

+ (BOOL)deleteSavedStudent;

+ (NSString *)getSavedAccessToken;


@end
