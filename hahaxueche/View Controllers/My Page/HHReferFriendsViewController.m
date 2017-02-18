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
#import "HHStudentStore.h"
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHSocialMediaShareUtility.h"
#import "HHShareView.h"
#import "HHPopupUtility.h"
#import "HHReferralDetailViewController.h"
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"
#import "HHIntroViewController.h"
#import "HHQRCodeShareView.h"


static NSString *const kRulesString = @"1. 点击分享此页面给好友, 好友可领取%@元新人专享代金券，报名时可直接立减%@元！\n2. 好友完成报名后，您将获得%@元奖励，累计无上限，可随时提现. \n3. 新用户仅限领取一次优惠礼包.\n4. 如发现作弊行为, 将取消用户活动资格, 并扣除所获奖励. \n5. 活动解释权归哈哈学车所有. 如对本活动规则有任何疑问, 请拨打400-001-6006或联系在线客服";

static NSString *const kRulesString2 = @"1.点击分此页面给好友，好友可领取¥200元新人专享代金券，报名时可直接立减¥200！\n2.好友完成报名后，你即可兑换本期对应礼品，累计无上限。\n3.推荐成功人数以在本期活动时间2.23-3.31期间报名成功的人数作为本期活动获奖依据。\n4.本期活动期获奖名单将于4月3日公布于“哈哈学车APP”微信公号，哈哈学车将于4月3日到4月7日期间统一联系学员进行活动礼品发放， 若超过发放期限未领取兑换礼品则视为放弃。\n5.若被推荐人未在本活动期间内报名，不可兑换本期礼品，可以顺延参加下一期的推荐有奖活动。\n6.除当期可兑换的礼品外，不可兑换其他礼品，不可折现，不可找零。\n7.如发现作弊行为将取消用户活动资格，并扣除所获奖励。\n8.活动解释权归哈哈学车所有，如对本活动规则有任何疑问，请拨打400-001-6006或联系在线客服。";

static NSString *const kLawString = @"＊在法律允许的范围内，哈哈学车有权对活动规则进行解释";

@interface HHReferFriendsViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *couponOne;
@property (nonatomic, strong) UIImageView *couponTwo;
@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) TTTAttributedLabel *labelTwo;
@property (nonatomic, strong) UILabel *labelThree;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) NSNumber *referrerBonus;
@property (nonatomic, strong) NSNumber *refereeBonus;


@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic) BOOL isLoggedIn;

@end

@implementation HHReferFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.referrerBonus = [[HHConstantsStore sharedInstance] getCityReferrerBonus];
    self.refereeBonus = [[HHConstantsStore sharedInstance] getCityRefereeBonus];
    self.isLoggedIn = [[HHStudentStore sharedInstance].currentStudent isLoggedIn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    if ([self isNormalUser]) {
        self.title = @"你推荐我送礼";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"推荐明细" titleColor:[UIColor whiteColor] action:@selector(showReferralDetailVC) target:self isLeft:NO];
        [self initSubviewsForNormalUser];
    } else {
        self.title = [NSString stringWithFormat:@"邀请好友 平分%@元", [@([self.referrerBonus floatValue] + [self.refereeBonus floatValue]) generateMoneyString]];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"提现" titleColor:[UIColor whiteColor] action:@selector(showReferralDetailVC) target:self isLeft:NO];
        [self initSubviewsForAgent];
    }
    
    [self makeConstraints];
}

- (void)initSubviewsForAgent {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_shareforaward"]];
    [self.scrollView addSubview:self.imageView];
    
    self.couponOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_200_big"]];
    [self.scrollView addSubview:self.couponOne];
    
    self.couponTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_200_big"]];
    [self.scrollView addSubview:self.couponTwo];
    
    self.labelOne = [self buildLabelWithText:[NSString stringWithFormat:@"分享哈哈学车, 好友可得%@元\n新人专享代金券", [self.refereeBonus generateMoneyString]] font:[UIFont systemFontOfSize:13.0f] color:[UIColor HHBrown]];
    [self.scrollView addSubview:self.labelOne];
    
    self.labelTwo = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.labelTwo.textAlignment = NSTextAlignmentCenter;
    self.labelTwo.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHConfirmRed]};
    self.labelTwo.attributedText = [self builAttrString];
    self.labelTwo.numberOfLines = 0;
    self.labelTwo.delegate = self;
    [self.scrollView addSubview:self.labelTwo];
    
    
    self.labelThree = [self buildLabelWithText:[NSString stringWithFormat:@"点击分享, 各得%@元", [self.referrerBonus generateMoneyString]] font:[UIFont systemFontOfSize:15.0f] color:[UIColor HHBrown]];
    [self.scrollView addSubview:self.labelThree];
    
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setTitle:@"立刻分享" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor HHPink];
    [self.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.scrollView addSubview:self.shareButton];
}

- (void)initSubviewsForNormalUser {
    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newshareforaward"]];
    [self.scrollView addSubview:self.topImageView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor HHBrown];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.text = @"哈哈学车百万大补贴\n2017.2.23-3.31";
    [self.scrollView addSubview:self.timeLabel];
    
    self.midImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secretgift"]];
    [self.scrollView addSubview:self.midImageView];
    
    self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHConfirmRed]};
    self.label.attributedText = [self builAttrString];
    self.label.numberOfLines = 0;
    self.label.delegate = self;
    [self.scrollView addSubview:self.label];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setTitle:@"点击分享 好礼多多" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor HHPink];
    [self.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.scrollView addSubview:self.shareButton];
}

- (UILabel *)buildLabelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_viewed attributes:nil];
}

- (NSMutableAttributedString *)builAttrString {
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@" 详情" attributes:@{NSForegroundColorAttributeName:[UIColor HHPink], NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f]}];
    
    NSMutableAttributedString *attrString;
    if ([self isNormalUser]) {
        attrString = [[NSMutableAttributedString alloc] initWithString:@"好友报名后即可兑换神秘奖品\n推荐越多, 奖品越大哦~" attributes:@{NSForegroundColorAttributeName:[UIColor HHBrown], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        [attrString appendAttributedString:attrString2];
        [self.label addLinkToURL:[NSURL URLWithString:@"showPopup"] withRange:[attrString.string rangeOfString:@" 详情"]];
    } else {
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"好友报名后再奖励你%@元,\n累积无上限, 随时可提现", [self.referrerBonus generateMoneyString]] attributes:@{NSForegroundColorAttributeName:[UIColor HHBrown], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        [attrString appendAttributedString:attrString2];
        [self.labelTwo addLinkToURL:[NSURL URLWithString:@"showPopup"] withRange:[attrString.string rangeOfString:@" 详情"]];
    }

    return attrString;
}


- (void)makeConstraints {
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    if ([self isNormalUser]) {
        [self.topImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.top);
            make.width.equalTo(self.scrollView.width);
            make.left.equalTo(self.scrollView.left);
        }];
        
        [self.midImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImageView.bottom).offset(40.0f);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.topImageView);
        }];
        
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.midImageView.bottom).offset(30.0f);
            make.width.equalTo(self.scrollView.width);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
        [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.label.bottom).offset(30.0f);
            make.width.mas_equalTo(180.0f);
            make.height.mas_equalTo(40.0f);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
    } else {
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.top);
            make.width.equalTo(self.scrollView.width);
            make.left.equalTo(self.scrollView.left);
        }];
        
        [self.couponOne makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.bottom).offset(20.0f);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
        [self.labelOne makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.couponOne.bottom).offset(10.0f);
            make.width.equalTo(self.scrollView.width);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
        [self.couponTwo makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelOne.bottom).offset(20.0f);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
        [self.labelTwo makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.couponTwo.bottom).offset(10.0f);
            make.width.equalTo(self.scrollView.width);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
        [self.labelThree makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTwo.bottom).offset(30.0f);
            make.width.equalTo(self.scrollView.width);
            make.centerX.equalTo(self.scrollView.centerX);
        }];
        
        [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelThree.bottom).offset(5.0f);
            make.width.mas_equalTo(180.0f);
            make.height.mas_equalTo(40.0f);
            make.centerX.equalTo(self.scrollView.centerX);
        }];

    }
    
    
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.shareButton
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];
   
    
}

- (void)share {
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_share_pic_tapped attributes:nil];
    __weak HHReferFriendsViewController *weakSelf = self;
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *sting = [[NSMutableAttributedString alloc] initWithString:@"爱分享的人运气一定不会差!" attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSParagraphStyleAttributeName:style}];
        
        NSMutableAttributedString *sting2 = [[NSMutableAttributedString alloc] initWithString:@"\n邀请好友领取哈哈学车大礼包哟" attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSParagraphStyleAttributeName:style}];
        [sting appendAttributedString:sting2];

        HHQRCodeShareView *shareView = [[HHQRCodeShareView alloc] initWithTitle:sting qrCodeImg:[[HHSocialMediaShareUtility sharedInstance] generateReferQRCode:YES]];
        shareView.dismissBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        shareView.selectedBlock = ^(SocialMedia selectedIndex) {
            if (selectedIndex == SocialMediaMessage) {
                [HHPopupUtility dismissPopup:weakSelf.popup];
            }
            [[HHSocialMediaShareUtility sharedInstance] shareMyReferPageWithShareType:selectedIndex inVC:weakSelf resultCompletion:^(BOOL succceed) {
                if (succceed) {
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_share_pic_succeed attributes:nil];
                }
            }];
        };
        self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
        [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];

    } else {
        [self showLoginAlertWithTitle:@"注册/登录后即可分享!"];
    }
}

- (void)popupVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)showReferralDetailVC {
    if (self.isLoggedIn) {
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:refer_page_cash_tapped attributes:nil];
        HHReferralDetailViewController *vc = [[HHReferralDetailViewController alloc] initWithTopView:![self isNormalUser]];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        [self showLoginAlertWithTitle:@"注册/登录后即查看推荐明细!"];
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"showPopup"]) {
        
        UIView *view;
        if ([self isNormalUser]) {
            view = [self buildPopupViewWithString:kRulesString2];
        } else {
            view = [self buildPopupViewWithString:[NSString stringWithFormat:kRulesString, [self.refereeBonus generateMoneyString], [self.refereeBonus generateMoneyString], [self.referrerBonus generateMoneyString]]];
        }
        
        self.popup = [HHPopupUtility createPopupWithContentView:view];
        self.popup.shouldDismissOnBackgroundTouch = YES;
        self.popup.shouldDismissOnContentTouch = NO;
        [HHPopupUtility showPopup:self.popup];
        
    } else if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [HHPopupUtility dismissPopup:self.popup];
        [[HHSupportUtility sharedManager] callSupport];
        
    } else if ([url.absoluteString isEqualToString:@"onlineSupport"]){
        [HHPopupUtility dismissPopup:self.popup];
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}

- (void)showLoginAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去注册/登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIView *)buildPopupViewWithString:(NSString *)text {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0f;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:style}];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-90.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading context:nil];
    
    NSRange range = [string.string rangeOfString:@"400-001-6006"];
    [string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    
    range = [string.string rangeOfString:@"在线客服"];
    [string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-60.0f, CGRectGetHeight(rect) + 80.0f)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    view.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHOrange];
    [view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left);
        make.width.equalTo(view.width);
        make.top.equalTo(view.top).offset(30.0f);
        make.height.mas_equalTo(2.0f);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"活动详情";
    label.font = [UIFont systemFontOfSize:22.0f];
    label.textColor = [UIColor HHOrange];
    [label sizeToFit];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.width.mas_equalTo(CGRectGetWidth(label.bounds) + 10.0f);
        make.centerY.equalTo(line.centerY);
    }];
    
    TTTAttributedLabel *textLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    textLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    textLabel.attributedText = string;
    textLabel.numberOfLines = 0;
    textLabel.delegate = self;
    [view addSubview:textLabel];
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.width.mas_equalTo(CGRectGetWidth(view.bounds) - 30.0f);
        make.top.equalTo(label.bottom).offset(10.0f);
    }];
    
    [textLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[string.string rangeOfString:@"400-001-6006"]];
    [textLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[string.string rangeOfString:@"在线客服"]];
    return view;
}


- (BOOL)isNormalUser {
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        return [HHStudentStore sharedInstance].currentStudent.isNormalUser;
    } else {
        return YES;
    }
}



@end
