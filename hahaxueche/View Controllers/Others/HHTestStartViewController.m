//
//  HHTestStartViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestStartViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HMSegmentedControl.h"
#import "HHTestView.h"
#import "HHTestQuestionViewController.h"
#import "HHTestSimuLandingViewController.h"
#import "HHReferralShareView.h"
#import "HHPopupUtility.h"
#import "HHStudentStore.h"
#import "HHReferFriendsViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCourseInsuranceView.h"
#import "HHIntroViewController.h"
#import "HHStudentService.h"
#import "HHTestScore.h"
#import "HHConstantsStore.h"
#import "HHLoadingViewUtility.h"
#import "HHShareView.h"
#import "HHPopupUtility.h"
#import "HHSocialMediaShareUtility.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHWebViewController.h"
#import "HHGuardCardViewController.h"


@interface HHTestStartViewController ()

@property (nonatomic, strong) HMSegmentedControl *segControl;

@property (nonatomic, strong) HHTestView *orderTestView;
@property (nonatomic, strong) HHTestView *simuTestView;
@property (nonatomic, strong) HHTestView *randTestView;
@property (nonatomic, strong) HHTestView *myQuestionView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHCourseInsuranceView *insuranceCardView;
@property (nonatomic, strong) NSMutableArray *validScores;

@end

@implementation HHTestStartViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"科一保过";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHStudentService sharedInstance] getSimuTestResultWithCompletion:^(NSArray *results) {
             [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            self.validScores = [NSMutableArray arrayWithArray:results];
            [self initSubviews];
        }];
    } else {
        [self initSubviews];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"scoreAdded" object:nil];
    
}

- (void)initSubviews {
    __weak HHTestStartViewController *weakSelf = self;
    self.scrollView = [[UIScrollView  alloc] init];
    self.scrollView.backgroundColor = [UIColor HHBackgroundGary];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    self.segControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"科目一", @"科目四"]];
    self.segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segControl.selectionIndicatorHeight = 4.0f/[UIScreen mainScreen].scale;
    self.segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segControl.selectionIndicatorColor = [UIColor HHOrange];
    self.segControl.backgroundColor = [UIColor whiteColor];
    self.segControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHLightestTextGray], NSFontAttributeName: [UIFont systemFontOfSize:16.0f]};
    self.segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHOrange], NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    [self.scrollView addSubview:self.segControl];
    
    NSNumber *course = @(1);
    if (self.segControl.selectedSegmentIndex == 1) {
        course = @(4);
    }
    self.orderTestView = [[HHTestView alloc] initWithTitle:@"顺序练题" image:[UIImage imageNamed:@"ic_question_turn"] showVerticalLine:YES showBottomLine:YES];
    self.orderTestView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeOrder];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:online_test_page_order_tapped attributes:@{@"course":course}];
    };
    [self.scrollView addSubview:self.orderTestView];
    
    self.randTestView = [[HHTestView alloc] initWithTitle:@"随机练题" image:[UIImage imageNamed:@"ic_question_random"] showVerticalLine:NO showBottomLine:YES];
    self.randTestView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeRandom];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:online_test_page_random_tapped attributes:@{@"course":course}];
    };
    [self.scrollView addSubview:self.randTestView];
    
    self.simuTestView = [[HHTestView alloc] initWithTitle:@"模拟考试" image:[UIImage imageNamed:@"ic_question_exam"] showVerticalLine:YES showBottomLine:NO];
    self.simuTestView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeSimu];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:online_test_page_simu_tapped attributes:@{@"course":course}];
    };
    [self.scrollView addSubview:self.simuTestView];
    
    self.myQuestionView = [[HHTestView alloc] initWithTitle:@"我的题库" image:[UIImage imageNamed:@"ic_question_lib"] showVerticalLine:NO showBottomLine:NO];
    self.myQuestionView.tapBlock = ^() {
        [weakSelf showTestVCWithMode:TestModeFavQuestions];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:online_test_page_my_lib_tapped attributes:@{@"course":course}];
    };
    [self.scrollView addSubview:self.myQuestionView];
    
    [self buildCardView];
    [self makeConstraints];
}

- (void)buildCardView {
    if (self.insuranceCardView) {
        [self.insuranceCardView removeFromSuperview];
    }
    __weak HHTestStartViewController *weakSelf = self;
    UIImage *cardImage;
    NSString *text;
    NSString *buttonTitle;
    BOOL showSlotView;
    
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        cardImage = [UIImage imageNamed:@"protectioncard_noget"];
        text = @"快去领取科一科四保过卡哟~";
        buttonTitle = @"领取保过卡";
        showSlotView = NO;
        
        
    } else {
        cardImage = [UIImage imageNamed:@"protectioncard_get"];
        if ([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
            if (self.validScores.count > 0) {
                text = [NSString stringWithFormat:@"您已在%ld次模拟考试中获得90分以上的成绩.", self.validScores.count];
                buttonTitle = @"晒成绩";
                showSlotView = YES;
            } else {
                text = @"您还未在模拟考试中获得90分以上的成绩.";
                buttonTitle = @"去模拟";
                showSlotView = YES;
            }
            
        } else {
            text = @"快去报名~不通过立即现金赔付!";
            buttonTitle = @"去报名";
            showSlotView = NO;
        }
    }
    self.insuranceCardView = [[HHCourseInsuranceView alloc] initWithImage:cardImage count:@(self.validScores.count) text:text buttonTitle:buttonTitle showSlotView:showSlotView peopleCount:[HHConstantsStore sharedInstance].constants.registeredCount];
    self.insuranceCardView.cardActionBlock = ^() {
        HHGuardCardViewController *vc = [[HHGuardCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.insuranceCardView.buttonActionBlock = ^() {
        if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
            HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://m.hahaxueche.com/share/bao-guo-ka?promo_code=553353"]];
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        } else {
            if([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
                if (weakSelf.validScores.count > 0) {
                    [weakSelf showShareView];
                } else {
                    weakSelf.segControl.selectedSegmentIndex = 0;
                    [weakSelf showTestVCWithMode:TestModeSimu];
                }
            } else {
                [weakSelf dismissVC];
                if (weakSelf.dismissBlock) {
                    weakSelf.dismissBlock();
                }
            }
            
        }
    };
    [self.scrollView addSubview:self.insuranceCardView];
    [self.insuranceCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myQuestionView.bottom).offset(10.0f);
        make.width.equalTo(self.scrollView.width);
        make.left.equalTo(self.scrollView.right);
        if ([[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray count] > 0) {
            make.height.mas_equalTo(340.0f);
        } else {
            make.height.mas_equalTo(290.0f);
        }
        
    }];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.insuranceCardView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:online_test_page_viewed attributes:nil];
}

- (void)makeConstraints {
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.equalTo(self.view.height);
    }];
    
    
    [self.segControl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
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
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.insuranceCardView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];

}

- (void)showTestVCWithMode:(TestMode)mode {
    __weak HHTestStartViewController *weakSelf = self;
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
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        return;
    }
    __weak HHTestStartViewController *weakSelf = self;
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

- (void)dismissVC {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateView:(NSNotification *)notification {
    HHTestScore *score = notification.userInfo[@"score"];
    [self.validScores addObject:score];
    [self buildCardView];
}

- (void)showShareView {
    HHTestScore *bestScore = [self.validScores firstObject];
    for (HHTestScore *score in self.validScores) {
        if (score.score.integerValue > bestScore.score.integerValue) {
            bestScore = score;
        }
    }
    __weak HHTestStartViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        if (selecteItem == SocialMediaMessage) {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        }
        [[HHSocialMediaShareUtility sharedInstance] shareTestScore:bestScore shareType:selecteItem inVC:weakSelf resultCompletion:nil];
    };
    
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}



@end
