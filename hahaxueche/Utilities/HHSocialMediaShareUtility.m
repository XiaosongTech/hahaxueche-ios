//
//  HHSocialMediaShareUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSocialMediaShareUtility.h"
#import "HHToastManager.h"
#import "BranchUniversalObject.h"
#import "BranchLinkProperties.h"
#import "HHStudentStore.h"
#import "HHLoadingViewUtility.h"
#import "NSString+HHURL.h"

static NSString *const kSupportQQ = @"3319762526";

@implementation HHSocialMediaShareUtility

+ (void)configure {
    [OpenShare connectQQWithAppId:@"1104872131"];
    [OpenShare connectWeiboWithAppKey:@"4933du6PHdo8FYl9"];
    [OpenShare connectWeixinWithAppId:@"wxdf5f23aa517b1a96"];
}

+ (void)shareCoachToQQFriends:(HHCoach *)coach {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [HHSocialMediaShareUtility generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
        [OpenShare shareToQQFriends:message Success:nil Fail:nil];
    }];
    
    
}

+ (void)shareCoachToQQZone:(HHCoach *)coach {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    
    [HHSocialMediaShareUtility generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
        [OpenShare shareToQQZone:message Success:nil Fail:nil];
    }];
    
}

+ (void)shareCoachToWeixinSession:(HHCoach *)coach {
    if (![OpenShare isWeixinInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
        return;
    }
    [HHSocialMediaShareUtility generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
        [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
    }];
    
    
}

+ (void)shareCoachToWeixinTimeline:(HHCoach *)coach {
    if (![OpenShare isWeixinInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
        return;
    }
    [HHSocialMediaShareUtility generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
        [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
    }];

}


+ (void)generateShareMessageWithCoach:(HHCoach *)coach completion:(MessageCompletion)completion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    
    NSString *baseURL = nil;
#ifdef DEBUG
    baseURL = @"http://staging-share.hahaxueche.net/share/coaches/%@?target=%@";
#else
    baseURL = @"http://api.hahaxueche.net/share/coaches/%@?target=%@";
    
#endif
    
    OSMessage *msg = [[OSMessage alloc] init];
    [HHSocialMediaShareUtility generateBranchLink:coach completion:^(NSString *url, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        msg.title = @"哈哈学车-开启快乐学车之旅";
        msg.link = [NSString stringWithFormat:baseURL, coach.coachId, [url urlEncode]];
        msg.desc = [NSString stringWithFormat:@"好友力荐:\n哈哈学车优秀教练%@", coach.name];
        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ic_share"]);
        msg.image = imageData;
        msg.thumbnail = imageData;
        msg.multimediaType = OSMultimediaTypeNews;
        if (completion) {
            completion(msg);
        }
    }];
    
}

+ (void)generateBranchLink:(HHCoach *)coach completion:(callbackWithUrl)completion {
    
    BranchUniversalObject *branchUniversalObject = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:coach.coachId];
    branchUniversalObject.title = @"Share Coach";
    branchUniversalObject.contentDescription = @"Share coach link";
    [branchUniversalObject addMetadataKey:@"coachId" value:coach.coachId];
    
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"sharing";
    linkProperties.channel = @"iOS";
    [branchUniversalObject getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *error) {
        if (completion) {
            completion(url, error);
        }
    }];
}


+ (void)talkToSupportThroughQQ {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare chatWithQQNumber:kSupportQQ];
}





@end
