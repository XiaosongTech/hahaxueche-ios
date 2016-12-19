//
//  HHURLUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 17/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^HHURLUtilCompletion)(NSString *shortURL);

@interface HHURLUtility : NSObject

+ (HHURLUtility *)sharedManager;
- (void)generateShortURLWithOriginalURL:(NSString *)string completion:(HHURLUtilCompletion)completion;

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

@end
