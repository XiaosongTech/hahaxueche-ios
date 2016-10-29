//
//  HHSocialMediaShareUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSocialMediaShareUtility.h"
#import "HHToastManager.h"
#import "HHStudentStore.h"
#import "HHLoadingViewUtility.h"
#import "NSString+HHURL.h"
#import "HHStudentStore.h"


static NSString *const kStagingShareCoachBaseURL = @"http://staging-api.hahaxueche.net/share/coaches/%@";
static NSString *const kProdShareCoachBaseURL = @"http://api.hahaxueche.net/share/coaches/%@";

static NSString *const kStagingSharePersonalCoachBaseURL = @"http://staging-api.hahaxueche.net/share/training_partners/%@";
static NSString *const kProdSharePersonalCoachBaseURL = @"http://api.hahaxueche.net/share/training_partners/%@";


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
            [OpenShare shareToQQFriends:[self generateShareMessageWithCoach:coach shareType:shareType] Success:nil Fail:nil];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeibo:[self generateShareMessageWithCoach:coach shareType:shareType] Success:nil Fail:nil];
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
           [OpenShare shareToWeixinSession:[self generateShareMessageWithCoach:coach shareType:shareType] Success:nil Fail:nil];

        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
           [OpenShare shareToWeixinTimeline:[self generateShareMessageWithCoach:coach shareType:shareType] Success:nil Fail:nil];

        } break;
            
        case ShareTypeQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQZone:[self generateShareMessageWithCoach:coach shareType:shareType] Success:nil Fail:nil];
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
            
        case ShareTypeQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQZone:msg Success:nil Fail:nil];
            
            
        } break;
            
        default:
            break;
    }
}

- (OSMessage *)generateShareMessageWithCoach:(HHCoach *)coach shareType:(ShareType)shareType {
    NSString *baseURL = nil;
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
#ifdef DEBUG
    baseURL = kStagingShareCoachBaseURL;
#else
    baseURL = kProdShareCoachBaseURL;
    
#endif
    
    NSString *link = [NSString stringWithFormat:baseURL, coach.coachId];
    
    switch (shareType) {
        case ShareTypeQQ: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            msg.link = link;
        } break;
            
        case ShareTypeWeibo: {
            msg.title = [NSString stringWithFormat:@"墙裂推荐:哈哈学车优秀教练%@ %@", coach.name, link];
           
        } break;
            
        case ShareTypeWeChat: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            msg.link = link;
        } break;
            
        case ShareTypeWeChatTimeLine: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            msg.link = link;
            
        } break;
            
        case ShareTypeQZone: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            msg.link = link;

        } break;
        default:
            break;
    }
    return msg;

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
            
        case ShareTypeQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToQQZone:msg Success:nil Fail:nil];
        } break;
        default:
            break;
    }
}

- (void)sharePersonalCoach:(HHPersonalCoach *)coach shareType:(ShareType)shareType {
    switch (shareType) {
        case ShareTypeQQ: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQFriends:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:nil Fail:nil];
        } break;
            
        case ShareTypeWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeibo:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:nil Fail:nil];
        } break;
            
        case ShareTypeWeChat: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
           [OpenShare shareToWeixinSession:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:nil Fail:nil];
            
        } break;
            
        case ShareTypeWeChatTimeLine: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinTimeline:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:nil Fail:nil];
            
        } break;
            
        case ShareTypeQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQZone:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:nil Fail:nil];
        } break;
            
        default:
            break;
    }

}

- (OSMessage *)generateMessageWithPersonalCoach:(HHPersonalCoach *)coach shareType:(ShareType)shareType{
    NSString *baseURL = nil;
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
#ifdef DEBUG
    baseURL = kStagingSharePersonalCoachBaseURL;
#else
    baseURL = kProdSharePersonalCoachBaseURL;
#endif
    
    NSString *link = [NSString stringWithFormat:baseURL, coach.coachId];
    switch (shareType) {
        case ShareTypeQQ: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀陪练教练%@", coach.name];
            msg.link = link;
        } break;
            
        case ShareTypeWeibo: {
             msg.title = [NSString stringWithFormat:@"墙裂推荐:哈哈学车优秀陪练教练%@ %@", coach.name, link];
            
        } break;
            
        case ShareTypeWeChat: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀陪练教练%@", coach.name];
            msg.link = link;
        } break;
            
        case ShareTypeWeChatTimeLine: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀陪练教练%@", coach.name];
            msg.link = link;
            
        } break;
            
        case ShareTypeQZone: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀陪练教练%@", coach.name];
            msg.link = link;
            
        } break;
        default:
            break;
    }

    return msg;
}


@end
