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
#import "HHFormatUtility.h"
#import <MessageUI/MessageUI.h>
#import "HHToastManager.h"
#import "HHStudentStore.h"
#import "HHQRCodeUtility.h"
#import "HHURLUtility.h"
#import "UIImage+HHImage.h"
#import "HHStudentService.h"


static NSString *const kStagingShareCoachBaseURL = @"https://staging-api.hahaxueche.net/share/coaches/%@";
static NSString *const kProdShareCoachBaseURL = @"https://api.hahaxueche.net/share/coaches/%@";

static NSString *const kStagingSharePersonalCoachBaseURL = @"https://staging-api.hahaxueche.net/share/training_partners/%@";
static NSString *const kProdSharePersonalCoachBaseURL = @"https://api.hahaxueche.net/share/training_partners/%@";


static NSString *const kSupportQQ = @"3319762526";

@interface HHSocialMediaShareUtility () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIViewController *containerVC;

@end

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

- (void)shareCoach:(HHCoach *)coach shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    self.containerVC = inVC;
    [self generateShareMessageWithCoach:coach shareType:shareType completion:^(OSMessage *message) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        switch (shareType) {
            case SocialMediaQQFriend: {
                if (![OpenShare isQQInstalled]) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                    return;
                }
                [OpenShare shareToQQFriends:message Success:^(OSMessage *message) {
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
                [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
                    if (resultCompletion) {
                        resultCompletion(YES);
                    }
                } Fail:^(OSMessage *message, NSError *error) {
                    if (resultCompletion) {
                        resultCompletion(NO);
                    }
                }];
                
            } break;
                
            case SocialMediaWeChatFriend: {
                if (![OpenShare isWeixinInstalled]) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                    return;
                }
                [OpenShare shareToWeixinSession:message Success:^(OSMessage *message) {
                    if (resultCompletion) {
                        resultCompletion(YES);
                    }
                } Fail:^(OSMessage *message, NSError *error) {
                    if (resultCompletion) {
                        resultCompletion(NO);
                    }
                }];
                
            } break;
                
            case SocialMediaWeChaPYQ: {
                if (![OpenShare isWeixinInstalled]) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                    return;
                }
                [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
                    if (resultCompletion) {
                        resultCompletion(YES);
                    }
                } Fail:^(OSMessage *message, NSError *error) {
                    if (resultCompletion) {
                        resultCompletion(NO);
                    }
                }];
                
            } break;
                
            case SocialMediaQZone: {
                if (![OpenShare isQQInstalled]) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                    return;
                }
                [OpenShare shareToQQZone:message Success:^(OSMessage *message) {
                    if (resultCompletion) {
                        resultCompletion(YES);
                    }
                } Fail:^(OSMessage *message, NSError *error) {
                    if (resultCompletion) {
                        resultCompletion(NO);
                    }
                }];
            } break;
                
            case SocialMediaMessage:
                [self showSMS:message.title attachment:nil];
                break;
                
            default:
                break;
        }
        
    }];
}


- (void)sharePost:(HHClubPost *)post shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    msg.title = post.title;
    msg.multimediaType = OSMultimediaTypeNews;
    msg.desc = post.abstract;
    
    self.containerVC = inVC;
    
    NSString *link = [post getShareUrl];
    [[HHURLUtility sharedManager] generateShortURLWithOriginalURL:link completion:^(NSString *shortURL) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        msg.link = shortURL;
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
                msg.title = [NSString stringWithFormat:@"%@%@", post.title, shortURL];
                msg.image = [UIImage imageNamed:@"viewfile"];
                msg.link = nil;
                msg.desc = nil;
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
                
            case SocialMediaMessage: {
                [self showSMS:[NSString stringWithFormat:@"%@%@", post.title, shortURL] attachment:nil];
            } break;
                
            default:
                break;
        }
    }];
    
}

- (void)generateShareMessageWithCoach:(HHCoach *)coach shareType:(SocialMedia)shareType completion:(MessageCompletion)completion {
    NSString *baseURL = nil;
    __block OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    msg.multimediaType = OSMultimediaTypeNews;
    msg.title = @"不知道哪里学车靠谱？悄悄告诉你一个特别靠谱的教练，学过的都说好！";
    msg.desc = @"优秀教练给你保驾护航，学车一点儿都不难！";
#ifdef DEBUG
    baseURL = kStagingShareCoachBaseURL;
#else
    baseURL = kProdShareCoachBaseURL;
    
#endif
    
    NSString *link = [NSString stringWithFormat:baseURL, coach.coachId];
    [[HHURLUtility sharedManager] generateShortURLWithOriginalURL:link completion:^(NSString *shortURL) {
        switch (shareType) {
            case SocialMediaQQFriend: {
                msg.link = shortURL;
            } break;
                
            case SocialMediaWeibo: {
                msg = [[OSMessage alloc] init];
                msg.title = [NSString stringWithFormat:@"不知道哪里学车靠谱？悄悄告诉你一个特别靠谱的教练，学过的都说好！优秀教练给你保驾护航，学车一点儿都不难！%@", shortURL];
                msg.image = [UIImage imageNamed:@"viewfile"];
                
            } break;
                
            case SocialMediaWeChatFriend: {
                msg.link = shortURL;
            } break;
                
            case SocialMediaWeChaPYQ: {
                msg.link = shortURL;
                
            } break;
                
            case SocialMediaQZone: {
                msg.link = shortURL;
                
            } break;
                
            case SocialMediaMessage: {
                msg.title = [NSString stringWithFormat:@"不知道哪里学车靠谱？悄悄告诉你一个特别靠谱的教练，学过的都说好！优秀教练给你保驾护航，学车一点儿都不难！%@", shortURL];
            } break;
                
            default:
                break;
        }
        
        if (completion) {
            completion(msg);
        }
    }];
}



- (void)shareMyReferPageWithShareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    self.containerVC = inVC;
    __block OSMessage *msg = [[OSMessage alloc] init];
    msg.title = @"送你￥200元学车券，怕你考不过，再送你一张保过卡。比心❤️";
    msg.desc = @"Hi~朋友，知道你最近想学车，我把我学车的地方告诉你了，要一把考过哟！";
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    
    NSString *channelName;
    NSString *promoCode;
    
#ifdef DEBUG
    promoCode = @"625240";
#else
    promoCode = @"215362";
#endif
    
    __block NSString *finalURLString = [NSString stringWithFormat:@"https://m.hahaxueche.com/share/xin-ren-da-li-bao?referrer_id=%@&promo_code=%@", [HHStudentStore sharedInstance].currentStudent.userIdentityId, promoCode];
    
    if (shareType == SocialMediaQZone || shareType == SocialMediaQQFriend) {
        channelName = @"QQ";
    } else if (shareType == SocialMediaWeChaPYQ || shareType == SocialMediaWeChatFriend) {
        channelName = @"微信";
    } else if (shareType == SocialMediaWeibo) {
        channelName = @"微博";
    } else {
        channelName = @"短信";
    }
    [[HHStudentService sharedInstance] getMarketingChannelCodeWithCode:promoCode channelName:channelName completion:^(NSString *code) {
        if (code) {
            finalURLString = [finalURLString stringByReplacingOccurrencesOfString:promoCode withString:code];
        }
        
        [[HHURLUtility sharedManager] generateShortURLWithOriginalURL:finalURLString completion:^(NSString *shortURL) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            msg.link = shortURL;
            switch (shareType) {
                case SocialMediaQQFriend: {
                    if (![OpenShare isQQInstalled]) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                        return;
                    }
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
                    msg = [[OSMessage alloc] init];
                    msg.title = [NSString stringWithFormat:@"Hi, 知道你想学车, 送你200元代金券, 怕你考不过, 再送你一张保过卡. 比心❤️ %@", shortURL];
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
                    
                    msg.title = @"Hi~朋友，知道你最近想学车，我把我学车的地方告诉你了，要一把考过哟！";
                    
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
                    
                case SocialMediaMessage: {
                    [self showSMS:[NSString stringWithFormat:@"Hi, 知道你想学车, 送你200元代金券, 怕你考不过, 再送你一张保过卡. 比心❤️ %@", shortURL] attachment:nil];
                }
                default:
                    break;
            }
        }];
    }];
    
}

- (void)sharePersonalCoach:(HHPersonalCoach *)coach shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion {
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    self.containerVC = inVC;
    
    [self generateMessageWithPersonalCoach:coach shareType:shareType completion:^(OSMessage *message) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (message) {
            switch (shareType) {
                case SocialMediaQQFriend: {
                    if (![OpenShare isQQInstalled]) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                        return;
                    }
                    [OpenShare shareToQQFriends:message Success:nil Fail:nil];
                } break;
                    
                case SocialMediaWeibo: {
                    if (![OpenShare isWeiboInstalled]) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微博应用, 然后重试"];
                        return;
                    }
            
                    [OpenShare shareToWeibo:message Success:nil Fail:nil];
                } break;
                    
                case SocialMediaWeChatFriend: {
                    if (![OpenShare isWeixinInstalled]) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                        return;
                    }
                    [OpenShare shareToWeixinSession:message Success:nil Fail:nil];
                    
                } break;
                    
                case SocialMediaWeChaPYQ: {
                    if (![OpenShare isWeixinInstalled]) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机微信应用, 然后重试"];
                        return;
                    }
                    [OpenShare shareToWeixinTimeline:message Success:nil Fail:nil];
                    
                } break;
                    
                case SocialMediaQZone: {
                    if (![OpenShare isQQInstalled]) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"请先安装手机QQ应用, 然后重试"];
                        return;
                    }
                    [OpenShare shareToQQZone:message Success:nil Fail:nil];
                    
                } break;
                    
                case SocialMediaMessage: {
                    [self showSMS:message.title attachment:nil];
                } break;
                    
                default:
                    break;
            }
        }
    }];
}

- (void)generateMessageWithPersonalCoach:(HHPersonalCoach *)coach shareType:(SocialMedia)shareType completion:(MessageCompletion)completion {
    NSString *baseURL = nil;
    __block OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    msg.multimediaType = OSMultimediaTypeNews;
    msg.title = @"学车拿证后不敢上路？看哪呢？说的就是你！";
    msg.desc = @"推荐一个陪练教练老司机，秋名山车神就是你！";
#ifdef DEBUG
    baseURL = kStagingSharePersonalCoachBaseURL;
#else
    baseURL = kProdSharePersonalCoachBaseURL;
#endif
    
    NSString *link = [NSString stringWithFormat:baseURL, coach.coachId];
    [[HHURLUtility sharedManager] generateShortURLWithOriginalURL:link completion:^(NSString *shortURL) {
        switch (shareType) {
            case SocialMediaQQFriend: {
                msg.link = shortURL;
            } break;
                
            case SocialMediaWeibo: {
                msg = [[OSMessage alloc] init];
                msg.title = [NSString stringWithFormat:@"学车拿证后不敢上路？看哪呢？说的就是你！推荐一个陪练教练老司机，秋名山车神就是你！%@", shortURL];
                msg.image = [UIImage imageNamed:@"viewfile"];
                
            } break;
                
            case SocialMediaWeChatFriend: {
                msg.link = shortURL;
            } break;
                
            case SocialMediaWeChaPYQ: {
                msg.link = shortURL;
                
            } break;
                
            case SocialMediaQZone: {
                msg.link = shortURL;
                
            } break;
                
            case SocialMediaMessage: {
                msg.title = [NSString stringWithFormat:@"学车拿证后不敢上路？看哪呢？说的就是你！推荐一个陪练教练老司机，秋名山车神就是你！%@", shortURL];
            } break;
            default:
                break;
        }
        if (completion) {
            completion(msg);
        }
    }];
    
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
        case SocialMediaMessage:
            return @"短信";
        default:
            return nil;

    }
}


- (void)shareTestScoreWithType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    self.containerVC = inVC;
    
    NSString *urlString;
    
#ifdef DEBUG
    urlString = [NSString stringWithFormat:@"https://staging-api.hahaxueche.net/share/students/%@/exam_result", [HHStudentStore sharedInstance].currentStudent.studentId];
#else
    urlString = [NSString stringWithFormat:@"https://api.hahaxueche.net/share/students/%@/exam_result", [HHStudentStore sharedInstance].currentStudent.studentId];
#endif
    
    OSMessage *msg = [[OSMessage alloc] init];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    msg.title = @"";
    msg.desc = @"";
    msg.image = [UIImage imageWithImage:[UIImage imageWithData:data] scaledToWidth:500.0f];
    [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
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
            
        case SocialMediaMessage: {
            [self showSMS:@"" attachment:data];
        } break;
            
        default:
            break;
    }

}


- (void)showSMS:(NSString *)body attachment:(NSData *)attachment {
    
    if(![MFMessageComposeViewController canSendText]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"抱歉, 您的设备不支持短信发送"];
        return;
    }
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:nil];
    [messageController setBody:body];
    if (attachment) {
        [messageController addAttachmentData:attachment typeIdentifier:@"public.data" filename:@"哈哈学车.png"];
    }
    if (self.containerVC) {
        [self.containerVC presentViewController:messageController animated:YES completion:^{
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        }];
    }
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed: {
            [[HHToastManager sharedManager] showErrorToastWithText:@"发送失败, 请重试!"];
            break;
        }
            
        case MessageComposeResultSent:
            [[HHToastManager sharedManager] showSuccessToastWithText:@"发送成功!"];

            break;
            
        default:
            break;
    }
    
    if (self.containerVC) {
        [self.containerVC dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (UIImage *)generateReferQRCode:(BOOL)refer {
    NSString *string = [NSString stringWithFormat:@"https://m.hahaxueche.com/share/xin-ren-da-li-bao?referrer_id=%@&promo_code=215362", [HHStudentStore sharedInstance].currentStudent.userIdentityId];
    if (!refer) {
        string = @"https://m.hahaxueche.com/share/xin-ren-da-li-bao?promo_code=215362";
    }
    return [[HHQRCodeUtility sharedManager] generateQRCodeWithString:string];
}


- (void)shareWebPage:(NSURL *)url title:(NSString *)title shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    self.containerVC = inVC;
    OSMessage *msg = [[OSMessage alloc] init];
    msg.image = [UIImage imageNamed:@"ic_share"];
    msg.thumbnail = [UIImage imageNamed:@"ic_share"];
    msg.title = title;
    msg.multimediaType = OSMultimediaTypeNews;
    msg.desc = msg.title;
    [[HHURLUtility sharedManager] generateShortURLWithOriginalURL:url.absoluteString completion:^(NSString *shortURL) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        msg.link = shortURL;
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
                msg.title = [NSString stringWithFormat:@"%@%@", msg.title, shortURL];
                msg.image = [UIImage imageNamed:@"viewfile"];
                msg.link = nil;
                msg.desc = nil;
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
                
            case SocialMediaMessage: {
                [self showSMS:[NSString stringWithFormat:@"%@%@", msg.title, shortURL] attachment:nil];
            } break;
                
            default:
                break;
        }
    }];
}


@end
