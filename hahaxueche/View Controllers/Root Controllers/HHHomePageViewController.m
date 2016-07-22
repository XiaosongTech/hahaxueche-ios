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
#import "HHGenericOneButtonPopupView.h"
#import "NSNumber+HHNumber.h"
#import "HHRootViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHGroupPurchaseView.h"
#import "HHStudentService.h"
#import "HHTryCoachView.h"
#import "HHBanner.h"
#import "HHHomePageSupportView.h"
#import "HHSupportUtility.h"
#import "HHFreeTrialUtility.h"

static NSString *const kAboutStudentLink = @"http://staging.hahaxueche.net/#/student";
static NSString *const kAboutCoachLink = @"http://staging.hahaxueche.net/#/coach";
static NSString *const kFeatureLink = @"http://activity.hahaxueche.com/share/features";
static NSString *const kStepsLink = @"http://activity.hahaxueche.com/share/steps";


@interface HHHomePageViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) HHHomePageTapView *firstView;
@property (nonatomic, strong) HHHomePageTapView *secondView;
@property (nonatomic, strong) HHHomePageTapView *thirdView;
@property (nonatomic, strong) HHHomePageTapView *forthView;
@property (nonatomic, strong) UIButton *freeTryButton;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HHHomePageSupportView *callSupportView;
@property (nonatomic, strong) HHHomePageSupportView *onlineSupportView;
@property (nonatomic, strong) UIView *freeTrialContainerView;

@end

@implementation HHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈学车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.banners = [[HHConstantsStore sharedInstance] getHomePageBanners];
    [self initSubviews];
    
    __weak HHHomePageViewController *weakSelf = self;
    NSArray *cities = [[HHConstantsStore sharedInstance] getSupporteCities];
    if ([cities count]) {
        // Guest Student
        if (![HHStudentStore sharedInstance].currentStudent.cityId) {
            CGFloat height = MAX(300.0f, CGRectGetHeight(weakSelf.view.bounds)/2.0f);
            weakSelf.citySelectView = [[HHCitySelectView alloc] initWithCities:cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:nil];
            weakSelf.citySelectView.completion = ^(HHCity *selectedCity) {
                [HHStudentStore sharedInstance].currentStudent.cityId = selectedCity.cityId;
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            [HHStudentStore sharedInstance].currentStudent.cityId = @(0);
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
            [weakSelf.popup show];
        }
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];


}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSNumber *isShowed = [defaults objectForKey:@"showedBonusPopoup"];
//
//    if (![isShowed boolValue] && [[HHStudentStore sharedInstance].currentStudent.byReferal boolValue] && [HHStudentStore sharedInstance].currentStudent.studentId && ![[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray count]) {
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.alignment = NSTextAlignmentLeft;
//        paragraphStyle.lineSpacing = 8.0f;
//        NSNumber *refereeBonus = [[[HHConstantsStore sharedInstance] getAuthedUserCity] getRefereeBonus];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元已经打进您的账户余额, 在支付过程中, 系统会自动减现%@元报名费.", [refereeBonus generateMoneyString], [refereeBonus generateMoneyString]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
//        
//        __weak HHHomePageViewController *weakSelf = self;
//        HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 280.0f) title:@"注册成功!" subTitle:[NSString stringWithFormat:@"恭喜您获得%@元学车券!",[refereeBonus generateMoneyString] ] info:attributedString];
//        view.cancelBlock = ^() {
//            [HHPopupUtility dismissPopup:weakSelf.popup];
//        };
//        self.popup = [HHPopupUtility createPopupWithContentView:view];
//        [HHPopupUtility showPopup:self.popup];
//        [defaults setObject:@(1) forKey:@"showedBonusPopoup"];
//    }
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}

- (void)initSubviews {
    
    __weak HHHomePageViewController *weakSelf = self;
    
    self.scrollView = [[UIScrollView  alloc] init];
    self.scrollView.backgroundColor = [UIColor HHBackgroundGary];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 0.8f + 318.0f);
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
    
    
    self.firstView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_haha"] title:@"关于小哈" subTitle:@"全能的小哈" showRightLine:YES];
    self.firstView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kAboutStudentLink]];
    };
    [self.scrollView addSubview:self.firstView];
    
    self.secondView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_coach"] title:@"关于教练" subTitle:@"优秀的教练" showRightLine:NO];
    self.secondView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kAboutCoachLink]];
    };
    [self.scrollView addSubview:self.secondView];
    
    self.thirdView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_strengths"] title:@"我的优势" subTitle:@"独特的优势" showRightLine:YES];
    self.thirdView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kFeatureLink]];
    };
    [self.scrollView addSubview:self.thirdView];
    
    self.forthView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_procedure"] title:@"学车流程" subTitle:@"简单的流程" showRightLine:NO];
    self.forthView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kStepsLink]];
    };
    [self.scrollView addSubview:self.forthView];
    
    self.freeTrialContainerView = [[UIView alloc] init];
    self.freeTrialContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.freeTrialContainerView];
    
    self.freeTryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.freeTryButton setTitle:@"免费试学" forState:UIControlStateNormal];
    [self.freeTryButton setBackgroundColor:[UIColor HHOrange]];
    [self.freeTryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.freeTryButton addTarget:self action:@selector(oneTapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.freeTryButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.freeTryButton.layer.cornerRadius = 5.0f;
    self.freeTryButton.layer.masksToBounds = YES;
    [self.freeTrialContainerView addSubview:self.freeTryButton];
    
    self.callSupportView = [[HHHomePageSupportView alloc] initWithImage:[UIImage imageNamed:@"ic_ask_call"] title:@"电话咨询" showRightLine:YES];
    self.callSupportView.actionBlock = ^() {
        [[HHSupportUtility sharedManager] callSupport];
    };
    [self.scrollView addSubview:self.callSupportView];
    
    self.onlineSupportView = [[HHHomePageSupportView alloc] initWithImage:[UIImage imageNamed:@"ic_ask_message"] title:@"在线客服" showRightLine:YES];
    self.onlineSupportView.actionBlock = ^() {
        [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
    };
    [self.scrollView addSubview:self.onlineSupportView];

    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.equalTo(self.view.width).multipliedBy(4.0f/5.0f);
    }];
    
    [self.callSupportView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.onlineSupportView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.left.equalTo(self.callSupportView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.firstView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.callSupportView.bottom).offset(10.0f);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(85.0f);
    }];
    
    [self.secondView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.top);
        make.left.equalTo(self.firstView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.equalTo(self.firstView.height);
    }];
    
    [self.thirdView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.equalTo(self.firstView.height);
    }];
    
    
    [self.forthView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.top);
        make.left.equalTo(self.thirdView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.equalTo(self.firstView.height);
    }];
    
    [self.freeTryButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freeTrialContainerView.centerY);
        make.centerX.equalTo(self.freeTrialContainerView.centerX);
        make.width.equalTo(self.freeTrialContainerView.width).offset(-60.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.freeTrialContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(78.0f);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.equalTo(self.view.height).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.bounds));
    }];

}

#pragma mark - Button Actions 

- (void)oneTapButtonTapped {
   [self tryCoachForFree];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HHBanner *banner = self.banners[index];
    if ([banner.targetURL length] > 0) {
        [self openWebPage:[NSURL URLWithString:banner.targetURL]];
    }
    
}

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.title = @"哈哈学车";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
   
}

- (void)tryCoachForFree {
    NSString *urlString = [[HHFreeTrialUtility sharedManager] buildFreeTrialURLStringWithCoachId:nil];
    [self openWebPage:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}


@end
