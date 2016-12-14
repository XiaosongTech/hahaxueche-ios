//
//  HHSignContractViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSignContractViewController.h"
#import <BEMCheckBox/BEMCheckBox.h>
#import <WebKit/WebKit.h>
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHPopupUtility.h"
#import "HHReferFriendsViewController.h"
#import "HHConstantsStore.h"
#import "NSNumber+HHNumber.h"
#import "HHStudentStore.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentService.h"
#import "HHToastManager.h"

@interface HHSignContractViewController () <BEMCheckBoxDelegate, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UILabel *botLabel;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) NSURL *agreementURL;

@end

@implementation HHSignContractViewController

- (instancetype)initWithURL:(NSURL *)agreementURL {
    self = [super init];
    if (self) {
        self.agreementURL = agreementURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学员电子协议";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    if (self.agreementURL) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.agreementURL]];
    } else {
        [[HHStudentService sharedInstance] getAgreementURLWithCompletion:^(NSURL *url) {
            if (url) {
                self.agreementURL = url;
                [self.webView loadRequest:[NSURLRequest requestWithURL:self.agreementURL]];
            }
        }];
    }
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:sign_contract_page_viewed attributes:nil];
}

- (void)initSubviews {
    self.webView = [[WKWebView alloc] init];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor HHOrange];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-50.0f);
    }];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor HHBackgroundGary];
    [self.view addSubview:self.botView];
    [self.botView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    self.checkBox = [[BEMCheckBox alloc] init];
    self.checkBox.on = NO;
    self.checkBox.delegate = self;
    self.checkBox.boxType = BEMBoxTypeSquare;
    self.checkBox.onAnimationType = BEMAnimationTypeBounce;
    self.checkBox.offAnimationType = BEMAnimationTypeBounce;
    self.checkBox.onCheckColor = [UIColor whiteColor];
    self.checkBox.onTintColor = [UIColor HHOrange];
    self.checkBox.onFillColor = [UIColor HHOrange];
    self.checkBox.lineWidth = 1.0f;
    [self.botView addSubview:self.checkBox];
    [self.checkBox makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.left).offset(15.0f);
        make.centerY.equalTo(self.botView.centerY);
        make.width.mas_equalTo(20.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    self.botLabel = [[UILabel alloc] init];
    self.botLabel.text = @"我认真阅读理解并同意以上条款";
    self.botLabel.numberOfLines = 0;
    self.botLabel.textColor = [UIColor HHLightTextGray];
    self.botLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.botView addSubview:self.botLabel];
    [self.botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkBox.right).offset(10.0f);
        make.centerY.equalTo(self.botView.centerY);
        make.right.equalTo(self.botView.right).offset(-20.0f);
    }];
}

- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    if (checkBox.on) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHStudentService sharedInstance] signAgreementWithCompletion:^(HHStudent *student, NSError *error) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (!error) {
                [HHStudentStore sharedInstance].currentStudent = student;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"studentUpdated" object:nil];
                [self showSharePopup];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"签署失败, 请重试"];
            }
        }];
        
        
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:sign_contract_check_box_checked attributes:nil];
    }
}

- (void)showSharePopup {
    __weak HHSignContractViewController *weakSelf = self;
    HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithTitle:@"推荐好友" info:[self buildPopupInfoTextWithString:[NSString stringWithFormat:@"恭喜您！协议签署成功! 可在\"我的页面\"-\"我的协议\"里面查看. \n现在分享<学车大礼包>给好友吧, 好友报名学车立减%@元, 还有科一保过卡！",[[[HHConstantsStore sharedInstance] getCityRefereeBonus] generateMoneyString]]]];
    [view.buttonView.okButton setTitle:@"分享得现金" forState:UIControlStateNormal];
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
        HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
        [weakSelf.navigationController setViewControllers:@[vc] animated:YES];
    };
    weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
    weakSelf.popup.shouldDismissOnContentTouch = NO;
    weakSelf.popup.shouldDismissOnBackgroundTouch = NO;
    [HHPopupUtility showPopup:weakSelf.popup];

}

- (NSMutableAttributedString *)buildPopupInfoTextWithString:(NSString *)string {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 5.0f;
    return [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:style}];
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
