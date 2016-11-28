//
//  HHSignContractViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSignContractViewController.h"
#import <WebKit/WebKit.h>
#import <BEMCheckBox/BEMCheckBox.h>
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHPopupUtility.h"
#import "HHReferFriendsViewController.h"
#import "HHConstantsStore.h"
#import "NSNumber+HHNumber.h"

@interface HHSignContractViewController () <WKUIDelegate, WKNavigationDelegate, BEMCheckBoxDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UILabel *botLabel;
@property (nonatomic, strong) KLCPopup *popup;

@end

@implementation HHSignContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学员电子协议";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
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
        __weak HHSignContractViewController *weakSelf = self;
        
        HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithTitle:@"推荐好友" info:[self buildPopupInfoTextWithString:[NSString stringWithFormat:@"恭喜您！协议签署成功! 可在\"我的页面\"-\"我的协议\"里面查看. \n现在分享给好友即有机会获得%@元返现！好友报名学车立减%@元！快去分享吧~", [[[HHConstantsStore sharedInstance] getCityReferrerBonus] generateMoneyString], [[[HHConstantsStore sharedInstance] getCityRefereeBonus] generateMoneyString]]]];
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
}

- (NSMutableAttributedString *)buildPopupInfoTextWithString:(NSString *)string {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 5.0f;
    return [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:style}];
}


@end
