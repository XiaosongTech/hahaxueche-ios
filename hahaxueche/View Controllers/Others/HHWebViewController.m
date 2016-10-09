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

@implementation HHWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (instancetype)initWithEvent:(HHEvent *)event {
    self = [super init];
    if (self) {
        self.event = event;
        self.url = [NSURL URLWithString:event.webURL];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(backPage) target:self], [UIBarButtonItem buttonItemWithTitle:@"关闭" titleColor:[UIColor whiteColor] action:@selector(dismissVC) target:self isLeft:NO]];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.view addSubview:self.webView];
    
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    self.progress.webViewProxyDelegate = self;
    self.progress.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    if (self.event) {
         self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareEvent) target:self];
    }
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:NO];
}

- (void)shareEvent {
    __weak HHWebViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        switch (selecteItem) {
            case SocialMediaQQFriend: {
                [[HHSocialMediaShareUtility sharedInstance] shareEvent:weakSelf.event shareType:ShareTypeQQ];
            } break;
                
            case SocialMediaWeibo: {
                [[HHSocialMediaShareUtility sharedInstance] shareEvent:weakSelf.event shareType:ShareTypeWeibo];
            } break;
                
            case SocialMediaWeChatFriend: {
                [[HHSocialMediaShareUtility sharedInstance] shareEvent:weakSelf.event shareType:ShareTypeWeChat];
            } break;
                
            case SocialMediaWeChaPYQ: {
                [[HHSocialMediaShareUtility sharedInstance] shareEvent:weakSelf.event shareType:ShareTypeWeChatTimeLine];
            } break;
                
            case SocialMediaQZone: {
                [[HHSocialMediaShareUtility sharedInstance] shareEvent:weakSelf.event shareType:ShareTypeQZone];
            } break;
            default:
                break;
                
        }
    };
    weakSelf.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (void)backPage {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self dismissVC];
    }
}

@end
