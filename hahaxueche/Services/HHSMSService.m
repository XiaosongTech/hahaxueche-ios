//
//  HHSMSService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/15/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHSMSService.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const smsBaseURL = @"http://yunpian.com/v1/sms/send.json";
static NSString *const apikey = @"96af9e187a9aeabcf018fd19815ab45a";


static NSString *const kTryCoachTemplate = @"【哈哈学车】学员%@（%@）向您申请预约试学。请尽快电话联系！客服电话：400-001-6006";
static NSString *const kTransactionToStudentTemplate = @"【哈哈学车】学员%@，您已成功购买%@教练课程。客服电话：400-001-6006";
static NSString *const kTransactionToCoachTemplate = @"【哈哈学车】学员%@（%@）已成功购买您的学车课程，请尽快电话联系！客服电话：400-001-6006";

@interface HHSMSService ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation HHSMSService

+ (HHSMSService *)sharedInstance {
    static HHSMSService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHSMSService alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}


- (void)sendTryCoachSMSToCoach:(NSString *)coachNumber studentName:(NSString *)name studentNumber:(NSString *)studentNumber completion:(HHSMSGenericCompletionBlock)completion {
    
    NSString *text = [NSString stringWithFormat:kTryCoachTemplate, name, studentNumber];
    NSDictionary *param = @{@"apikey":apikey, @"mobile":coachNumber, @"text":text};
    [self.manager POST:smsBaseURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"code"]  isEqual: @(0)]) {
            if (completion) {
                completion(YES);
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];

}

- (void)sendTransactionSucceedSMSToCoach:(NSString *)coachNumber studentName:(NSString *)name studentNumber:(NSString *)studentNumber completion:(HHSMSGenericCompletionBlock)completion {
    
    NSString *text = [NSString stringWithFormat:kTransactionToCoachTemplate, name, studentNumber];
    NSDictionary *param = @{@"apikey":apikey, @"mobile":coachNumber, @"text":text};
    [self.manager POST:smsBaseURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"code"]  isEqual: @(0)]) {
            if (completion) {
                completion(YES);
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];

}

- (void)sendTransactionSucceedSMSToStudent:(NSString *)studentNumber studentName:(NSString *)name coachName:(NSString *)coachName completion:(HHSMSGenericCompletionBlock)completion {
    
    NSString *text = [NSString stringWithFormat:kTransactionToStudentTemplate, name, coachName];
    NSDictionary *param = @{@"apikey":apikey, @"mobile":studentNumber, @"text":text};
    [self.manager POST:smsBaseURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"code"]  isEqual: @(0)]) {
            if (completion) {
                completion(YES);
            }
            
        } else {
            if (completion) {
               completion(NO);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];

}


@end
