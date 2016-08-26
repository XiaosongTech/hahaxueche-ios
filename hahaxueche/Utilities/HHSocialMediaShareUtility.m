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

static NSString *const kStagingReferalBaseURL = @"http://staging-api.hahaxueche.net/share/invitations?target=%@&city_id=%@";
static NSString *const kProdReferalBaseURL = @"http://api.hahaxueche.net/share/invitations?target=%@&city_id=%@";

static NSString *const kStagingShareCoachBaseURL = @"http://staging-api.hahaxueche.net/share/coaches/%@?target=%@";
static NSString *const kProdShareCoachBaseURL = @"http://api.hahaxueche.net/share/coaches/%@?target=%@";


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
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach shareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToQQFriends:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach shareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToWeibo:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach shareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
            }];

        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateShareMessageWithCoach:coach shareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
            }];

        } break;
            
        default:
            break;
    }
}


- (void)shareEvent:(HHEvent *)event shareType:(ShareType)shareType {
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    msg.title = event.title;
    msg.multimediaType = OSMultimediaTypeNews;
    msg.link = event.webURL;
    msg.desc = @"限时活动, 疯抢中!";
    
    switch (shareType) {
        case ShareTypeQQ: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQFriends:msg Success:nil Fail:nil];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeibo:msg Success:nil Fail:nil];
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinSession:msg Success:nil Fail:nil];

            
        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinTimeline:msg Success:nil Fail:nil];

            
        } break;
            
        default:
            break;
    }
}

- (void)generateShareMessageWithCoach:(HHCoach *)coach shareType:(ShareType)shareType completion:(MessageCompletion)completion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    NSString *baseURL = nil;
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
#ifdef DEBUG
    baseURL = kStagingShareCoachBaseURL;
#else
    baseURL = kProdShareCoachBaseURL;
    
#endif
    
    
    switch (shareType) {
        case ShareTypeQQ: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-开启快乐学车之旅吧~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            [HHSocialMediaShareUtility generateBranchLink:coach completion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.link = [NSString stringWithFormat:baseURL, coach.coachId, [url urlEncode]];
                if (completion) {
                    completion(msg);
                }
            }];
        } break;
            
        case ShareTypeWeibo: {
            [HHSocialMediaShareUtility generateBranchLink:coach completion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.title = [NSString stringWithFormat:@"墙裂推荐:哈哈学车优秀教练%@ %@", coach.name, [NSString stringWithFormat:baseURL, coach.coachId, [url urlEncode]]];
                if (completion) {
                    completion(msg);
                }
            }];
           
        } break;
            
        case ShareTypeWeChat: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-开启快乐学车之旅吧~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            [HHSocialMediaShareUtility generateBranchLink:coach completion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.link = [NSString stringWithFormat:baseURL, coach.coachId, [url urlEncode]];
                if (completion) {
                    completion(msg);
                }
            }];
        } break;
            
        case ShareTypeWeChatTimeLine: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            [HHSocialMediaShareUtility generateBranchLink:coach completion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.link = [NSString stringWithFormat:baseURL, coach.coachId, [url urlEncode]];
                if (completion) {
                    completion(msg);
                }
            }];

            
        } break;
            
        default:
            break;
    }

}

- (void)generateUserReferLinkWithShareType:(ShareType)shareType completion:(MessageCompletion)completion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    NSString *baseURL = nil;
    
#ifdef DEBUG
    baseURL = kStagingReferalBaseURL;
#else
    baseURL = kProdReferalBaseURL;
    
#endif

    
    switch (shareType) {
        case ShareTypeQQ: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"墙裂推荐:哈哈学车";
            msg.desc = @"注册立享50元优惠";
            [[HHSocialMediaShareUtility sharedInstance] generateBranchLinkForUserReferWithCompletion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.link = [NSString stringWithFormat:baseURL, [url urlEncode], [[HHStudentStore sharedInstance].currentStudent.cityId stringValue]];
                if (completion) {
                    completion(msg);
                }
            }];
            
        } break;
            
        case ShareTypeWeibo: {
            [[HHSocialMediaShareUtility sharedInstance] generateBranchLinkForUserReferWithCompletion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.title = [NSString stringWithFormat:@"墙裂推荐:哈哈学车 注册立享50元优惠 %@", [NSString stringWithFormat:baseURL, [url urlEncode], [[HHStudentStore sharedInstance].currentStudent.cityId stringValue]]];
                if (completion) {
                    completion(msg);
                }
            }];
        } break;
            
        case ShareTypeWeChat: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"墙裂推荐:哈哈学车";
            msg.desc = @"注册立享50元优惠";
            [[HHSocialMediaShareUtility sharedInstance] generateBranchLinkForUserReferWithCompletion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.link = [NSString stringWithFormat:baseURL, [url urlEncode], [[HHStudentStore sharedInstance].currentStudent.cityId stringValue]];
                if (completion) {
                    completion(msg);
                }
            }];
        } break;
            
        case ShareTypeWeChatTimeLine: {
            [[HHSocialMediaShareUtility sharedInstance] generateBranchLinkForUserReferWithCompletion:^(NSString *url, NSError *error) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                msg.title = [NSString stringWithFormat:@"墙裂推荐:哈哈学车 注册立享50元优惠"];
                msg.link = [NSString stringWithFormat:baseURL, [url urlEncode], [[HHStudentStore sharedInstance].currentStudent.cityId stringValue]];
                if (completion) {
                    completion(msg);
                }
            }];
        } break;
            
        default:
            break;
    }
}

- (void)generateBranchLinkForUserReferWithCompletion:(callbackWithUrl)completion {
    
    if ([HHSocialMediaShareUtility sharedInstance].userReferBranchLink) {
        if (completion) {
            completion([HHSocialMediaShareUtility sharedInstance].userReferBranchLink, nil);
            return;
        }
    }
    
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
            
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithShareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToQQFriends:message Success:nil Fail:nil];
            }];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithShareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToWeibo:message Success:nil Fail:nil];
            }];

            
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithShareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
            }];
            
            
        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            
            [[HHSocialMediaShareUtility sharedInstance] generateUserReferLinkWithShareType:shareType completion:^(OSMessage *message) {
                [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
            }];
            
        } break;
            
        default:
            break;
    }
}

- (void)shareMyQRCode:(UIImage *)qrCode shareType:(ShareType)shareType {
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = qrCode;
    msg.title = @"";
    msg.desc = @"";
    
    switch (shareType) {
        case ShareTypeQQ: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            msg.thumbnail = qrCode;
            [OpenShare shareToQQFriends:msg Success:nil Fail:nil];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            msg.thumbnail = qrCode;
            [OpenShare shareToWeibo:msg Success:nil Fail:nil];
            
            
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinSession:msg Success:nil Fail:nil];

            
        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeixinTimeline:msg Success:nil Fail:nil];
            
        } break;
            
        default:
            break;
    }
}


- (void)getUserReferLinkWithCompletion:(LinkCompletion)completion {
    
    NSString *baseURL = nil;
    
#ifdef DEBUG
    baseURL = kStagingReferalBaseURL;
#else
    baseURL = kProdReferalBaseURL;
    
#endif
    
    [[HHSocialMediaShareUtility sharedInstance] generateBranchLinkForUserReferWithCompletion:^(NSString *url, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (completion) {
            completion([NSString stringWithFormat:baseURL, [url urlEncode], [[HHStudentStore sharedInstance].currentStudent.cityId stringValue]]);
        }
    }];
}

@end
