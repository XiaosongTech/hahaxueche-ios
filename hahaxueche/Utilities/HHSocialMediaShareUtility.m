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

+ (instancetype)sharedInstance {
    static HHSocialMediaShareUtility *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHSocialMediaShareUtility alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [OpenShare connectQQWithAppId:@"1104872131"];
        [OpenShare connectWeiboWithAppKey:@"4186780524"];
        [OpenShare connectWeixinWithAppId:@"wxdf5f23aa517b1a96"];
    }
    return self;
}

- (void)shareCoach:(HHCoach *)coach shareType:(ShareType)shareType {
    switch (shareType) {
        case ShareTypeQQ: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
                [OpenShare shareToQQFriends:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
                [OpenShare shareToWeibo:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
                [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
            }];

        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach completion:^(OSMessage *message) {
                [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
            }];

        } break;
            
        default:
            break;
    }
}

- (void)generateShareMessageWithCoach:(HHCoach *)coach completion:(MessageCompletion)completion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    NSString *baseURL = nil;
    
    OSMessage *msg = [[OSMessage alloc] init];
    msg.multimediaType = OSMultimediaTypeNews;
    
#ifdef DEBUG
    baseURL = @"http://staging-api.hahaxueche.net/share/coaches/%@?target=%@";
#else
    baseURL = @"http://api.hahaxueche.net/share/coaches/%@?target=%@";
    
#endif
    
    msg.title = @"哈哈学车-开启快乐学车之旅吧~";
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

    



}

- (void)generateUserReferLinkWithCompletion:(MessageCompletion)completion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    if ([HHSocialMediaShareUtility sharedInstance].userReferMessage) {
        if (completion) {
            completion([HHSocialMediaShareUtility sharedInstance].userReferMessage);
        }
    }
    
    NSString *baseURL = nil;
    
#ifdef DEBUG
    baseURL = @"http://staging-api.hahaxueche.net/share/coaches/%@?target=%@";
#else
    baseURL = @"http://api.hahaxueche.net/share/coaches/%@?target=%@";
    
#endif

    OSMessage *msg = [[OSMessage alloc] init];
    msg.multimediaType = OSMultimediaTypeNews;
    msg.title = @"好友向你推荐哈哈学车";
    msg.desc = @"注册立享50元优惠";
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ic_share"]);
    msg.image = imageData;
    msg.thumbnail = imageData;
    [[HHSocialMediaShareUtility sharedInstance] generateBranchLinkForUserReferWithCompletion:^(NSString *url, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        msg.link = [NSString stringWithFormat:@"http://staging-api.hahaxueche.net/share/invitations?target=%@", [url urlEncode]];
        if (completion) {
            completion(msg);
        }
    }];
}

- (void)generateBranchLinkForUserReferWithCompletion:(callbackWithUrl)completion {
    
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

- (void)shareUserLinkWithType:(ShareType)shareType {
    switch (shareType) {
        case ShareTypeQQ: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithCompletion:^(OSMessage *message) {
                [OpenShare shareToQQFriends:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithCompletion:^(OSMessage *message) {
                [OpenShare shareToWeibo:message Success:nil Fail:nil];
            }];

            
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithCompletion:^(OSMessage *message) {
                [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
            }];
            
            
        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithCompletion:^(OSMessage *message) {
                [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
            }];
            
        } break;
            
        default:
            break;
    }
}



- (void)talkToSupportThroughQQ {
    if (![OpenShare isQQInstalled]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
        return;
    }
    [OpenShare chatWithQQNumber:kSupportQQ];
}





@end
