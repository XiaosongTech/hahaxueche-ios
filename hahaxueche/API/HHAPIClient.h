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


typedef void (^HHAPIClientCompletionBlock)(NSDictionary *response, NSError *error);

@interface HHAPIClient : NSObject

@property (nonatomic, strong)   AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, copy)     NSString *APIPath;


+ (HHAPIClient *)apiClientWithPath:(NSString *)path;
+ (HHAPIClient *)apiClient;

- (AFHTTPRequestOperation *)postWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (AFHTTPRequestOperation *)getWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (AFHTTPRequestOperation *)putWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (AFHTTPRequestOperation *)getWithURL:(NSString *)URL completion:(HHAPIClientCompletionBlock)completion;


- (void)deleteWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion;

- (void)uploadImage:(UIImage *)image completion:(HHAPIClientCompletionBlock)completion progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;

@end
