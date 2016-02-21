//
//  HHSocialMediaShareUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSocialMediaShareUtility.h"
#import "HHToastManager.h"

static NSString *const kSupportQQ = @"3319762526";

@implementation HHSocialMediaShareUtility

+ (void)configure {
    [OpenShare connectQQWithAppId:@"1104872131"];
    [OpenShare connectWeiboWithAppKey:@"4933du6PHdo8FYl9"];
    [OpenShare connectWeixinWithAppId:@"wxdf5f23aa517b1a96"];
}

+ (void)shareToQQFriendsWithSuccess:(shareSuccess)success Fail:(shareFail)fail {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare shareToQQFriends:[HHSocialMediaShareUtility generateShareMessage] Success:success Fail:fail];
}

+ (void)shareToQQZoneWithSuccess:(shareSuccess)success Fail:(shareFail)fail {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare shareToQQZone:[HHSocialMediaShareUtility generateShareMessage] Success:success Fail:fail];
}

+ (void)shareToWeixinSessionWithSuccess:(shareSuccess)success Fail:(shareFail)fail {
    if (![OpenShare isWeixinInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
        return;
    }
    [OpenShare shareToWeixinSession:[HHSocialMediaShareUtility generateShareMessage] Success:success Fail:fail];
}

+ (void)shareToWeixinTimelineWithSuccess:(shareSuccess)success Fail:(shareFail)fail {
    if (![OpenShare isWeixinInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
        return;
    }
    [OpenShare shareToWeixinTimeline:[HHSocialMediaShareUtility generateShareMessage] Success:success Fail:fail];

}


+ (OSMessage *)generateShareMessage {
    OSMessage *msg = [[OSMessage alloc] init];
    msg.title = @"哈哈学车";
    msg.link = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hahaxueche";
    msg.desc = @"开启快乐学车之旅吧～";
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ic_coachmsg_sharecoach_friendgroup"]);
    msg.image = imageData;
    msg.thumbnail = imageData;
    msg.multimediaType = OSMultimediaTypeApp;
    return msg;
}


+ (void)talkToSupportThroughQQ {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare chatWithQQNumber:kSupportQQ];
}



@end
