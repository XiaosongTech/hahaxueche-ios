//
//  HHLoadingViewUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHLoadingView.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface HHLoadingView()

@property (nonatomic, strong)MBProgressHUD *hud;

@end

@implementation HHLoadingView

+ (HHLoadingView *)sharedInstance {
    static HHLoadingView *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHLoadingView alloc] init];
    });
    
    return sharedInstance;
}

- (void)showLoadingViewWithTilte:(NSString *)title {
    UIWindow *currentWindow = [[UIApplication sharedApplication] keyWindow];
    self.hud = [[MBProgressHUD alloc] initWithView:currentWindow];
    [currentWindow addSubview:self.hud];
    self.hud.labelText = NSLocalizedString(@"请稍等...",nil);
    if (title) {
        self.hud.labelText = title;
    }
    [self.hud show:YES];
}

- (void)hideLoadingView {
    [self.hud hide:YES];
}

- (void)changeTitle:(NSString *)title {
    self.hud.labelText = title;
}

@end
