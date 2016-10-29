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
#import "HHEvent.h"
#import "HHPersonalCoach.h"

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeQQ,
    ShareTypeWeibo,
    ShareTypeWeChat,
    ShareTypeWeChatTimeLine,
    ShareTypeQZone,
};

typedef void (^MessageCompletion) (OSMessage *message);
typedef void (^LinkCompletion) (NSString *link);

@interface HHSocialMediaShareUtility : NSObject

+ (instancetype)sharedInstance;


- (void)sharePersonalCoach:(HHPersonalCoach *)coach shareType:(ShareType)shareType;
- (void)shareCoach:(HHCoach *)coach shareType:(ShareType)shareType;
- (void)shareMyQRCode:(UIImage *)qrCode shareType:(ShareType)shareType;
- (void)shareEvent:(HHEvent *)event shareType:(ShareType)shareType;


@end
