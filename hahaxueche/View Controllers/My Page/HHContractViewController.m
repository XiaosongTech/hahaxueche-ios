//
//  HHContractViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHContractViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import <WebKit/WebKit.h>


@interface HHContractViewController () <WKUIDelegate, WKNavigationDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HHContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的协议";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_more"] action:@selector(showOptions) target:self];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor HHOrange];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showOptions {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"学员协议" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送到邮箱", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //send pdf to users email
    }
}


@end
