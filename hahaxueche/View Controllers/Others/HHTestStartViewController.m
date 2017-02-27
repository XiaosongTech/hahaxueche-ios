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
#import "HHShareReferralView.h"
#import "HHInsuranceViewController.h"


@interface HHTestStartViewController ()

@property (nonatomic, strong) HMSegmentedControl *segControl;
@property (nonatomic, strong) HMSegmentedControl *segControlInsurance;

@property (nonatomic, strong) HHTestView *orderTestView;
@property (nonatomic, strong) HHTestView *simuTestView;
@property (nonatomic, strong) HHTestView *randTestView;
@property (nonatomic, strong) HHTestView *myQuestionView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHCourseInsuranceView *insuranceCardView;
@property (nonatomic, strong) UIView *insurancePeifubaoCardView;
@property (nonatomic, strong) NSMutableArray *validScores;

@end

@implementation HHTestStartViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"科一挂科险";
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
    self.segControl.verticalDividerWidth = 1.0f/[UIScreen mainScreen].scale;
    self.segControl.verticalDividerEnabled = YES;
    self.segControl.verticalDividerColor = [UIColor HHLightLineGray];
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
    
    self.segControlInsurance = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"挂科险", @"赔付宝"]];
    self.segControlInsurance.verticalDividerWidth = 1.0f/[UIScreen mainScreen].scale;
    self.segControlInsurance.verticalDividerEnabled = YES;
    self.segControlInsurance.verticalDividerColor = [UIColor HHLightLineGray];
    self.segControlInsurance.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segControlInsurance.selectionIndicatorHeight = 4.0f/[UIScreen mainScreen].scale;
    self.segControlInsurance.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segControlInsurance.selectionIndicatorColor = [UIColor HHOrange];
    self.segControlInsurance.backgroundColor = [UIColor whiteColor];
    self.segControlInsurance.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHLightestTextGray], NSFontAttributeName: [UIFont systemFontOfSize:16.0f]};
    self.segControlInsurance.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHOrange], NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    [self.segControlInsurance addTarget:self action:@selector(segControlInsuranceChanged) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.segControlInsurance];
    

    [self makeConstraints];
    [self buildCardView];

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
        text = @"快去领取科一科四挂科险哟~";
        buttonTitle = @"领取挂科险";
        showSlotView = NO;
        
        
    } else {
        cardImage = [UIImage imageNamed:@"protectioncard_get"];
        if (self.validScores.count > 0) {
            text = [NSString stringWithFormat:@"您已在%ld次模拟考试中获得90分以上的成绩.", self.validScores.count];
            buttonTitle = @"晒成绩";
            showSlotView = YES;
        } else {
            text = @"您还未在模拟考试中获得90分以上的成绩.";
            buttonTitle = @"去模拟";
            showSlotView = YES;
        }
    }
    self.insuranceCardView = [[HHCourseInsuranceView alloc] initWithImage:cardImage count:@(self.validScores.count) text:text buttonTitle:buttonTitle showSlotView:showSlotView peopleCount:[HHConstantsStore sharedInstance].constants.registeredCount];
    self.insuranceCardView.cardActionBlock = ^() {
        HHGuardCardViewController *vc = [[HHGuardCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.insuranceCardView.buttonActionBlock = ^() {
        if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
            HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://m.hahaxueche.com/share/bao-guo-ka?promo_code=328170"]];
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        } else {
            if (weakSelf.validScores.count > 0) {
                [weakSelf showShareView];
            } else {
                [weakSelf showTestVCWithMode:TestModeSimu];
            }
        }
    };
    [self.scrollView addSubview:self.insuranceCardView];
    [self.insuranceCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segControlInsurance.bottom);
        make.width.equalTo(self.scrollView.width);
        make.left.equalTo(self.scrollView.right);
        if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
            make.height.mas_equalTo(340.0f);
        } else {
            make.height.mas_equalTo(290.0f);
        }
        
    }];
    
    if (self.insurancePeifubaoCardView) {
        [self.insurancePeifubaoCardView removeFromSuperview];
    }
    self.insurancePeifubaoCardView = [self buildInsurancePeifubaoView];
    [self.scrollView addSubview:self.insurancePeifubaoCardView];
    [self.insurancePeifubaoCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segControlInsurance.bottom);
        make.width.equalTo(self.scrollView.width);
        make.left.equalTo(self.scrollView.right);
        make.height.mas_equalTo(300.0f);
    }];
    
    UIView *botView;
    if (self.segControlInsurance.selectedSegmentIndex == 0) {
        self.insuranceCardView.hidden = NO;
        self.insurancePeifubaoCardView.hidden = YES;
        botView = self.insuranceCardView;
    } else {
        self.insuranceCardView.hidden = YES;
        self.insurancePeifubaoCardView.hidden = NO;
        botView = self.insurancePeifubaoCardView;
    }
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:botView
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
    
    [self.segControlInsurance makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myQuestionView.bottom).offset(10.0f);
        make.width.equalTo(self.scrollView.width);
        make.left.equalTo(self.scrollView.right);
        make.height.mas_equalTo(50.0f);
    }];


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
    HHShareReferralView *view = [[HHShareReferralView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, 350.0f) text:@"现在分享给好友即可获得神秘礼品! 好友报名学车立减¥200! 快去分享吧~"];
    view.shareBlock = ^(){
        [HHPopupUtility dismissPopup:weakSelf.popup];
        HHReferFriendsViewController *referVC = [[HHReferFriendsViewController alloc] init];
        [weakSelf.navigationController setViewControllers:@[referVC] animated:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    self.popup.shouldDismissOnContentTouch = NO;
    self.popup.shouldDismissOnBackgroundTouch = YES;
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
    __weak HHTestStartViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        if (selecteItem == SocialMediaMessage) {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        }
        [[HHSocialMediaShareUtility sharedInstance] shareTestScoreWithType:selecteItem inVC:weakSelf resultCompletion:nil];
    };
    
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (void)segControlInsuranceChanged {
    [self buildCardView];
}

- (UIView *)buildInsurancePeifubaoView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"赔付宝是什么?";
    titleLabel.textColor = [UIColor HHTextDarkGray];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.top).offset(20.0f);
        make.centerX.equalTo(view.centerX);
    }];
    
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.text = @"赔付宝是一款由中国平安承保量身为哈哈学车定制的一份学车保险。提供了一站式驾考报名、选购保险、保险理赔申诉的平台，全面保障你的学车利益，赔付宝在购买后的次日生效，保期最长为一年";
    textLabel.textColor = [UIColor HHLightTextGray];
    textLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:textLabel];
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.bottom).offset(20.0f);
        make.centerX.equalTo(view.centerX);
        make.width.equalTo(view.width).offset(-40.0f);
    }];
    
    UIView *infoViewOne = [self buildInsuInfoViewWithTitle:@"单科补考费用最高赔付" text:@"¥500" showLine:YES];
    [view addSubview:infoViewOne];
    [infoViewOne makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left);
        make.width.equalTo(view.width).multipliedBy(1.0f/3.0f);
        make.height.mas_equalTo(80.0f);
        make.top.equalTo(textLabel.bottom).offset(20.0f);
    }];
    
    UIView *infoViewTwo = [self buildInsuInfoViewWithTitle:@"挂科5次赔付" text:@"¥5000" showLine:YES];
    [view addSubview:infoViewTwo];
    [infoViewTwo makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoViewOne.right);
        make.width.equalTo(view.width).multipliedBy(1.0f/3.0f);
        make.height.mas_equalTo(80.0f);
        make.top.equalTo(textLabel.bottom).offset(20.0f);
    }];
    
    UIView *infoViewThree = [self buildInsuInfoViewWithTitle:@"意外身故, 残疾最高赔付" text:@"¥10000" showLine:NO];
    [view addSubview:infoViewThree];
    [infoViewThree makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoViewTwo.right);
        make.width.equalTo(view.width).multipliedBy(1.0f/3.0f);
        make.height.mas_equalTo(80.0f);
        make.top.equalTo(textLabel.bottom).offset(20.0f);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"购¥120赔付宝" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor HHOrange];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(showInsuranceVC) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.width.mas_equalTo(160.0f);
        make.height.mas_equalTo(40.0f);
        make.top.equalTo(infoViewThree.bottom).offset(20.0f);
    }];
    
    return view;
}

- (UIView *)buildInsuInfoViewWithTitle:(NSString *)title text:(NSString *)text showLine:(BOOL)showLine {
    UIView *view = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor HHTextDarkGray];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.top).offset(10.0f);
        make.centerX.equalTo(view.centerX);
        make.width.equalTo(view.width).offset(-20.0f);
    }];
    
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    textLabel.textColor = [UIColor HHOrange];
    textLabel.font = [UIFont systemFontOfSize:16.0f];
    [view addSubview:textLabel];
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.bottom).offset(-10.0f);
        make.centerX.equalTo(view.centerX);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.top).offset(5.0f);
        make.right.equalTo(view.right);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.bottom.equalTo(view.bottom).offset(-5.0f);

    }];

    return view;
}

- (void)showInsuranceVC {
    HHInsuranceViewController *vc = [[HHInsuranceViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}



@end
