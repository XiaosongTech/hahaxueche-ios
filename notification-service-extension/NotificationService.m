//
//  NotificationService.m
//  notification-service-extension
//
//  Created by Zixiao Wang on 08/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "NotificationService.h"
#import "GeTuiExtSdk.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService


- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    //使用 handelNotificationServiceRequest 上报推送送达数据。
    [GeTuiExtSdk handelNotificationServiceRequest:request withComplete:^{
        
        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
        // 待展示推送的回调处理需要放到回执完成的回调中
        self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
