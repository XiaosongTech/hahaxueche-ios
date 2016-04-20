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
    [OpenShare shareToQQFriends:[HHSocialMediaShareUtility generateShareMessageWithCoach:coach] Success:nil Fail:nil];
}

+ (void)shareCoachToQQZone:(HHCoach *)coach {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare shareToQQZone:[HHSocialMediaShareUtility generateShareMessageWithCoach:coach] Success:nil Fail:nil];
}

+ (void)shareCoachToWeixinSession:(HHCoach *)coach {
    if (![OpenShare isWeixinInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
        return;
    }
    [OpenShare shareToWeixinSession:[HHSocialMediaShareUtility generateShareMessageWithCoach:coach] Success:nil Fail:nil];
}

+ (void)shareCoachToWeixinTimeline:(HHCoach *)coach {
    if (![OpenShare isWeixinInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
        return;
    }
    [OpenShare shareToWeixinTimeline:[HHSocialMediaShareUtility generateShareMessageWithCoach:coach] Success:nil Fail:nil];

}


+ (OSMessage *)generateShareMessageWithCoach:(HHCoach *)coach {
    OSMessage *msg = [[OSMessage alloc] init];
    msg.title = @"哈哈学车-开启快乐学车之旅";
    msg.link = [NSString stringWithFormat:@"http://staging-api.hahaxueche.net/branch_links?target=%@", [[HHSocialMediaShareUtility generateBranchLink:coach] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    msg.desc = [NSString stringWithFormat:@"好友力荐:\n哈哈学车优秀教练%@", coach.name];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ic_share"]);
    msg.image = imageData;
    msg.thumbnail = imageData;
    msg.multimediaType = OSMultimediaTypeApp;
    return msg;
}

+ (NSString *)generateBranchLink:(HHCoach *)coach {
    BranchUniversalObject *branchUniversalObject = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:coach.coachId];
    branchUniversalObject.title = @"Share Coach";
    branchUniversalObject.contentDescription = @"Share coach link";
    [branchUniversalObject addMetadataKey:@"coachId" value:coach.coachId];
    
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"sharing";
    linkProperties.channel = @"iOS";
    return [branchUniversalObject getShortUrlWithLinkProperties:linkProperties];
}


+ (void)talkToSupportThroughQQ {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare chatWithQQNumber:kSupportQQ];
}



@end
