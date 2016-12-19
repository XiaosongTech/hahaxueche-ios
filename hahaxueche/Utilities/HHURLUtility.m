//
//  HHURLUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 17/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHURLUtility.h"
#import "HHAPIClient.h"
#import "NSString+HHURL.h"

@implementation HHURLUtility

+ (HHURLUtility *)sharedManager {
    static HHURLUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHURLUtility alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.t.sina.com.cn/short_url/"]];
    }
    return self;
}

- (void)generateShortURLWithOriginalURL:(NSString *)string completion:(HHURLUtilCompletion)completion {
    NSString *encodedString = [string urlEncode];
    [self.requestManager GET:@"shorten.json" parameters:@{@"source":@"4186780524", @"url_long":encodedString} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *dic = [responseObject firstObject];
            NSString *shortURL = dic[@"url_short"];
            if (completion) {
                completion(shortURL);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil);
        }
    }];

}

@end
