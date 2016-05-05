//
//  HHLoadingViewUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/4/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHLoadingViewUtility.h"

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
    }
    return self;
}

- (void)showLoadingView {
    [self showLoadingViewWithText:@"加载中"];
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

@end
