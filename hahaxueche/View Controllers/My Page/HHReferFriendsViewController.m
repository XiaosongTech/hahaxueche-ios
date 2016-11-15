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
#import "HHSocialMediaShareUtility.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import <MessageUI/MessageUI.h>
#import <UIImageView+WebCache.h>
#import "HHConstantsStore.h"
#import "HHWithdrawViewController.h"
#import "HHStudentStore.h"
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHSocialMediaShareUtility.h"
#import "HHShareView.h"
#import "HHPopupUtility.h"
#import "HHReferralDetailViewController.h"
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"


static NSString *const kRulesString = @"1）好友通过您的专属链接注册并成功报名，您的好友报名成功后，您将获得%@元，累计无上限，可随时提现\n\n2）好友需通过您的专属二维码免费试学才能建立推荐关系\n\n3）如发现作弊行为将取消用户活动资格,并扣除所获奖励\n\n";

static NSString *const kLawString = @"＊在法律允许的范围内，哈哈学车有权对活动规则进行解释";

@interface HHReferFriendsViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *eventTitleImageView;
@property (nonatomic, strong) UIImageView *myQRCodeView;
@property (nonatomic, strong) TTTAttributedLabel *eventRulesLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *withdrawButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) HHShareView *shareView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) UIButton *arrowButton;

@end

@implementation HHReferFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我为哈哈代言";
    
    self.view.backgroundColor = [UIColor HHBackgroundGary];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    UIView *bounceBGVIew = [[UIView alloc] initWithFrame:CGRectMake(0,-480,CGRectGetWidth(self.view.bounds),480)];
    bounceBGVIew.backgroundColor = [UIColor HHOrange];
    [self.scrollView addSubview:bounceBGVIew];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self.scrollView addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"可提现";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.topView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor whiteColor];
    self.valueLabel.text = [[HHStudentStore sharedInstance].currentStudent.bonusBalance generateMoneyString];
    self.valueLabel.font = [UIFont systemFontOfSize:28.0f];
    [self.topView addSubview:self.valueLabel];
    
    self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
    [self.withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.withdrawButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.withdrawButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    self.withdrawButton.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    [self.withdrawButton addTarget:self action:@selector(showWithdrawVC) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.withdrawButton];
    
    self.arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.arrowButton setImage:[UIImage imageNamed:@"ic_arrow_more_white"] forState:UIControlStateNormal];
    [self.arrowButton addTarget:self action:@selector(showReferralDetailVC) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.arrowButton];
    
    self.midView = [[UIView alloc] init];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.midView];
    
    self.myQRCodeView = [[UIImageView alloc] init];
    [self.myQRCodeView sd_setImageWithURL:[NSURL URLWithString:[[HHStudentService sharedInstance] getStudentQRCodeURL]]];
    self.myQRCodeView.userInteractionEnabled = YES;
    [self.midView addSubview:self.myQRCodeView];
    UILongPressGestureRecognizer *longRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showOptions)];
    [self.myQRCodeView addGestureRecognizer:longRec];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setTitle:@"点击分享, 赚回学费" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.shareButton.backgroundColor = [UIColor HHOrange];
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = 25.0f;
    [self.shareButton addTarget:self action:@selector(shareImg) forControlEvents:UIControlEventTouchUpInside];
    [self.midView addSubview:self.shareButton];
    
    HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    self.imageView = [[UIImageView alloc] init];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:city.referalBanner] placeholderImage:nil];
    [self.scrollView addSubview:self.imageView];
    
    self.eventTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.scrollView addSubview:self.eventTitleImageView];
    
    self.eventRulesLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.eventRulesLabel.attributedText = [self buildRulesString];
    self.eventRulesLabel.numberOfLines = 0;
    self.eventRulesLabel.delegate = self;
    [self.scrollView addSubview:self.eventRulesLabel];
    
    [self makeConstraints];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_viewed attributes:nil];
}

- (NSMutableAttributedString *)buildRulesString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:kRulesString, [[[HHConstantsStore sharedInstance] getCityReferrerBonus] generateMoneyString]] attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@"4）如对本活动规则有任何疑问,请拨打哈哈学车客服热线:400-001-6006 或 点击联系:在线客服\n\n" attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    [attrString2 addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[@"4）如对本活动规则有任何疑问,请拨打哈哈学车客服热线:400-001-6006 或 点击联系:在线客服\n\n" rangeOfString:@"400-001-6006"]];
    [attrString2 addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[@"4）如对本活动规则有任何疑问,请拨打哈哈学车客服热线:400-001-6006 或 点击联系:在线客服\n\n" rangeOfString:@"在线客服"]];
    [attrString appendAttributedString:attrString2];
    
    NSMutableAttributedString *attrString3 = [[NSMutableAttributedString alloc] initWithString:kLawString attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    [attrString appendAttributedString:attrString3];
    
    [self.eventRulesLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[attrString.string rangeOfString:@"400-001-6006"]];
    [self.eventRulesLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[attrString.string rangeOfString:@"在线客服"]];
    
    return attrString;
}


- (void)makeConstraints {
    
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
        make.bottom.equalTo(self.eventRulesLabel.bottom).offset(20.0f);
    }];
    
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(90.0f);
        
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5.0f);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(30.0f);
        make.right.equalTo(self.topView.right).offset(-20.0f);
        make.width.mas_equalTo(60.0f);
        make.height.mas_equalTo(30.0f);
        
    }];
    
    [self.arrowButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.valueLabel.centerY);
        make.left.equalTo(self.valueLabel.right).offset(5.0f);
    }];
    
    CGFloat midViewHeight = 100.0f + CGRectGetWidth(self.view.bounds) - 30.0f;
    [self.midView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(midViewHeight);
    }];
    
    [self.myQRCodeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.top).offset(10.0f);
        make.centerX.equalTo(self.midView.centerX);
        make.width.equalTo(self.midView.width).offset(-30.0f);
        make.height.equalTo(self.myQRCodeView.width);
    }];
    
    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.midView.bottom).offset(-30.0f);
        make.centerX.equalTo(self.midView.centerX);
        make.width.equalTo(self.midView.width).offset(-60.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(335.0f);
    }];

    
    [self.eventTitleImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);

    }];
    
    [self.eventRulesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventTitleImageView.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-60.0f);
    }];
    
}

- (void)popupVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)showWithdrawVC {
    HHWithdrawViewController *vc = [[HHWithdrawViewController alloc] initWithAvailableAmount:[HHStudentStore sharedInstance].currentStudent.bonusBalance];
    [self.navigationController pushViewController:vc animated:YES];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_cash_tapped attributes:nil];
}

- (void)saveImage {
    UIImageWriteToSavedPhotosAlbum(self.myQRCodeView.image,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL); // you generally won't need a contextInfo here
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"保存失败, 请重试!"];
    } else {
        [[HHToastManager sharedManager] showSuccessToastWithText:@"保存成功!"];
    }
}

- (void)shareImg {
    __weak HHReferFriendsViewController *weakSelf = self;
    if (self.myQRCodeView.image) {
        HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
        
        shareView.dismissBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        shareView.actionBlock = ^(SocialMedia selecteItem) {
            [[HHSocialMediaShareUtility sharedInstance] shareMyQRCode:weakSelf.myQRCodeView.image shareType:selecteItem resultCompletion:^(BOOL succceed) {
                if (succceed) {
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_share_pic_succeed attributes:@{@"channel": [[HHSocialMediaShareUtility sharedInstance] getChannelNameWithType:selecteItem]}];
                }
            }];
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
        [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_share_pic_tapped attributes:nil];
    }
}

- (void)showReferralDetailVC {
    HHReferralDetailViewController *vc = [[HHReferralDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_check_balance_tapped attributes:nil];
}

- (void)showOptions {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveAction = [UIAlertAction
                                  actionWithTitle:@"保存图片到本地"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action) {
                                      [self saveImage];
                                  }];
    UIAlertAction *cancelAction = [UIAlertAction
                                 actionWithTitle:@"取消"
                                 style:UIAlertActionStyleCancel
                                 handler:nil];
    [alertController addAction:saveAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
    } else {
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}


@end
