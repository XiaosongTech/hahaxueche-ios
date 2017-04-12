//
//  HHHomePageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageViewController.h"
#import "HHHomePageTapView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHStudentStore.h"
#import "HHCitySelectView.h"
#import "HHConstantsStore.h"
#import "HHPopupUtility.h"
#import <KLCPopup/KLCPopup.h>
#import "HHCoachService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "INTULocationManager.h"
#import "HHFindCoachViewController.h"
#import "HHCoachDetailViewController.h"
#import "HHWebViewController.h"
#import "NSNumber+HHNumber.h"
#import "HHRootViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHStudentService.h"
#import "HHBanner.h"
#import "HHSupportUtility.h"
#import "HHTestView.h"
#import "HHTestStartViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHIntroViewController.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "HHQRCodeShareView.h"
#import "HHVoucherPopupView.h"
#import "HHSocialMediaShareUtility.h"
#import <APAddressBook/APAddressBook.h>
#import "HHGuardCardViewController.h"
#import "HHAddressBookUtility.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "HHInsuranceViewController.h"
#import "HHHomePageItemsView.h"
#import "UIBarButtonItem+HHCustomButton.h"


static NSString *const kCoachLink = @"https://m.hahaxueche.com/jiaolian";
static NSString *const kDrivingSchoolLink = @"https://m.hahaxueche.com/jiaxiao";
static NSString *const kAdvisorLink = @"https://m.hahaxueche.com/xue-che-bao";
static NSString *const kGroupPurchaseLink = @"https://m.hahaxueche.com/share/tuan?promo_code=456134";

static NSString *const kStepsLink = @"https://m.hahaxueche.com/xue-che-liu-cheng";
static NSString *const kPlatformLink = @"https://m.hahaxueche.com/xue-che-bao?promo_code=772272";

static NSString *const kHomePageVoucherPopupKey = @"kHomePageVoucherPopupKey";

@interface HHHomePageViewController ()

@property (nonatomic, strong) FLAnimatedImageView *findCoachView;
@property (nonatomic, strong) FLAnimatedImageView *findJiaxiaoView;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) HHHomePageItemsView *itemsView;

@property (nonatomic, strong) UIImageView *searchImage;

@property (nonatomic) BOOL popupVoucherShowed;

@end

@implementation HHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubviews];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    [[HHAddressBookUtility sharedManager] uploadContacts];
    
    if([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        [CloudPushSDK bindTag:1 withTags:@[@"purchased"] withAlias:nil withCallback:nil];

    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak HHHomePageViewController *weakSelf = self;
    if ([HHStudentStore sharedInstance].currentStudent.vouchers.count > 0 && ![[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        if (self.popupVoucherShowed) {
            return;
        }
        [[HHStudentService sharedInstance] getVouchersWithType:@(0) coachId:nil completion:^(NSArray *vouchers) {
            HHVoucher *biggestVoucher = [vouchers firstObject];
            for (HHVoucher *voucher in vouchers) {
                if (biggestVoucher.amount < voucher.amount) {
                    biggestVoucher = voucher;
                }
            }
            HHVoucherPopupView *popupView = [[HHVoucherPopupView alloc] initWithVoucher:biggestVoucher];
            popupView.dismissBlock = ^() {
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            popupView.shareBlock = ^() {
                [HHPopupUtility dismissPopup:weakSelf.popup];
                [weakSelf showShareView];
            };
            self.popup = [HHPopupUtility createPopupWithContentView:popupView];
            [HHPopupUtility showPopup:self.popup];
            self.popupVoucherShowed = YES;
        }];
        
    }
   
//    NSArray *cities = [[HHConstantsStore sharedInstance] getSupporteCities];
//    if (cities.count > 0) {
//        // Guest Student
//        if (![HHStudentStore sharedInstance].currentStudent.cityId) {
//            CGFloat height = MAX(300.0f, CGRectGetHeight(weakSelf.view.bounds)/2.0f);
//            weakSelf.citySelectView = [[HHCitySelectView alloc] initWithCities:cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:nil];
//            weakSelf.citySelectView.completion = ^(HHCity *selectedCity) {
//                if (selectedCity) {
//                    [HHStudentStore sharedInstance].currentStudent.cityId = selectedCity.cityId;
//                } else {
//                    [HHStudentStore sharedInstance].currentStudent.cityId = @(0);
//                }
//                [HHPopupUtility dismissPopup:weakSelf.popup];
//            };
//            
//            weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
//            [weakSelf.popup show];
//        } else {
//            
//        }
//    } else {
//        [HHStudentStore sharedInstance].currentStudent.cityId = @(0);
//    }
    
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_viewed attributes:nil];
    
    
}

- (void)initSubviews {
    
    self.searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuokuang"]];
    self.searchImage.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = self.searchImage;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem  buttonItemWithAttrTitle:[self generateAttrStringWithText:@"地图" image:[UIImage imageNamed:@"ic_map"] type:0] action:@selector(navMapTapped) target:self isLeft:NO];
    
    HHCity *city = [[HHConstantsStore sharedInstance] getCityWithId:[HHStudentStore sharedInstance].currentStudent.cityId];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem  buttonItemWithAttrTitle:[self generateAttrStringWithText:city.cityName image:[UIImage imageNamed:@"Triangle"] type:1] action:@selector(cityTapped) target:self isLeft:YES];
    
    __weak HHHomePageViewController *weakSelf = self;
    
    self.scrollView = [[UIScrollView  alloc] init];
    self.scrollView.backgroundColor = [UIColor HHBackgroundGary];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.topContainerView];
    
    self.findCoachView = [self buildGifViewWithPath:@"findCoach"];
    [self.topContainerView addSubview:self.findCoachView];
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findCoachViewTapped)];
    [self.findCoachView addGestureRecognizer:tapRec];
    
    
    self.findJiaxiaoView = [self buildGifViewWithPath:@"findJiaxiao"];
    [self.topContainerView addSubview:self.findJiaxiaoView];
    UITapGestureRecognizer *tapRec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findJiaxiaoViewTapped)];
    [self.findJiaxiaoView addGestureRecognizer:tapRec2];
    
    self.itemsView = [[HHHomePageItemsView alloc] init];
    [self.topContainerView addSubview:self.itemsView];
    
    
    
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.topContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(150.0f);
    }];

    [self.findJiaxiaoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainerView.left).offset(10.0f);
        make.right.equalTo(self.topContainerView.centerX).offset(-5.0f);
        make.top.equalTo(self.topContainerView.top).offset(15.0f);
        make.height.mas_equalTo(55.0f);
    }];
    
    [self.findCoachView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.findJiaxiaoView.right).offset(10.0f);
        make.width.equalTo(self.findJiaxiaoView.width);
        make.top.equalTo(self.topContainerView.top).offset(15.0f);
        make.height.mas_equalTo(55.0f);
    }];
    
    [self.itemsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainerView.left);
        make.width.equalTo(self.topContainerView.width);
        make.top.equalTo(self.findCoachView.bottom);
        make.bottom.equalTo(self.topContainerView.bottom);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.equalTo(self.view.height).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.bounds));
    }];
//
//    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.adviserView
//                                                                attribute:NSLayoutAttributeBottom
//                                                                relatedBy:NSLayoutRelationEqual
//                                                                   toItem:self.scrollView
//                                                                attribute:NSLayoutAttributeBottom
//                                                               multiplier:1.0
//                                                                 constant:-20.0f]];

}


- (FLAnimatedImageView *)buildGifViewWithPath:(NSString *)path {
    FLAnimatedImageView *view = [[FLAnimatedImageView alloc] init];
    NSString *imgString = [[NSBundle mainBundle] pathForResource:path ofType:@"gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgString];
    FLAnimatedImage *img = [FLAnimatedImage animatedImageWithGIFData:imgData];
    view.animationDuration = 0.1f;
    view.animatedImage = img;
    view.userInteractionEnabled = YES;
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
    
}

#pragma mark - Button Actions 

- (void)findCoachViewTapped {
    
}

- (void)findJiaxiaoViewTapped {
    
}

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)showTestVC {
    HHTestStartViewController *vc =  [[HHTestStartViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
    
}

- (void)showShareView {
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_voucher_popup_share_tapped attributes:nil];
    __weak HHHomePageViewController *weakSelf = self;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *sting = [[NSMutableAttributedString alloc] initWithString:@"爱分享的人运气一定不会差~\n" attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSParagraphStyleAttributeName:style}];
    
    NSMutableAttributedString *sting2 = [[NSMutableAttributedString alloc] initWithString:@"邀请好友领取哈哈学车新人大礼包哟" attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSParagraphStyleAttributeName:style}];
    [sting appendAttributedString:sting2];
    
    HHQRCodeShareView *shareView = [[HHQRCodeShareView alloc] initWithTitle:sting qrCodeImg:[[HHSocialMediaShareUtility sharedInstance] generateReferQRCode:NO]];
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.selectedBlock = ^(SocialMedia selectedIndex) {
        if (selectedIndex == SocialMediaMessage) {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        }
        [[HHSocialMediaShareUtility sharedInstance] shareMyReferPageWithShareType:selectedIndex inVC:weakSelf resultCompletion:^(BOOL succceed) {
            if (succceed) {
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_voucher_popup_share_succeed attributes:@{@"channel": [[HHSocialMediaShareUtility sharedInstance] getChannelNameWithType:selectedIndex]}];
            }
        }];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (NSAttributedString *)generateAttrStringWithText:(NSString *)text image:(UIImage *)image type:(NSInteger)type {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    if (type == 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@", text] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = image;
        textAttachment.bounds = CGRectMake(5, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        [attributedString insertAttributedString:attrStringWithImage atIndex:0];
        return attributedString;
    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = image;
        textAttachment.bounds = CGRectMake(2.0f, 0, textAttachment.image.size.width, textAttachment.image.size.height);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        [attributedString appendAttributedString:attrStringWithImage];
        return attributedString;
    }
    
}



@end
