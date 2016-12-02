//
//  HHAPIClient.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/7/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIConstants.h"

static NSString *kErrorMessageKey = @"kErrorMessageKey";

typedef void (^HHAPIClientCompletionBlock)(NSDictionary *response, NSError *error);

@interface HHAPIClient : NSObject

@property (nonatomic, strong)   AFHTTPSessionManager *requestManager;
@property (nonatomic, copy)     NSString *APIPath;


+ (HHAPIClient *)apiClientWithPath:(NSString *)path;
+ (HHAPIClient *)apiClient;

- (void)postWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (void)getWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (void)putWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (void)getWithURL:(NSString *)URL completion:(HHAPIClientCompletionBlock)completion;


- (void)deleteWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (void)uploadImage:(UIImage *)image otherParam:(NSDictionary *)otherParam completion:(HHAPIClientCompletionBlock)completion progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;

@end
