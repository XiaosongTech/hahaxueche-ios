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
#import "HHStudentService.h"
#import "HHLoadingViewUtility.h"

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
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = 10.0f;
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(backPage) target:self], fixedItem, closeItem];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareWebPage) target:self];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-130.0f, 40.0f)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLabel;
    
    
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
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.titleLabel.text = self.webView.title;
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
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
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([url isEqualToString:@"hhxc://findcoach"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    } else if ([url isEqualToString:@"https://lkme.cc/RnC/weMAYR8c8"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)shareWebPage {
    __weak HHWebViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        __block NSString *finalURLString = weakSelf.url.absoluteString;
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:weakSelf.url resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *promoCode = [self valueForKey:@"promo_code" fromQueryItems:queryItems];
        NSString *channelName;
        if (promoCode) {
            if (selecteItem == SocialMediaQZone || selecteItem == SocialMediaQQFriend) {
                channelName = @"QQ";
            } else if (selecteItem == SocialMediaWeChaPYQ || selecteItem == SocialMediaWeChatFriend) {
                channelName = @"微信";
            } else if (selecteItem == SocialMediaWeibo) {
                channelName = @"微博";
            } else {
                channelName = @"短信";
            }
        }
        
        if (promoCode && channelName) {
            [[HHLoadingViewUtility sharedInstance] showLoadingView];
            [[HHStudentService sharedInstance] getMarketingChannelCodeWithCode:promoCode channelName:channelName completion:^(NSString *code) {
                if (code) {
                    finalURLString = [finalURLString stringByReplacingOccurrencesOfString:promoCode withString:code];
                }
                if (selecteItem == SocialMediaMessage) {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                }
                [[HHSocialMediaShareUtility sharedInstance] shareWebPage:[NSURL URLWithString:finalURLString] title:weakSelf.titleLabel.text shareType:selecteItem inVC:weakSelf resultCompletion:nil];
            }];
        } else {
            if (selecteItem == SocialMediaMessage) {
                [HHPopupUtility dismissPopup:weakSelf.popup];
            }
            [[HHSocialMediaShareUtility sharedInstance] shareWebPage:[NSURL URLWithString:finalURLString] title:weakSelf.titleLabel.text shareType:selecteItem inVC:weakSelf resultCompletion:nil];
        }

    };
    
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
    return queryItem.value;
}

- (void)dealloc {

    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}


@end
