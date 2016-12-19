//
//  HHWebViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 3/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPopupUtility.h"
#import <WebKit/WebKit.h>
#import "HHShareView.h"

@interface HHWebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHShareView *shareView;

- (instancetype)initWithURL:(NSURL *)url;

@end
