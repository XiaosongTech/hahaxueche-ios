//
//  HHCoachMyProfileViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachMyProfileViewController.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import "HHAvatarView.h"
#import "HHUserAuthenticator.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHLoginSignupViewController.h"
#import "Appirater.h"

#define kAvatarRadius 35.0f

static NSString *const TOUURL = @"http://www.hahaxueche.net/index/mz/";

@interface HHCoachMyProfileViewController () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActionSheet *settingsActionSheet;
@property (nonatomic, strong) UIAlertView *logoutAlertView;

@end

@implementation HHCoachMyProfileViewController

- (void)dealloc {
    self.settingsActionSheet.delegate = nil;
    self.logoutAlertView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.title = NSLocalizedString(@"我的页面", ni);
    UIBarButtonItem *settings = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"设置", nil) action:@selector(settingsTapped) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = settings;

    [self initSubviews];
}

- (void)settingsTapped {
    self.settingsActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"返回", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"给哈哈学车评分", nil), NSLocalizedString(@"查看条款和协议", nil), NSLocalizedString(@"联系客服", nil), NSLocalizedString(@"退出账号", nil), nil];
    self.settingsActionSheet.destructiveButtonIndex = 3;
    [self.settingsActionSheet showInView:self.view];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.view addSubview:self.scrollView];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.containerView];
    
    self.avatarView = [[HHAvatarView alloc] initWithImageURL:[HHUserAuthenticator sharedInstance].currentCoach.avatarURL radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f];
    self.nameLabel.textColor = [UIColor HHDarkGrayTextColor];
    self.nameLabel.text = [HHUserAuthenticator sharedInstance].currentCoach.fullName;
    [self.nameLabel sizeToFit];
    [self.containerView addSubview:self.nameLabel];
    
    self.qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.qrCodeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.qrCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:[HHUserAuthenticator sharedInstance].currentCoach.qrCodeURL] placeholderImage:nil];
    [self.containerView addSubview:self.qrCodeImageView];
    
    self.explanationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.explanationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.explanationLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14.0f];
    self.explanationLabel.textColor = [UIColor HHGrayTextColor];
    self.explanationLabel.text = NSLocalizedString(@"二维码使用规则：为方便教练统一管理所有学员，教练所带的非哈哈学车的学员，也可以注册哈哈学车账号并免费使用预约系统。下载哈哈学车App并注册，在注册时扫描教练二维码，即可使用哈哈学车App.(请教练妥善保管好此二维码，不要随意分享)", nil);
    [self.explanationLabel sizeToFit];
    self.explanationLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.explanationLabel];

    
    [self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.scrollView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.scrollView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterX:self.containerView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:0 constant:350.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-40.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.self.avatarView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius * 2.0f],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius * 2.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.nameLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.nameLabel toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.qrCodeImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.qrCodeImageView toView:self.nameLabel constant:30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.qrCodeImageView multiplier:0 constant:150.0f],
                             [HHAutoLayoutUtility setViewWidthEqualToHeight:self.qrCodeImageView],
                             
                             [HHAutoLayoutUtility setCenterX:self.explanationLabel multiplier:1.0f constant:0   ],
                             [HHAutoLayoutUtility verticalNext:self.explanationLabel toView:self.containerView constant:5.0f],
                             [HHAutoLayoutUtility setViewWidth:self.explanationLabel multiplier:1.0f constant:-40.0f],
                             

                             ];
    
    [self.view addConstraints:constraints];
    
    // Let scrollView know the contentSize
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.explanationLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.explanationLabel
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [Appirater rateApp];
        
    } else if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TOUURL]];
        
    } else if (buttonIndex == 2) {
        NSString *phNo = @"4000016006";
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        }

    } else if (buttonIndex == 3) {
        self.logoutAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确定要退出？", nil) message:NSLocalizedString(@"退出后，可以通过手机号再次登陆！", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消退出", nil) otherButtonTitles:NSLocalizedString(@"确定退出", nil), nil];
        [self.logoutAlertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:self.logoutAlertView]) {
        if (buttonIndex == 1) {
            [[HHUserAuthenticator sharedInstance] logout];
            HHLoginSignupViewController *loginSignupVC = [[HHLoginSignupViewController alloc] init];
            [self presentViewController:loginSignupVC animated:YES completion:nil];
        }
    }
}


@end
