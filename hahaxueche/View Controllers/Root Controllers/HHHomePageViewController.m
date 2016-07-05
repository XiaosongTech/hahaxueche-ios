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

static NSString *const kAboutStudentLink = @"http://staging.hahaxueche.net/#/student";
static NSString *const kAboutCoachLink = @"http://staging.hahaxueche.net/#/coach";


@interface HHHomePageViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) HHHomePageTapView *leftView;
@property (nonatomic, strong) HHHomePageTapView *rightView;
@property (nonatomic, strong) UIButton *freeTryButton;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) NSArray *banners;

@end

@implementation HHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈学车";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isShowed = [defaults objectForKey:@"showedBonusPopoup"];

    if (![isShowed boolValue] && [[HHStudentStore sharedInstance].currentStudent.byReferal boolValue] && [HHStudentStore sharedInstance].currentStudent.studentId && ![[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray count]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 8.0f;
        NSNumber *refereeBonus = [[[HHConstantsStore sharedInstance] getAuthedUserCity] getRefereeBonus];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元已经打进您的账户余额, 在支付过程中, 系统会自动减现%@元报名费.", [refereeBonus generateMoneyString], [refereeBonus generateMoneyString]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
        
        __weak HHHomePageViewController *weakSelf = self;
        HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 280.0f) title:@"注册成功!" subTitle:[NSString stringWithFormat:@"恭喜您获得%@元学车券!",[refereeBonus generateMoneyString] ] info:attributedString];
        view.cancelBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        self.popup = [HHPopupUtility createPopupWithContentView:view];
        [HHPopupUtility showPopup:self.popup];
        [defaults setObject:@(1) forKey:@"showedBonusPopoup"];
    }
}

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
    [self.view addSubview:self.bannerView];
    
    self.leftView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_hahahere"] title:@"关于小哈" subTitle:@"点击了解"];
    self.leftView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kAboutStudentLink]];
    };
    [self.view addSubview:self.leftView];
    
    self.rightView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_coachhere"] title:@"关于教练" subTitle:@"点击了解"];
    self.rightView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kAboutCoachLink]];
    };
    [self.view addSubview:self.rightView];
    
    self.freeTryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.freeTryButton setTitle:@"免费试学" forState:UIControlStateNormal];
    [self.freeTryButton setBackgroundColor:[UIColor HHOrange]];
    [self.freeTryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.freeTryButton addTarget:self action:@selector(oneTapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.freeTryButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.view addSubview:self.freeTryButton];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(CGRectGetHeight(self.view.bounds) - 300.0f);
    }];
    
    [self.leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom).offset(15.0f);
        make.left.equalTo(self.view.left).offset(15.0f);
        make.width.mas_equalTo((CGRectGetWidth(self.view.bounds) - 15.0f * 3)/2.0f);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom).offset(15.0f);
        make.left.equalTo(self.leftView.right).offset(15.0f);
        make.width.mas_equalTo((CGRectGetWidth(self.view.bounds) - 15.0f * 3)/2.0f);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.freeTryButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftView.bottom).offset(20.0f);
        make.left.equalTo(self.view.left).offset(15.0f);
        make.width.equalTo(self.view.width).offset(-30.0f);
        make.height.mas_equalTo(75.0f);
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
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
   
}

- (void)tryCoachForFree {
    NSString *urlBase = @"http://m.hahaxueche.com/free_trial";
    HHStudent *student = [HHStudentStore sharedInstance].currentStudent;
    NSString *paramString;
    NSString *url;
    if(student.studentId) {
        paramString = [NSString stringWithFormat:@"?name=%@&phone=%@&city_id=%@", student.name, student.cellPhone, [student.cityId stringValue]];
        url = [NSString stringWithFormat:@"%@%@", urlBase, paramString];
        [self openWebPage:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        [self openWebPage:[NSURL URLWithString:urlBase]];
    }
    
}


@end
