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
#import "HHEventView.h"
#import "HHEventsViewController.h"
#import "HMSegmentedControl.h"
#import "HHTestView.h"
#import "HHTestQuestionViewController.h"
#import "HHTestSimuLandingViewController.h"
#import "HHReferralShareView.h"

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

@property (nonatomic, strong) HHEventView *activityView1;
@property (nonatomic, strong) HHEventView *activityView2;
@property (nonatomic, strong) UIView *activitySectionView;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) HMSegmentedControl *segControl;
@property (nonatomic, strong) HHTestView *orderTestView;
@property (nonatomic, strong) HHTestView *simuTestView;
@property (nonatomic, strong) HHTestView *randTestView;
@property (nonatomic, strong) HHTestView *myQuestionView;

@property (nonatomic, strong) UIView *mailFromCEOView;

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
                [weakSelf fetchEvents];
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            [HHStudentStore sharedInstance].currentStudent.cityId = @(0);
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
            [weakSelf.popup show];
        } else {
            [self fetchEvents];
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
    
    [self buildEventViews];
    
    self.segControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"科目一", @"科目四"]];
    self.segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segControl.selectionIndicatorHeight = 4.0f/[UIScreen mainScreen].scale;
    self.segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segControl.selectionIndicatorColor = [UIColor HHOrange];
    self.segControl.backgroundColor = [UIColor whiteColor];
    self.segControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHLightestTextGray], NSFontAttributeName: [UIFont systemFontOfSize:16.0f]};
    self.segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHOrange], NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    [self.segControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.segControl];
    
    self.orderTestView = [[HHTestView alloc] initWithTitle:@"顺序练题" image:[UIImage imageNamed:@"ic_question_turn"] showVerticalLine:YES showBottomLine:YES];
    self.orderTestView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeOrder];
    };
    [self.scrollView addSubview:self.orderTestView];
    
    self.randTestView = [[HHTestView alloc] initWithTitle:@"随机练题" image:[UIImage imageNamed:@"ic_question_random"] showVerticalLine:NO showBottomLine:YES];
    self.randTestView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeRandom];
    };
    [self.scrollView addSubview:self.randTestView];
    
    self.simuTestView = [[HHTestView alloc] initWithTitle:@"模拟考试" image:[UIImage imageNamed:@"ic_question_exam"] showVerticalLine:YES showBottomLine:NO];
    self.simuTestView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeSimu];
    };
    [self.scrollView addSubview:self.simuTestView];
    
    self.myQuestionView = [[HHTestView alloc] initWithTitle:@"我的题库" image:[UIImage imageNamed:@"ic_question_lib"] showVerticalLine:NO showBottomLine:NO];
    self.myQuestionView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeFavQuestions];
    };
    [self.scrollView addSubview:self.myQuestionView];
    
    self.mailFromCEOView = [self buildMailView];
    [self.scrollView addSubview:self.mailFromCEOView];

    [self makeConstraints];
}

- (void)buildEventViews {
    __weak HHHomePageViewController *weakSelf = self;
    if ([self.events count] <= 0) {
        return;
    } else if ([self.events count] == 1) {
        [self buildActivitySectionView];
        
        self.activityView1 = [[HHEventView alloc] initWithEvent:[self.events firstObject] fullLine:YES];
        self.activityView1.eventBlock = ^(HHEvent *event) {
            HHWebViewController *vc = [[HHWebViewController alloc] initWithEvent:event];
            vc.title = event.title;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [self.scrollView addSubview:self.activityView1];
    } else if ([self.events count] > 1) {
        [self buildActivitySectionView];
        
        self.activityView1 = [[HHEventView alloc] initWithEvent:[self.events firstObject] fullLine:NO];
        self.activityView1.eventBlock = ^(HHEvent *event) {
            HHWebViewController *vc = [[HHWebViewController alloc] initWithEvent:event];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = event.title;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [self.scrollView addSubview:self.activityView1];
        
        self.activityView2 = [[HHEventView alloc] initWithEvent:self.events[1] fullLine:YES];
        self.activityView2.eventBlock = ^(HHEvent *event) {
            HHWebViewController *vc = [[HHWebViewController alloc] initWithEvent:event];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = event.title;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [self.scrollView addSubview:self.activityView2];
    }
    
}

- (void)fetchEvents {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] getCityEventsWithId:[HHStudentStore sharedInstance].currentStudent.cityId completion:^(NSArray *events, NSError *error) {
        if (!error) {
            self.events = events;
        }
        [self buildEventViews];
        [self makeConstraints];
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
    }];
}

- (void)makeConstraints {
    
    [self.bannerView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.equalTo(self.view.width).multipliedBy(4.0f/5.0f);
    }];
    
    [self.mailFromCEOView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.bottom.equalTo(self.onlineSupportView.bottom);
    }];
    
    [self.callSupportView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom);
        make.left.equalTo(self.mailFromCEOView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.onlineSupportView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.callSupportView.bottom);
        make.left.equalTo(self.mailFromCEOView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    if (self.activityView2) {
        [self.firstView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityView2.bottom).offset(10.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
            make.height.mas_equalTo(85.0f);
        }];
    } else if (self.activityView1) {
        [self.firstView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityView1.bottom).offset(10.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
            make.height.mas_equalTo(85.0f);
        }];
    } else {
        [self.firstView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.onlineSupportView.bottom).offset(10.0f);
            make.left.equalTo(self.scrollView.left);
            make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
            make.height.mas_equalTo(85.0f);
        }];
    }
    
    
    [self.secondView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.top);
        make.left.equalTo(self.firstView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.equalTo(self.firstView.height);
    }];
    
    [self.thirdView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.equalTo(self.firstView.height);
    }];
    
    
    [self.forthView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.top);
        make.left.equalTo(self.thirdView.right);
        make.width.equalTo(self.view).multipliedBy(1.0f/2.0f);
        make.height.equalTo(self.firstView.height);
    }];
    
    [self.freeTryButton remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freeTrialContainerView.centerY);
        make.centerX.equalTo(self.freeTrialContainerView.centerX);
        make.width.equalTo(self.freeTrialContainerView.width).offset(-60.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.freeTrialContainerView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mailFromCEOView.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(78.0f);
    }];
    
    if (self.activitySectionView) {
        [self.activitySectionView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freeTrialContainerView.bottom).offset(10.0f);
            make.width.equalTo(self.scrollView.width);
            make.left.equalTo(self.scrollView.left);
            make.height.mas_equalTo(50.0f);
        }];
    }
   
    
    if (self.activityView1) {
        [self.activityView1 remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activitySectionView.bottom);
            make.width.equalTo(self.scrollView.width);
            make.left.equalTo(self.scrollView.left);
            make.height.mas_equalTo(70.0f);
        }];

    }
    
    if (self.activityView2) {
        [self.activityView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityView1.bottom);
            make.width.equalTo(self.scrollView.width);
            make.left.equalTo(self.scrollView.left);
            make.height.mas_equalTo(70.0f);
        }];
    }
    
    [self.segControl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.bottom).offset(10.0f);
        make.width.equalTo(self.scrollView.width);
        make.left.equalTo(self.scrollView.left);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.orderTestView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segControl.bottom);
        make.width.equalTo(self.scrollView.width).multipliedBy(0.5f);
        make.left.equalTo(self.scrollView.left);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.randTestView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segControl.bottom);
        make.width.equalTo(self.scrollView.width).multipliedBy(0.5f);
        make.left.equalTo(self.orderTestView.right);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.simuTestView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderTestView.bottom);
        make.width.equalTo(self.scrollView.width).multipliedBy(0.5f);
        make.left.equalTo(self.scrollView.left);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.myQuestionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.randTestView.bottom);
        make.width.equalTo(self.scrollView.width).multipliedBy(0.5f);
        make.left.equalTo(self.simuTestView.right);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.equalTo(self.view.height).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.bounds));
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.myQuestionView
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

- (void)buildActivitySectionView {
    self.activitySectionView = [[UIView alloc] init];
    self.activitySectionView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"限时活动";
    label.textColor = [UIColor HHLightDarkTextGray];
    label.font = [UIFont systemFontOfSize:15.0f];
    [self.activitySectionView addSubview:label];
    
    if ([self.events count] > 2) {
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:[UIColor HHLightTextGray] forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [moreButton addTarget:self action:@selector(showMoreEvents) forControlEvents:UIControlEventTouchUpInside];
        [self.activitySectionView addSubview:moreButton];
        
        [moreButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.activitySectionView.centerY);
            make.right.equalTo(self.activitySectionView.right).offset(-15.0f);
        }];
    }
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHLightLineGray];
    [self.activitySectionView addSubview:line];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.activitySectionView.centerY);
        make.left.equalTo(self.activitySectionView.left).offset(15.0f);
    }];
    
    
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.activitySectionView.bottom);
        make.left.equalTo(self.activitySectionView.left);
        make.width.equalTo(self.activitySectionView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.scrollView addSubview:self.activitySectionView];
}

- (void)showMoreEvents {
    HHEventsViewController *vc = [[HHEventsViewController alloc] initWithEvents:self.events];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
}

- (void)showTestVCWithMode:(TestMode)mode {
    __weak HHHomePageViewController *weakSelf = self;
    if (mode == TestModeSimu) {
        HHTestSimuLandingViewController *vc = [[HHTestSimuLandingViewController alloc] initWithCourseMode:self.segControl.selectedSegmentIndex];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVC animated:YES completion:nil];
        return;
    }
    NSInteger startIndex = 0;
    if (mode == TestModeOrder) {
        startIndex = [[HHTestQuestionManager sharedManager] getOrderTestIndexWithCourseMode:self.segControl.selectedSegmentIndex];
    }
    NSMutableArray *questions = [[HHTestQuestionManager sharedManager] generateQuestionsWithMode:mode courseMode:self.segControl.selectedSegmentIndex];
    HHTestQuestionViewController *vc = [[HHTestQuestionViewController alloc] initWithTestMode:mode courseMode:self.segControl.selectedSegmentIndex questions:questions startIndex:startIndex];
    vc.hidesBottomBarWhenPushed = YES;
    if (mode == TestModeOrder || mode == TestModeRandom) {
        vc.dismissBlock = ^() {
            [weakSelf showReferPopup];
        };
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showReferPopup {
    if (![HHStudentStore sharedInstance].currentStudent.studentId) {
        return;
    }
    __weak HHHomePageViewController *weakSelf = self;
    HHReferralShareView *shareView = [[HHReferralShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, 300.0f)];
    shareView.cancelBlock = ^(){
        [weakSelf.popup dismiss:YES];
    };
    
    shareView.shareBlock = ^(){
        [weakSelf.popup dismiss:YES];
        
        HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [weakSelf presentViewController:navVC animated:YES completion:nil];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:shareView];
    self.popup.shouldDismissOnBackgroundTouch = NO;
    [HHPopupUtility showPopup:self.popup];
}


- (UIView *)buildMailView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_yourletter"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY).offset(-10.0f);
        make.centerX.equalTo(view.centerX);
        make.width.equalTo(view.width).offset(-10.0f);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请查收 >>";
    label.textColor = [UIColor HHOrange];
    label.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(15.0f);
        make.bottom.equalTo(view.bottom).offset(-10.0f);
    }];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:botLine];
    [botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left);
        make.width.equalTo(view.width);
        make.bottom.equalTo(view.bottom);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:rightLine];
    [rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.right);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.top.equalTo(view.top);
        make.height.equalTo(view.height);
    }];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMailPage)];
    [view addGestureRecognizer:rec];
    
    return view;
}

- (void)showMailPage {
    [self openWebPage:[NSURL URLWithString:@"http://m.hahaxueche.com/letter-for-customer"]];
}



@end
