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
#import "HHLoadingViewUtility.h"
#import "HHStudentStore.h"
#import "HHToastManager.h"


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
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[HHStudentStore sharedInstance].currentStudent.agreementURL]]];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_contract_page_viewed attributes:nil];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showOptions {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"学员协议" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送到邮箱", nil];
    [sheet showInView:self.view];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_contract_page_top_right_button_tapped attributes:nil];
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showAlertControllerForEmailAgreement];
        
    }
}

- (void)showAlertControllerForEmailAgreement {
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_contract_page_send_by_email_tapped attributes:nil];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请确保输入正确的邮箱地址"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"确认"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   NSString *email = alertController.textFields.firstObject.text;
                                   NSString *confirmEmail = alertController.textFields.lastObject.text;
                                   if ([email isEqualToString:confirmEmail]) {
                                       if ([self validateEmailWithString:email]) {
                                           [self sendContractToEmail:email];
                                       } else {
                                           [[HHToastManager sharedManager] showErrorToastWithText:@"请输入有效的邮箱地址"];
                                           [self showAlertControllerForEmailAgreement];
                                       }
                                   } else {
                                       [[HHToastManager sharedManager] showErrorToastWithText:@"两次输入邮箱地址不一致"];
                                       [self showAlertControllerForEmailAgreement];
                                   }
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"您的邮箱";
        textField.returnKeyType = UIReturnKeyNext;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"邮箱确认";
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sendContractToEmail:(NSString *)email {
    
}

- (BOOL)validateEmailWithString:(NSString*)checkString{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [[HHLoadingViewUtility sharedInstance] showProgressView:self.webView.estimatedProgress];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        }
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
