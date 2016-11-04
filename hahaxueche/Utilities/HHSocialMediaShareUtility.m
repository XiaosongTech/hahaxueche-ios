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

- (void)shareCoach:(HHCoach *)coach shareType:(SocialMedia)shareType resultCompletion:(ShareResultCompletion)resultCompletion {
    switch (shareType) {
        case SocialMediaQQFriend: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQFriends:[self generateShareMessageWithCoach:coach shareType:shareType] Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            }];
        } break;
            
        case SocialMediaWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeibo:[self generateShareMessageWithCoach:coach shareType:shareType] Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
        } break;
            
        case SocialMediaWeChatFriend: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
           [OpenShare shareToWeixinSession:[self generateShareMessageWithCoach:coach shareType:shareType] Success:^(OSMessage *message) {
               if (resultCompletion) {
                   resultCompletion(YES);
               }
           } Fail:^(OSMessage *message, NSError *error) {
               if (resultCompletion) {
                   resultCompletion(NO);
               }
           } ];

        } break;
            
        case SocialMediaWeChaPYQ: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
           [OpenShare shareToWeixinTimeline:[self generateShareMessageWithCoach:coach shareType:shareType] Success:^(OSMessage *message) {
               if (resultCompletion) {
                   resultCompletion(YES);
               }
           } Fail:^(OSMessage *message, NSError *error) {
               if (resultCompletion) {
                   resultCompletion(NO);
               }
           } ];

        } break;
            
        case SocialMediaQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQZone:[self generateShareMessageWithCoach:coach shareType:shareType] Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
        } break;
            
        default:
            break;
    }
}


- (void)sharePost:(HHClubPost *)post shareType:(SocialMedia)shareType {
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    msg.title = post.title;
    msg.multimediaType = OSMultimediaTypeNews;
    msg.link = [post getShareUrl];;
    msg.desc = post.abstract;
    
    switch (shareType) {
        case SocialMediaQQFriend: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQFriends:msg Success:nil Fail:nil];
        } break;
            
        case SocialMediaWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeibo:msg Success:nil Fail:nil];
        } break;
            
        case SocialMediaWeChatFriend: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinSession:msg Success:nil Fail:nil];

            
        } break;
            
        case SocialMediaWeChaPYQ: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinTimeline:msg Success:nil Fail:nil];

            
        } break;
            
        case SocialMediaQZone: {
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

- (OSMessage *)generateShareMessageWithCoach:(HHCoach *)coach shareType:(SocialMedia)shareType {
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
        case SocialMediaQQFriend: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            msg.link = link;
        } break;
            
        case SocialMediaWeibo: {
            msg.title = [NSString stringWithFormat:@"墙裂推荐:哈哈学车优秀教练%@ %@", coach.name, link];
           
        } break;
            
        case SocialMediaWeChatFriend: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            msg.link = link;
        } break;
            
        case SocialMediaWeChaPYQ: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀教练%@", coach.name];
            msg.link = link;
            
        } break;
            
        case SocialMediaQZone: {
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



- (void)shareMyQRCode:(UIImage *)qrCode shareType:(SocialMedia)shareType resultCompletion:(ShareResultCompletion)resultCompletion {
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = qrCode;
    msg.title = @"";
    msg.desc = @"";
    
    switch (shareType) {
        case SocialMediaQQFriend: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            msg.thumbnail = qrCode;
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
        } break;
            
        case SocialMediaWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            msg.thumbnail = qrCode;
            [OpenShare shareToWeibo:msg Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
            
            
        } break;
            
        case SocialMediaWeChatFriend: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];

            
        } break;
            
        case SocialMediaWeChaPYQ: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
            
        } break;
            
        case SocialMediaQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
        } break;
        default:
            break;
    }
}

- (void)sharePersonalCoach:(HHPersonalCoach *)coach shareType:(SocialMedia)shareType resultCompletion:(ShareResultCompletion)resultCompletion {
    switch (shareType) {
        case SocialMediaQQFriend: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQFriends:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
        } break;
            
        case SocialMediaWeibo: {
            if (![OpenShare isWeiboInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                return;
            }
            
            [OpenShare shareToWeibo:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
        } break;
            
        case SocialMediaWeChatFriend: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
           [OpenShare shareToWeixinSession:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:^(OSMessage *message) {
               if (resultCompletion) {
                   resultCompletion(YES);
               }
           } Fail:^(OSMessage *message, NSError *error) {
               if (resultCompletion) {
                   resultCompletion(NO);
               }
           } ];
            
        } break;
            
        case SocialMediaWeChaPYQ: {
            if (![OpenShare isWeixinInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                return;
            }
            [OpenShare shareToWeixinTimeline:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
            
        } break;
            
        case SocialMediaQZone: {
            if (![OpenShare isQQInstalled]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                return;
            }
            [OpenShare shareToQQZone:[self generateMessageWithPersonalCoach:coach shareType:shareType] Success:^(OSMessage *message) {
                if (resultCompletion) {
                    resultCompletion(YES);
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (resultCompletion) {
                    resultCompletion(NO);
                }
            } ];
        } break;
            
        default:
            break;
    }

}

- (OSMessage *)generateMessageWithPersonalCoach:(HHPersonalCoach *)coach shareType:(SocialMedia)shareType{
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
        case SocialMediaQQFriend: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀陪练教练%@", coach.name];
            msg.link = link;
        } break;
            
        case SocialMediaWeibo: {
             msg.title = [NSString stringWithFormat:@"墙裂推荐:哈哈学车优秀陪练教练%@ %@", coach.name, link];
            
        } break;
            
        case SocialMediaWeChatFriend: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = @"哈哈学车-选驾校, 挑教练, 上哈哈学车~";
            msg.desc = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀陪练教练%@", coach.name];
            msg.link = link;
        } break;
            
        case SocialMediaWeChaPYQ: {
            msg.multimediaType = OSMultimediaTypeNews;
            msg.title = [NSString stringWithFormat:@"墙裂推荐:\n哈哈学车优秀陪练教练%@", coach.name];
            msg.link = link;
            
        } break;
            
        case SocialMediaQZone: {
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

- (NSString *)getChannelNameWithType:(SocialMedia)type {
    switch (type) {
        case SocialMediaQQFriend:
            return @"QQ_friend";
        case SocialMediaWeibo:
            return @"weibo";
            
        case SocialMediaWeChatFriend:
            return @"wechat_friend";
            
        case SocialMediaWeChaPYQ:
            return @"wechat_friend_zone";
            
        case SocialMediaQZone:
            return @"qzone";
        default:
            return nil;

    }
}


@end
