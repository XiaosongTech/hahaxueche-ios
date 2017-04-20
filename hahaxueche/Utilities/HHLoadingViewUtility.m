//
//  HHLoadingViewUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/4/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHLoadingViewUtility.h"
#import "UIColor+HHColor.h"

@implementation HHLoadingViewUtility

+ (HHLoadingViewUtility *)sharedInstance {
    static HHLoadingViewUtility *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHLoadingViewUtility alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultStyle: SVProgressHUDStyleCustom];
        [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
        [SVProgressHUD setForegroundColor:[UIColor darkTextColor]];
    }
    return self;
}

- (void)showLoadingView {
    [self showLoadingViewWithText:@"选驾校, 挑教练"];
}

- (void)showLoadingViewWithText:(NSString *)text {
    [SVProgressHUD showWithStatus:text];
}

- (void)dismissLoadingView {
    [SVProgressHUD dismiss];
}

- (BOOL)isVisible {
    return [SVProgressHUD isVisible];
}

- (void)showProgressView:(float)progress {
    [SVProgressHUD showProgress:progress status:@"为学员保驾护航!"];
}

@end
