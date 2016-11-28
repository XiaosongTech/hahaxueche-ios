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

@interface HHTestStartViewController ()

@property (nonatomic, strong) HMSegmentedControl *segControl;

@property (nonatomic, strong) HHTestView *orderTestView;
@property (nonatomic, strong) HHTestView *simuTestView;
@property (nonatomic, strong) HHTestView *randTestView;
@property (nonatomic, strong) HHTestView *myQuestionView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KLCPopup *popup;

@end

@implementation HHTestStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线题库";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
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

    [self makeConstraints];
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
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.myQuestionView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];

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
    if (![HHStudentStore sharedInstance].currentStudent.studentId) {
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
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
