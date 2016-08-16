//
//  HHTestQuestionViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestQuestionViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "SwipeView.h"
#import "HHTestQuestionView.h"
#import "HHTestQuestionBottomBar.h"
#import "HHTestQuestionManager.h"
#import "HHWebViewController.h"

@interface HHTestQuestionViewController () <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic) TestMode currentTestMode;
@property (nonatomic) CourseMode currentCourseMode;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *questionViews;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) HHTestQuestionBottomBar *botBar;

@end

@implementation HHTestQuestionViewController

- (instancetype)initWithTestMode:(TestMode)testMode courseMode:(CourseMode)courseMode questions:(NSMutableArray *)questions startIndex:(NSInteger)startIndex {
    self = [super init];
    if (self) {
        self.currentTestMode = testMode;
        self.currentCourseMode = courseMode;
        self.currentIndex = startIndex;
        self.questions = questions;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionViews = [NSMutableArray array];
    
    switch (self.currentTestMode) {
        case TestModeOrder:{
            self.title = @"顺序练题";
        } break;
            
        case TestModeRandom: {
            self.title = @"随机练题";
        } break;
            
        case TestModeSimu: {
            self.title = @"模拟考试";
        } break;
            
        case TestModeFavQuestions: {
            self.title = @"我的题集";
        } break;
            
        default:
            break;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    [self initSubviews];
}

- (void)initSubviews {
    __weak HHTestQuestionViewController *weakSelf = self;
    
    self.swipeView = [[SwipeView alloc] init];
    self.swipeView.pagingEnabled = YES;
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    [self.view addSubview:self.swipeView];
    [self.swipeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-60.0f);
    }];
    
    self.botBar = [[HHTestQuestionBottomBar alloc] init];
    self.botBar.prevAction = ^() {
        if (weakSelf.currentIndex <= 0) {
            return ;
        }
        weakSelf.currentIndex = self.currentIndex - 1;
        [weakSelf pageChangedTo:weakSelf.currentIndex];
        [weakSelf.swipeView scrollToPage:weakSelf.currentIndex duration:0.5f];
        if (weakSelf.currentTestMode == TestModeOrder) {
            [weakSelf saveOrderTestIndex];
        }
        
    };
    self.botBar.nextAction = ^() {
        if (weakSelf.currentIndex >= weakSelf.questions.count) {
            return ;
        }
        weakSelf.currentIndex = self.currentIndex + 1;
        [weakSelf pageChangedTo:weakSelf.currentIndex];
        [weakSelf.swipeView scrollToPage:weakSelf.currentIndex duration:0.5f];
        [weakSelf saveOrderTestIndex];
        if (weakSelf.currentTestMode == TestModeOrder) {
            [weakSelf saveOrderTestIndex];
        }
    };
    self.botBar.infoLabel.attributedText = [self buildAttrString];
    [self.view addSubview:self.botBar];
    [self.botBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.swipeView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(60.0f);
    }];
    
    if (self.currentTestMode == TestModeOrder) {
        [self.swipeView scrollToPage:self.currentIndex duration:0.5f];
    }
    
    
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -SwipeView methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.questions.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    __weak HHTestQuestionViewController *weakSelf = self;
    BOOL favorated = [[HHTestQuestionManager sharedManager] isFavoratedQuestion:self.questions[index] courseMode:self.currentCourseMode];
    __weak HHTestQuestionView *weakView;
    HHTestQuestionView *questionView;
    if (view) {
        questionView = (HHTestQuestionView *)view;
    } else {
        questionView = [[HHTestQuestionView alloc] init];
    }
    weakView = questionView;
    questionView.favBlock = ^(HHQuestion *question) {
        [weakView setupFavViews:[[HHTestQuestionManager sharedManager] favorateQuestion:question courseMode:weakSelf.currentCourseMode] testMode:weakSelf.currentTestMode];
        if (weakSelf.currentTestMode == TestModeFavQuestions) {
            [weakSelf removeFavQuestion:question];
        }
    };
    questionView.explaBlock = ^(NSURL *url) {
        HHWebViewController *vc = [[HHWebViewController alloc] initWithURL:url];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [questionView fillUpViewWithQuestion:self.questions[index] favorated:favorated testMode:self.currentTestMode];
    return questionView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.swipeView.bounds.size;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView {
    [self pageChangedTo:swipeView.currentPage];
    self.currentIndex = swipeView.currentPage;
    if (self.currentTestMode == TestModeOrder) {
        [self saveOrderTestIndex];
    }
}

- (NSMutableAttributedString *)buildAttrString {
    if(self.questions.count == 0) {
        self.currentIndex = -1;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/", self.currentIndex + 1] attributes:@{NSForegroundColorAttributeName : [UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.questions.count] attributes:@{NSForegroundColorAttributeName : [UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    [string appendAttributedString:string2];
    return string;
}

- (void)pageChangedTo:(NSInteger)currentPage {
    self.currentIndex = currentPage;
    self.botBar.infoLabel.attributedText = [self buildAttrString];
}

- (void)saveOrderTestIndex {
    if (self.currentTestMode == TestModeOrder) {
        [[HHTestQuestionManager sharedManager] saveOrderTestIndexWithCourseMode:self.currentCourseMode index:self.currentIndex];
    }
}

- (void)removeFavQuestion:(HHQuestion *)question {
    [self.questions removeObject:question];
    [self.swipeView reloadData];
    self.botBar.infoLabel.attributedText = [self buildAttrString];
}

@end
