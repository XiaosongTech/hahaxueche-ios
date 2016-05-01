//
//  HHReferFriendsViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferFriendsViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHButton.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "NSNumber+HHNumber.h"
#import "HHPopupUtility.h"
#import "HHShareUserLinkView.h"
#import "HHSocialMediaShareUtility.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import <MessageUI/MessageUI.h>
#import "HHConstantsStore.h"


static NSString *const kRulesString = @"1）好友通过您的专属链接注册并成功报名，您的好友在报名时可立减%@元，同时您将获得%@元，自动存入您的哈哈学车推荐奖金中，累计无上限，可随时提现\n\n2）好友需通过您的专属链接注册才能建立推荐关系\n\n3）如发现作弊行为将取消用户活动资格，并扣除所获奖励\n\n4）如对本活动规则有任何疑问，请联系哈哈学车客服：400-001-6006\n\n";

static NSString *const kLawString = @"＊在法律允许的范围内，哈哈学车有权对活动规则进行解释";

@interface HHReferFriendsViewController () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHButton *referButton;
@property (nonatomic, strong) UIImageView *eventTitleImageView;
@property (nonatomic, strong) UILabel *eventRulesLabel;
@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic, strong) NSNumber *refererBonus;
@property (nonatomic, strong) NSNumber *refereeBonus;

@end

@implementation HHReferFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐有奖";
    self.refereeBonus = [[[HHConstantsStore sharedInstance] getAuthedUserCity] getRefereeBonus];
    self.refererBonus = [[[HHConstantsStore sharedInstance] getAuthedUserCity] getRefererBonus];
    
    self.view.backgroundColor = [UIColor HHBackgroundGary];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.imageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_share_pic.jpg"]];
    [self.scrollView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.attributedText = [self buildTitleString];
    self.titleLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.titleLabel];
    
    self.referButton = [[HHButton alloc] init];
    [self.referButton HHOrangeBackgroundWhiteTextButton];
    [self.referButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    [self.referButton addTarget:self action:@selector(showReferView) forControlEvents:UIControlEventTouchUpInside];
    self.referButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.scrollView addSubview:self.referButton];
    
    self.eventTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.scrollView addSubview:self.eventTitleImageView];
    
    self.eventRulesLabel = [[UILabel alloc] init];
    self.eventRulesLabel.numberOfLines = 0;
    self.eventRulesLabel.attributedText = [self buildRulesString];
    [self.scrollView addSubview:self.eventRulesLabel];
    
    [self makeConstraints];
    
}

- (NSMutableAttributedString *)buildRulesString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:kRulesString, [self.refereeBonus generateMoneyString], [self.refererBonus generateMoneyString]] attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:kLawString attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    [attrString appendAttributedString:attrString2];
    return attrString;
}

- (NSMutableAttributedString *)buildTitleString {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6.0f;
    style.alignment = NSTextAlignmentCenter;
    
    NSNumber *totalBonus = [[[HHConstantsStore sharedInstance] getAuthedUserCity] getTotalBonus];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"每邀请一位好友, 您和好友一起获得%@元奖励, 累积无上限!", [totalBonus generateMoneyString]] attributes:@{NSForegroundColorAttributeName:[UIColor HHTextDarkGray], NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSParagraphStyleAttributeName:style}];
    return attrString;
}

- (void)makeConstraints {
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-70.0f);
    }];
    
    [self.referButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-60.0f);
        make.height.mas_equalTo(60.0f);

    }];
    
    [self.eventTitleImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.referButton.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);

    }];
    
    [self.eventRulesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventTitleImageView.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-60.0f);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
        make.bottom.equalTo(self.eventRulesLabel.bottom).offset(30.0f);
    }];
    
}

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showReferView {
    __weak HHReferFriendsViewController *weakSelf = self;
    HHShareUserLinkView *view = [[HHShareUserLinkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.messageBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
        if([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = weakSelf;
            [messageController setRecipients:nil];
            
            [[HHLoadingViewUtility sharedInstance] showLoadingView];
            [[HHSocialMediaShareUtility sharedInstance] getUserReferLinkWithCompletion:^(NSString *link) {
                [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                [messageController setBody:[NSString stringWithFormat:@"墙裂推荐:哈哈学车.注册立享50元优惠\n %@", link]];
                [self presentViewController:messageController animated:YES completion:nil];
                
            }];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"本设备不支持短信发送!"];
        }
    };
    view.pasteBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHSocialMediaShareUtility sharedInstance] getUserReferLinkWithCompletion:^(NSString *link) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
            appPasteBoard.persistent = YES;
            [appPasteBoard setString:link];
            [[HHToastManager sharedManager] showSuccessToastWithText:@"复制成功"];
        }];
        
    };
    view.socialBlock = ^(SocialMedia type) {
        [[HHSocialMediaShareUtility sharedInstance] shareUserLinkWithType:(ShareType)type];
    };
    
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:view showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut];
    [HHPopupUtility showPopup:self.popup];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed: {
            [[HHToastManager sharedManager] showErrorToastWithText:@"发送失败, 请重试!"];
            break;
        }
            
        case MessageComposeResultSent: {
            [[HHToastManager sharedManager] showSuccessToastWithText:@"发送成功"];
            break;
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
