//
//  HHSocialMediaShareUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenShareHeader.h"

@interface HHSocialMediaShareUtility : NSObject

+ (void)configure;

// QQ
+ (void)shareToQQFriendsWithSuccess:(shareSuccess)success Fail:(shareFail)fail;

+(void)shareToQQZoneWithSuccess:(shareSuccess)success Fail:(shareFail)fail;


// WeChat
+ (void)shareToWeixinSessionWithSuccess:(shareSuccess)success Fail:(shareFail)fail;
+ (void)shareToWeixinTimelineWithSuccess:(shareSuccess)success Fail:(shareFail)fail;
@end
