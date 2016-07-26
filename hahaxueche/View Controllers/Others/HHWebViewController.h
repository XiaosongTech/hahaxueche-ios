//
//  HHWebViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 3/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "HHEvent.h"
#import "HHPopupUtility.h"

@interface HHWebViewController : UIViewController <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) HHEvent *event;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgress *progress;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) KLCPopup *popup;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithEvent:(HHEvent *)event;

@end
