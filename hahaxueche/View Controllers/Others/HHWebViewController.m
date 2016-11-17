//
//  HHWebViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 3/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHWebViewController.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHShareView.h"
#import "HHSocialMediaShareUtility.h"
#import "UIColor+HHColor.h"


@implementation HHWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(backPage) target:self], [UIBarButtonItem buttonItemWithTitle:@"关闭" titleColor:[UIColor whiteColor] action:@selector(dismissVC) target:self isLeft:NO]];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor HHOrange];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.view addSubview:self.webView];
    
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = [UIColor HHOrange];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.trackTintColor = [UIColor HHBackgroundGary];
    self.progressView.progress = 0;
    [self.webView addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.webView.left);
        make.top.equalTo(self.webView.top);
        make.width.equalTo(self.webView.width);
        make.height.mas_equalTo(2.0f);
    }];
    
    
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:nsrequest];
    
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)backPage {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self dismissVC];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    
    NSLog(@"4.%@",navigationAction.request);
    
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([url isEqualToString:@"hhxc://findcoach"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)dealloc {
    
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}


@end
