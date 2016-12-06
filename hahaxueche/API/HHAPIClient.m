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
#import "APIConstants.h"

@implementation HHAPIClient

- (id)initWithManager:(AFHTTPSessionManager *)manager path:(NSString *)path {
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

+ (HHAPIClient *)apiClient {
    HHAPIClient *client = [[self alloc] initWithManager:[AFHTTPSessionManager manager] path:nil];
    client.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    return client;
}


+ (AFHTTPSessionManager *)sharedRequestManager {
    static dispatch_once_t predicate = 0;
    static AFHTTPSessionManager *requestManager = nil;
    
    dispatch_once(&predicate, ^() {

    #ifdef DEBUG
         requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kStagingAPIBaseURL]];
    #else
         requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kProductionAPIBaseURL]];
    #endif

        
    });
    
    return requestManager;
}

- (void)parseResponse:(id)response completion:(HHAPIClientCompletionBlock)completion {
    if (completion) {
        completion(response, nil);
    }
    
}

- (void)handleError:(NSError *)error completion:(HHAPIClientCompletionBlock)completion {
    [self handleError:&error];
    if (completion) {
        completion(nil, error);
    }
    
}

- (void)handleError:(NSError **)error {
    NSMutableDictionary *userInfo = [[*error userInfo] mutableCopy];
    if (!userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                         options:kNilOptions
                                                           error:nil];
    userInfo[NSLocalizedDescriptionKey] = dic[@"description"];
    userInfo[kErrorMessageKey] = dic[@"message"];
    userInfo[NSLocalizedFailureReasonErrorKey] = dic[@"code"];
    *error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:userInfo];
}

#pragma mark - Methods

- (void)getWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion {
    [self.requestManager GET:self.APIPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseResponse:responseObject completion:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error completion:completion];
    }];
}

- (void)postWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion {
    [self.requestManager POST:self.APIPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseResponse:responseObject completion:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error completion:completion];
    }];
    
}

- (void)putWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion {
    [self.requestManager PUT:self.APIPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseResponse:responseObject completion:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error completion:completion];
    }];
}

- (void)deleteWithParameters:(NSDictionary *)params completion:(HHAPIClientCompletionBlock)completion {
    [self.requestManager DELETE:self.APIPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseResponse:responseObject completion:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error completion:completion];
    }];
    
}

- (void)uploadImage:(UIImage *)image otherParam:(NSDictionary *)otherParam completion:(HHAPIClientCompletionBlock)completion progress:(void (^)(NSUInteger, long long, long long))progress {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:otherParam];
    param[@"file"] = imageData;
    
    [self.requestManager POST:self.APIPath parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"profile.jpeg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseResponse:responseObject completion:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error completion:completion];
    }];

}

- (void)getWithURL:(NSString *)URL completion:(HHAPIClientCompletionBlock)completion {
    [self.requestManager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseResponse:responseObject completion:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error completion:completion];
    }];

}


@end
