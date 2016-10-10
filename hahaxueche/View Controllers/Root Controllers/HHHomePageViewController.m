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
#import "HHEventsViewController.h"
#import "HHTestView.h"
#import "HHReferralShareView.h"
#import "UIView+EAFeatureGuideView.h"
#import "HHHomPageCardView.h"

static NSString *const kCoachLink = @"http://m.hahaxueche.com/share/best-coaches";
static NSString *const kDrivingSchoolLink = @"http://m.hahaxueche.com/share/best-coaches";
static NSString *const kAdvisorLink = @"http://m.hahaxueche.com/share/best-coaches";

static NSString *const kFeatureLink = @"http://activity.hahaxueche.com/share/features";
static NSString *const kStepsLink = @"http://activity.hahaxueche.com/share/steps";

static NSString *const kHomePageGuideKey = @"kHomePageGuideKey";

@interface HHHomePageViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) HHHomePageTapView *thirdView;
@property (nonatomic, strong) HHHomePageTapView *forthView;
@property (nonatomic, strong) UIImageView *freeTryImageView;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HHHomePageSupportView *callSupportView;
@property (nonatomic, strong) HHHomePageSupportView *onlineSupportView;
@property (nonatomic, strong) HHHomePageSupportView *eventView;
@property (nonatomic, strong) UIView *freeTrialContainerView;

@property (nonatomic, strong) HHHomPageCardView *drivingSchoolView;
@property (nonatomic, strong) HHHomPageCardView *coachView;
@property (nonatomic, strong) HHHomPageCardView *adviserView;

@end

@implementation HHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈学车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.banners = [[HHConstantsStore sharedInstance] getHomePageBanners];
    
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
                }
                [HHPopupUtility dismissPopup:weakSelf.popup];
                [weakSelf showUserGuideView];
                
            };
            [HHStudentStore sharedInstance].currentStudent.cityId = @(0);
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
            [weakSelf.popup show];
        }
    }
    
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
    if ([HHStudentStore sharedInstance].currentStudent.studentId) {
        [self showUserGuideView];
    }
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
    [strings addObject:@"已入住"];
    [strings addObject:@"所"];
    self.drivingSchoolView = [[HHHomPageCardView alloc] initWithIcon:[UIImage imageNamed:@"ic_cup"] title:@"入驻驾校 权威认证" subTitle:[self generateStringWithArray:strings number:@([[HHConstantsStore sharedInstance].constants.drivingSchoolCount integerValue] * 3.0f) color:[UIColor HHOrange]] bigIcon:[UIImage imageNamed:@"pic_xiaoha_school"] items:@[@"通过率高", @"训练场地规范", @"品牌口碑佳", @"权威驾校认证"] dotColor:[UIColor  HHOrange]];
    self.drivingSchoolView.tapAction = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kDrivingSchoolLink]];
    };
    [self.scrollView addSubview:self.drivingSchoolView];
    
    [strings removeAllObjects];
    [strings addObject:@"已签约"];
    [strings addObject:@"名"];
    self.coachView = [[HHHomPageCardView alloc] initWithIcon:[UIImage imageNamed:@"ic_medal_h"] title:@"签约教练 择优合作" subTitle:[self generateStringWithArray:strings number:@([[HHConstantsStore sharedInstance].constants.coachCount integerValue] * 10.0f) color:[UIColor HHLightBlue]] bigIcon:[UIImage imageNamed:@"pic_xiaoha_coach"] items:@[@"免费试学", @"价格透明", @"分阶段打款", @"灵活退学"] dotColor:[UIColor  HHLightBlue]];
    self.coachView.tapAction = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kCoachLink]];
    };
    [self.scrollView addSubview:self.coachView];
    
    [strings removeAllObjects];
    [strings addObject:@"已帮助学员"];
    [strings addObject:@"名"];
    self.adviserView = [[HHHomPageCardView alloc] initWithIcon:[UIImage imageNamed:@"ic_adviser"] title:@"学车顾问 全程无忧" subTitle:[self generateStringWithArray:strings number:@([[HHConstantsStore sharedInstance].constants.paidStudentCount integerValue] * 10.0f) color:[UIColor HHRed]] bigIcon:[UIImage imageNamed:@"pic_xiaoha_adviser"] items:@[@"量身推荐", @"智能预约", @"贴心售后", @"全程保障"] dotColor:[UIColor  HHRed]];
    self.adviserView.tapAction = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kAdvisorLink]];
    };
    [self.scrollView addSubview:self.adviserView];
    
    self.thirdView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_strengths"] title:@"我的优势" showRightLine:YES showBotLine:NO];
    self.thirdView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kFeatureLink]];
    };
    [self.scrollView addSubview:self.thirdView];
    
    self.forthView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_procedure"] title:@"学车流程" showRightLine:NO showBotLine:NO];
    self.forthView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kStepsLink]];
    };
    [self.scrollView addSubview:self.forthView];
    
    self.freeTrialContainerView = [[UIView alloc] init];
    self.freeTrialContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.freeTrialContainerView];
    
    self.freeTryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_free"]];
    self.freeTryImageView.userInteractionEnabled = YES;
    [self.freeTrialContainerView addSubview:self.freeTryImageView];
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tryCoachForFree)];
    [self.freeTryImageView addGestureRecognizer:tapRec];
    
    self.callSupportView = [[HHHomePageSupportView alloc] initWithImage:[UIImage imageNamed:@"ic_ask_call"] title:@"电话咨询" showRightLine:NO];
    self.callSupportView.actionBlock = ^() {
        [[HHSupportUtility sharedManager] callSupport];
    };
    [self.scrollView addSubview:self.callSupportView];
    
    self.onlineSupportView = [[HHHomePageSupportView alloc] initWithImage:[UIImage imageNamed:@"ic_ask_message"] title:@"在线客服" showRightLine:YES];
    self.onlineSupportView.actionBlock = ^() {
        [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
    };
    [self.scrollView addSubview:self.onlineSupportView];
    
    self.eventView = [[HHHomePageSupportView alloc] initWithImage:[UIImage imageNamed:@"ic_discount"] title:@"限时团购" showRightLine:YES];
    self.eventView.actionBlock = ^() {
        [weakSelf showEvents];
    };
    [self.scrollView addSubview:self.eventView];
    
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.equalTo(self.view.width).multipliedBy(2.0f/5.0f);
    }];

    [self.eventView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView).multipliedBy(1.0f/3.0f);
        make.height.mas_equalTo(55.0f);
    }];
    
    [self.callSupportView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.left.equalTo(self.onlineSupportView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/3.0f);
        make.height.mas_equalTo(55.0f);
    }];
    
    [self.onlineSupportView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.left.equalTo(self.eventView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/3.0f);
        make.height.mas_equalTo(55.0f);
    }];
    
   
    [self.freeTryImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freeTrialContainerView.centerY);
        make.centerX.equalTo(self.freeTrialContainerView.centerX);
    }];
    
    [self.freeTrialContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventView.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.drivingSchoolView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.freeTrialContainerView.bottom).offset(10.0f);
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
    
    [self.thirdView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.right);
        make.top.equalTo(self.adviserView.bottom).offset(10.0f);
        make.width.equalTo(self.scrollView.width).multipliedBy(1/2.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.forthView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdView.right);
        make.top.equalTo(self.adviserView.bottom).offset(10.0f);
        make.width.equalTo(self.scrollView.width).multipliedBy(1/2.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.equalTo(self.view.height).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.bounds));
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.forthView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];

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


- (void)showEvents {
    HHEventsViewController *vc = [[HHEventsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)showMailPage {
//    [self openWebPage:[NSURL URLWithString:@"http://m.hahaxueche.com/letter-for-customer"]];
//}

- (void)showUserGuideView {
    if ([UIView hasShowFeatureGuideWithKey:kHomePageGuideKey version:nil]) {
        return;
    }

    __weak HHHomePageViewController *weakSelf = self;
    EAFeatureItem *support = [[EAFeatureItem alloc] initWithFocusView:self.onlineSupportView  focusCornerRadius:0 focusInsets:UIEdgeInsetsMake(5.0f, 20.0f, -5.0f, -20.0f)];
    support.introduce = @"xiaoha.png";
    support.indicatorImageName = @"arrow";
    self.view.guideViewDismissCompletion = ^() {
        EAFeatureItem *coachTab = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(CGRectGetWidth(weakSelf.tabBarController.tabBar.frame)/4.0f, CGRectGetHeight(weakSelf.view.bounds)-CGRectGetHeight(weakSelf.tabBarController.tabBar.frame), CGRectGetWidth(weakSelf.tabBarController.tabBar.frame)/4.0f, CGRectGetHeight(weakSelf.tabBarController.tabBar.frame))  focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
        coachTab.introduce = @"lookingforcoach.png";
        coachTab.indicatorImageName = @"arrow";
        weakSelf.view.guideViewDismissCompletion = nil;
        [weakSelf.view showWithFeatureItems:@[coachTab] saveKeyName:@"coach" inVersion:nil];
        
    };
    [self.view showWithFeatureItems:@[support] saveKeyName:kHomePageGuideKey inVersion:nil];
    
}

- (NSMutableAttributedString *)generateStringWithArray:(NSArray *)strings number:(NSNumber *)number color:(UIColor *)color {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strings[0] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[number generateLargeNumberString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:color}];
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:strings[1] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    
    [string appendAttributedString:string2];
    [string appendAttributedString:string3];
    return string;
}






@end
