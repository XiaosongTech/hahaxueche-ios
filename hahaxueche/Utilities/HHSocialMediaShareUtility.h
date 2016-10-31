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
#import "HHShareView.h"


typedef void (^MessageCompletion) (OSMessage *message);
typedef void (^LinkCompletion) (NSString *link);
typedef void (^ShareResultCompletion) (BOOL succceed);

@interface HHSocialMediaShareUtility : NSObject

+ (instancetype)sharedInstance;


- (void)sharePersonalCoach:(HHPersonalCoach *)coach shareType:(SocialMedia)shareType resultCompletion:(ShareResultCompletion)resultCompletion;
- (void)shareCoach:(HHCoach *)coach shareType:(SocialMedia)shareType resultCompletion:(ShareResultCompletion)resultCompletion;
- (void)shareMyQRCode:(UIImage *)qrCode shareType:(SocialMedia)shareType resultCompletion:(ShareResultCompletion)resultCompletion;
- (void)shareEvent:(HHEvent *)event shareType:(SocialMedia)shareType;


- (NSString *)getChannelNameWithType:(SocialMedia)type;

@end
