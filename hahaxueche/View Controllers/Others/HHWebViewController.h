//
//  HHWebViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 3/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIWebView *webView;

- (instancetype)initWithURL:(NSURL *)url;

@end
