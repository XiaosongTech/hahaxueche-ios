//
//  HHSocialMediaShareUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenShareHeader.h"
#import "HHCoach.h"

@interface HHSocialMediaShareUtility : NSObject

+ (void)configure;

// QQ
+ (void)shareCoachToQQFriends:(HHCoach *)coach;
+ (void)shareCoachToQQZone:(HHCoach *)coach;
+ (void)talkToSupportThroughQQ;


// WeChat
+ (void)shareCoachToWeixinSession:(HHCoach *)coach;
+ (void)shareCoachToWeixinTimeline:(HHCoach *)coach;
@end
