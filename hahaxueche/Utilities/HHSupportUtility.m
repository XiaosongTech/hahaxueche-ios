//
//  HHOnlineSupportUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSupportUtility.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIImage+HHImage.h"
#import "UIColor+HHColor.h"
#import "HHStudentStore.h"

static NSString *const kSupportNumber = @"4000016006";

@interface HHSupportUtility ()

@property (nonatomic, strong) UINavigationController *navVC;

@end

@implementation HHSupportUtility

+ (HHSupportUtility *)sharedManager {
    static HHSupportUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHSupportUtility alloc] init];
    });
    
    return manager;
}


- (QYSessionViewController *)buildOnlineSupportVCInNavVC:(UINavigationController *)navVC {
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"哈哈学车";
    source.urlString = @"http://hahaxueche.com";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"哈哈学车在线客服";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    sessionViewController.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [HHSupportUtility sharedManager].navVC = navVC;
    
    //user info
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    HHStudent *student = [HHStudentStore sharedInstance].currentStudent;
    if (student.studentId) {
        userInfo.data = [NSString stringWithFormat:@"[{\"key\":\"real_name\", \"value\":\"%@\"},"
                         "{\"key\":\"mobile_phone\", \"value\":\"%@\"}]", student.name, student.cellPhone] ;
    }
    
    [[QYSDK sharedSDK] setUserInfo:userInfo];

    
    //cusom UI
    [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = NO;
    
    
    return sessionViewController;
}

- (void)dismissVC {
    [[HHSupportUtility sharedManager].navVC popViewControllerAnimated:YES];
}

- (void)callSupport {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",kSupportNumber]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}



@end
