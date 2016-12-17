//
//  HHHomePageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
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
#import "HHFreeTrialUtility.h"
#import "HHTestView.h"
#import "HHReferralShareView.h"
#import "HHHomPageCardView.h"
#import "HHHomePageItemsView.h"
#import "HHTestStartViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHIntroViewController.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "HHQRCodeShareView.h"
#import "HHVoucherPopupView.h"
#import "HHSocialMediaShareUtility.h"


static NSString *const kCoachLink = @"https://m.hahaxueche.com/share/best-coaches";
static NSString *const kDrivingSchoolLink = @"https://m.hahaxueche.com/share/zhaojiaxiao";
static NSString *const kAdvisorLink = @"https://m.hahaxueche.com/share/zhaoguwen?city_id=%@";
static NSString *const kGroupPurchaseLink = @"https://m.hahaxueche.com/share/tuan";

static NSString *const kStepsLink = @"https://activity.hahaxueche.com/share/steps";
static NSString *const kPlatformLink = @"https://m.hahaxueche.com/assurance";

static NSString *const kHomePageVoucherPopupKey = @"kHomePageVoucherPopupKey";

@interface HHHomePageViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) FLAnimatedImageView *freeTryImageView;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *freeTrialContainerView;

@property (nonatomic, strong) HHHomPageCardView *drivingSchoolView;
@property (nonatomic, strong) HHHomPageCardView *coachView;
@property (nonatomic, strong) HHHomPageCardView *adviserView;
@property (nonatomic, strong) HHHomePageItemsView *itemsView;

@property (nonatomic) BOOL popupVoucherShowed;

@end

@implementation HHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈学车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.banners = [[HHConstantsStore sharedInstance] getHomePageBanners];
    [self initSubviews];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak HHHomePageViewController *weakSelf = self;
    NSArray *cities = [[HHConstantsStore sharedInstance] getSupporteCities];
    if ([cities count]) {
        // Guest Student
        if (![HHStudentStore sharedInstance].currentStudent.cityId) {
            CGFloat height = MAX(300.0f, CGRectGetHeight(weakSelf.view.bounds)/2.0f);
            weakSelf.citySelectView = [[HHCitySelectView alloc] initWithCities:cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:nil];
            weakSelf.citySelectView.completion = ^(HHCity *selectedCity) {
                if (selectedCity) {
                    [HHStudentStore sharedInstance].currentStudent.cityId = selectedCity.cityId;
                } else {
                    [HHStudentStore sharedInstance].currentStudent.cityId = @(0);
                }
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
            [weakSelf.popup show];
        } else {
            if ([HHStudentStore sharedInstance].currentStudent.vouchers.count > 0 && ![[HHStudentStore sharedInstance].currentStudent isPurchased]) {
                if (self.popupVoucherShowed) {
                    return;
                }
                [[HHStudentService sharedInstance] getVouchersWithType:@(0) completion:^(NSArray *vouchers) {
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
        }
    }

    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_viewed attributes:nil];
}

- (void)initSubviews {
    
    __weak HHHomePageViewController *weakSelf = self;
    
    self.scrollView = [[UIScrollView  alloc] init];
    self.scrollView.backgroundColor = [UIColor HHBackgroundGary];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.bannerView = [[SDCycleScrollView alloc] init];
    NSMutableArray *imgArray = [NSMutableArray array];
    for (HHBanner *banner in self.banners) {
        [imgArray addObject:banner.imgURL];
    }
    self.bannerView.imageURLStringsGroup = imgArray;
    self.bannerView.autoScroll = YES;
    self.bannerView.autoScrollTimeInterval = 3.0f;
    self.bannerView.delegate = self;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.bannerView.backgroundColor = [UIColor HHOrange];
    self.bannerView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.bannerView.currentPageDotColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bannerView];
    
    NSMutableArray *strings = [NSMutableArray array];
    [strings addObject:@"已入驻"];
    [strings addObject:@"所"];
    self.drivingSchoolView = [[HHHomPageCardView alloc] initWithIcon:[UIImage imageNamed:@"ic_cup"] title:@"入驻驾校 权威认证" subTitle:[self generateStringWithArray:strings number:@([[HHConstantsStore sharedInstance].constants.drivingSchoolCount integerValue]) color:[UIColor HHOrange]] bigIcon:[UIImage imageNamed:@"pic_xiaoha_school"] items:@[@"通过率高", @"训练场地规范", @"品牌口碑佳", @"权威驾校认证"] dotColor:[UIColor  HHOrange]];
    self.drivingSchoolView.tapAction = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kDrivingSchoolLink]];
         [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_driving_school_tapped attributes:nil];
    };
    [self.scrollView addSubview:self.drivingSchoolView];
    
    [strings removeAllObjects];
    [strings addObject:@"已签约"];
    [strings addObject:@"名"];
    self.coachView = [[HHHomPageCardView alloc] initWithIcon:[UIImage imageNamed:@"ic_medal_h"] title:@"签约教练 择优合作" subTitle:[self generateStringWithArray:strings number:@([[HHConstantsStore sharedInstance].constants.coachCount integerValue]) color:[UIColor HHLightBlue]] bigIcon:[UIImage imageNamed:@"pic_xiaoha_coach"] items:@[@"免费试学", @"价格透明", @"分阶段打款", @"灵活退学"] dotColor:[UIColor  HHLightBlue]];
    self.coachView.tapAction = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kCoachLink]];
         [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_coach_tapped attributes:nil];
    };
    [self.scrollView addSubview:self.coachView];
    
    [strings removeAllObjects];
    [strings addObject:@"已帮助学员"];
    [strings addObject:@"名"];
    self.adviserView = [[HHHomPageCardView alloc] initWithIcon:[UIImage imageNamed:@"ic_adviser"] title:@"学车顾问 全程无忧" subTitle:[self generateStringWithArray:strings number:@([[HHConstantsStore sharedInstance].constants.paidStudentCount integerValue]) color:[UIColor HHRed]] bigIcon:[UIImage imageNamed:@"pic_xiaoha_adviser"] items:@[@"量身推荐", @"智能预约", @"贴心售后", @"全程保障"] dotColor:[UIColor  HHRed]];
    self.adviserView.tapAction = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:[NSString stringWithFormat:kAdvisorLink, [[HHStudentStore sharedInstance].currentStudent.cityId stringValue]]]];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_advisor_tapped attributes:nil];
    };
    [self.scrollView addSubview:self.adviserView];
    
    self.freeTrialContainerView = [[UIView alloc] init];
    self.freeTrialContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.freeTrialContainerView];
    
    self.freeTryImageView = [[FLAnimatedImageView alloc] init];
    NSString *imgString = [[NSBundle mainBundle] pathForResource:@"button_freetry" ofType:@"gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgString];
    FLAnimatedImage *img = [FLAnimatedImage animatedImageWithGIFData:imgData];
    self.freeTryImageView.animationDuration = 0.1f;
    self.freeTryImageView.animatedImage = img;
    self.freeTryImageView.userInteractionEnabled = YES;
    self.freeTryImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.freeTrialContainerView addSubview:self.freeTryImageView];
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tryCoachForFree)];
    [self.freeTryImageView addGestureRecognizer:tapRec];
    
    self.itemsView = [[HHHomePageItemsView alloc] init];
    self.itemsView.itemBlock = ^(ItemType index) {
        [weakSelf itemTappedWithIndex:index];
    };
    [self.scrollView addSubview:self.itemsView];
    
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.equalTo(self.view.width).multipliedBy(2.0f/5.0f);
    }];
    
    [self.freeTrialContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(130.0f);
    }];

    [self.freeTryImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freeTrialContainerView.centerY);
        make.centerX.equalTo(self.freeTrialContainerView.centerX);
        make.width.lessThanOrEqualTo(self.freeTrialContainerView.width).offset(-20.0f);
        make.height.lessThanOrEqualTo(self.freeTryImageView.height).offset(-10.0f);
    }];
    
    [self.itemsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.freeTrialContainerView.bottom).offset(10.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(160.0f);
    }];
    
    
    [self.drivingSchoolView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemsView.bottom).offset(10.0f);
        make.left.equalTo(self.scrollView.left).offset(10.0f);
        make.width.equalTo(self.scrollView.width).offset(-20.0f);
        make.height.mas_equalTo(130.0f);
        
    }];
    
    [self.coachView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.drivingSchoolView.bottom).offset(10.0f);
        make.left.equalTo(self.scrollView.left).offset(10.0f);
        make.width.equalTo(self.scrollView.width).offset(-20.0f);
        make.height.mas_equalTo(130.0f);
        
    }];
    
    [self.adviserView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachView.bottom).offset(10.0f);
        make.left.equalTo(self.scrollView.left).offset(10.0f);
        make.width.equalTo(self.scrollView.width).offset(-20.0f);
        make.height.mas_equalTo(130.0f);
        
    }];

    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.equalTo(self.view.height).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.bounds));
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.adviserView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];

}

#pragma mark - Button Actions 

- (void)oneTapButtonTapped {
   [self tryCoachForFree];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HHBanner *banner = self.banners[index];
    if ([banner.targetURL length] > 0) {
        [self openWebPage:[NSURL URLWithString:banner.targetURL]];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_banner_tapped attributes:@{@"URL":banner.targetURL}];
    } else {
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_banner_tapped attributes:nil];
    }
    
    
}

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)tryCoachForFree {
    NSString *urlString = [[HHFreeTrialUtility sharedManager] buildFreeTrialURLStringWithCoachId:nil];
    [self openWebPage:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_free_trial_tapped attributes:nil];
}


- (NSMutableAttributedString *)generateStringWithArray:(NSArray *)strings number:(NSNumber *)number color:(UIColor *)color {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strings[0] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[number generateLargeNumberString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:color}];
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:strings[1] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    
    [string appendAttributedString:string2];
    [string appendAttributedString:string3];
    return string;
}


- (void)itemTappedWithIndex:(ItemType)index {
    switch (index) {
        case ItemTypeGroupPurchase: {
            [self openWebPage:[NSURL URLWithString:kGroupPurchaseLink]];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_group_purchase_tapped attributes:nil];
            
        } break;
            
        case ItemTypeOnlineTest: {
            [self showTestVC];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_online_test_tapped attributes:nil];
            
        } break;
            
        case ItemTypeCourseOne: {
            [self showTestVC];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_course_one_tapped attributes:nil];
        } break;
            
        case ItemTypePlatformGuard: {
            [self openWebPage:[NSURL URLWithString:kPlatformLink]];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_platform_guard_tapped attributes:nil];
            
        } break;
            
        case ItemTypeProcess: {
            [self openWebPage:[NSURL URLWithString:kStepsLink]];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_process_tapped attributes:nil];
            
        } break;
            
        case ItemTypeReferFriends: {
            HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navVC animated:YES completion:nil];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_refer_friends_tapped attributes:nil];
            
        } break;
            
        case ItemTypeOnlineSupport: {
            [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_online_support_tapped attributes:nil];

            
            
        } break;
            
        case ItemTypeCallSupport: {
            [[HHSupportUtility sharedManager] callSupport];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:homepage_phone_support_tapped attributes:nil];
            
        } break;
            
            
            
        default:
            break;
    }
}

- (void)showTestVC {
    __weak HHHomePageViewController *weakSelf = self;
    HHTestStartViewController *vc =  [[HHTestStartViewController alloc] init];
    vc.dismissBlock = ^() {
        weakSelf.tabBarController.selectedIndex = 1;
    };
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



@end
