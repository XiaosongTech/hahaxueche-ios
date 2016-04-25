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
#import "HHStudentStore.h"

static NSString *const kSupportQQ = @"3319762526";

@implementation HHSocialMediaShareUtility

+ (void)configure {
    [OpenShare connectQQWithAppId:@"1104872131"];
    [OpenShare connectWeiboWithAppKey:@"4933du6PHdo8FYl9"];
    [OpenShare connectWeixinWithAppId:@"wxdf5f23aa517b1a96"];
}

+ (void)shareCoach:(HHCoach *)coach shareType:(ShareType)shareType {
    switch (shareType) {
        case ShareTypeQQ: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [HHSocialMediaShareUtility generateShareMessageWithCoach:coach messageType:MessageTypeShareCoach completion:^(OSMessage *message) {
                [OpenShare shareToQQFriends:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            
            [HHSocialMediaShareUtility generateShareMessageWithCoach:coach messageType:MessageTypeShareCoach completion:^(OSMessage *message) {
                [OpenShare shareToQQZone:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [HHSocialMediaShareUtility generateShareMessageWithCoach:coach messageType:MessageTypeShareCoach completion:^(OSMessage *message) {
                [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
            }];

        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [HHSocialMediaShareUtility generateShareMessageWithCoach:coach messageType:MessageTypeShareCoach completion:^(OSMessage *message) {
                [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
            }];

        } break;
            
        default:
            break;
    }
}

+ (void)generateShareMessageWithCoach:(HHCoach *)coach messageType:(MessageType)messageType  completion:(MessageCompletion)completion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    NSString *baseURL = nil;
    
    OSMessage *msg = [[OSMessage alloc] init];
    msg.multimediaType = OSMultimediaTypeNews;
    
    switch (messageType) {
        case MessageTypeShareCoach: {
#ifdef DEBUG
            baseURL = @"http://staging-share.hahaxueche.net/share/coaches/%@?target=%@";
#else
            baseURL = @"http://share.hahaxueche.net/share/coaches/%@?target=%@";
            
#endif
            
            msg.title = @"哈哈学车-开启快乐学车之旅";
            msg.desc = [NSString stringWithFormat:@"好友力荐:\n哈哈学车优秀教练%@", coach.name];
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ic_share"]);
            msg.image = imageData;
            msg.thumbnail = imageData;
            [HHSocialMediaShareUtility generateBranchLink:coach completion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.link = [NSString stringWithFormat:baseURL, coach.coachId, [url urlEncode]];
                if (completion) {
                    completion(msg);
                }
            }];
        } break;
        
        case MessageTypeUserReferLink: {
            msg.title = nil;
            msg.desc = nil;
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ic_share"]);
            msg.image = imageData;
            msg.thumbnail = imageData;
            [HHSocialMediaShareUtility generateBranchLinkForUserReferWithCompletion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.link = nil;
                if (completion) {
                    completion(msg);
                }
            }];
        } break;
            
        default:
            break;
    }

}

+ (void)generateBranchLinkForUserReferWithCompletion:(callbackWithUrl)completion {
    
    BranchUniversalObject *branchUniversalObject = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:[HHStudentStore sharedInstance].currentStudent.studentId];
    branchUniversalObject.title = @"Share Refer Link";
    branchUniversalObject.contentDescription = @"Share Refer Link";
    [branchUniversalObject addMetadataKey:@"refererId" value:[HHStudentStore sharedInstance].currentStudent.userId];
    
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"user refer";
    linkProperties.channel = @"iOS";
    [branchUniversalObject getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *error) {
        if (completion) {
            completion(url, error);
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

+ (void)shareUserLinkWithType:(ShareType)shareType {
    switch (shareType) {
        case ShareTypeQQ: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            
            [HHSocialMediaShareUtility generateShareMessageWithCoach:nil messageType:MessageTypeUserReferLink completion:^(OSMessage *message) {
                [OpenShare shareToQQFriends:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [HHSocialMediaShareUtility generateShareMessageWithCoach:nil messageType:MessageTypeUserReferLink completion:^(OSMessage *message) {
                [OpenShare shareToQQZone:message Success:nil Fail:nil];
            }];

            
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [HHSocialMediaShareUtility generateShareMessageWithCoach:nil messageType:MessageTypeUserReferLink completion:^(OSMessage *message) {
                [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
            }];
            
            
        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            
            [HHSocialMediaShareUtility generateShareMessageWithCoach:nil messageType:MessageTypeUserReferLink completion:^(OSMessage *message) {
                [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
            }];
            
        } break;
            
        default:
            break;
    }
}



+ (void)talkToSupportThroughQQ {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare chatWithQQNumber:kSupportQQ];
}





@end
