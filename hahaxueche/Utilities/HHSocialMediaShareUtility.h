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
#import "HHClubPost.h"
#import "HHTestScore.h"


typedef void (^MessageCompletion) (OSMessage *message);
typedef void (^LinkCompletion) (NSString *link);
typedef void (^ShareResultCompletion) (BOOL succceed);

@interface HHSocialMediaShareUtility : NSObject

+ (instancetype)sharedInstance;


- (void)sharePersonalCoach:(HHPersonalCoach *)coach shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion;
- (void)shareCoach:(HHCoach *)coach shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion;
- (void)shareMyReferPageWithShareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion;
- (void)sharePost:(HHClubPost *)post shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC;
- (void)shareTestScoreWithType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion;

- (void)shareWebPage:(NSURL *)url title:(NSString *)title shareType:(SocialMedia)shareType inVC:(UIViewController *)inVC resultCompletion:(ShareResultCompletion)resultCompletion;
- (void)showSMS:(NSString *)body receiver:(NSArray *)receiver attachment:(NSData *)attachment inVC:(UIViewController *)inVC;


- (NSString *)getChannelNameWithType:(SocialMedia)type;
- (UIImage *)generateReferQRCode:(BOOL)refer;

@end
