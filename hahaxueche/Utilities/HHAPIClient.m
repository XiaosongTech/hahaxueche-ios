//
//  HHAPIClient.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/7/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAPIClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "HHKeychainStore.h"


@implementation HHAPIClient

- (id)initWithManager:(AFHTTPRequestOperationManager *)manager path:(NSString *)path {
    self = [super init];
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        self.APIPath = path;
        self.requestManager = manager;
        [self.requestManager.requestSerializer setValue:kContentTypeHeaderValue forHTTPHeaderField:kContentTypeHeaderKey];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestManager.reachabilityManager startMonitoring];
        if ([[HHKeychainStore getSavedAccessToken] length]) {
            [self.requestManager.requestSerializer setValue:[HHKeychainStore getSavedAccessToken] forHTTPHeaderField:kAccessTokenHeaderKey];
        }
}
    
    return self;
}

+ (HHAPIClient *)apiClientWithPath:(NSString *)path {
    HHAPIClient *client = [[self alloc] initWithManager:[self sharedRequestManager] path:path];
    client.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    return client;
}

+ (AFHTTPRequestOperationManager *)sharedRequestManager {
    static dispatch_once_t predicate = 0;
    static AFHTTPRequestOperationManager *requestManager = nil;
    
    dispatch_once(&predicate, ^() {

    #ifdef DEBUG
         requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kStagingAPIBaseURL]];
    #else
         requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kProductionAPIBaseURL]];
    #endif

        
    });
    
    return requestManager;
}

- (void)parseResponse:(id)response fromOperation:(AFHTTPRequestOperation *)operation completion:(HHAPIClientCompletionBlock)completion {
    if (completion) {
        completion(response, nil);
    }
    
}

- (void)handleError:(NSError *)error requestOperation:(AFHTTPRequestOperation *)requestOperation completion:(HHAPIClientCompletionBlock)completion {
    [self handleError:&error requestOperation:requestOperation];
    if (completion) {
        completion(nil, error);
    }
    
}

- (void)handleError:(NSError **)error requestOperation:(AFHTTPRequestOperation *)requestOperation {
    NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
    userInfo[NSLocalizedDescriptionKey] = requestOperation.responseObject[@"message"];
    userInfo[NSLocalizedFailureReasonErrorKey] = requestOperation.responseObject[@"code"];
    *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:userInfo];
}

#pragma mark - Methods

- (AFHTTPRequestOperation *)getWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion {
    
    AFHTTPRequestOperation *requestOperation = [self.requestManager GET:self.APIPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseResponse:responseObject fromOperation:operation completion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleError:error requestOperation:operation completion:completion];
    }];
    
    return requestOperation;
}

- (AFHTTPRequestOperation *)postWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion {
    
    AFHTTPRequestOperation *requestOperation = [self.requestManager POST:self.APIPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseResponse:responseObject fromOperation:operation completion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleError:error requestOperation:operation completion:completion];
    }];
    
    return requestOperation;
}

- (AFHTTPRequestOperation *)putWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion {
    AFHTTPRequestOperation *requestOperation = [self.requestManager PUT:self.APIPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseResponse:responseObject fromOperation:operation completion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleError:error requestOperation:operation completion:completion];
    }];
    return requestOperation;
}

@end
