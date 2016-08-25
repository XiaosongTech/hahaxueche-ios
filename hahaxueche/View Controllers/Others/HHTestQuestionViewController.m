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
#import "CountDown.h"
#import "HHTestResultViewController.h"

@interface HHTestQuestionViewController () <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic) TestMode currentTestMode;
@property (nonatomic) CourseMode currentCourseMode;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *questionViews;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger currentMin;

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) HHTestQuestionBottomBar *botBar;
@property (nonatomic, strong) NSMutableArray *wrongQuestions;
@property (nonatomic, strong) NSMutableArray *correctQuestions;
@property (nonatomic, strong) NSMutableArray *answeredQuestions;

@end

@implementation HHTestQuestionViewController

- (instancetype)initWithTestMode:(TestMode)testMode courseMode:(CourseMode)courseMode questions:(NSMutableArray *)questions startIndex:(NSInteger)startIndex {
    self = [super init];
    if (self) {
        self.currentTestMode = testMode;
        self.currentCourseMode = courseMode;
        self.currentIndex = startIndex;
        self.questions = questions;
        self.wrongQuestions = [NSMutableArray array];
        self.answeredQuestions = [NSMutableArray array];
        self.correctQuestions = [NSMutableArray array];
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
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_question_upexam"] action:@selector(finishTest) target:self];
            
            [self updateCountdown];
        } break;
            
        case TestModeFavQuestions: {
            self.title = @"我的题集";
        } break;
            
        case TestModeWrongQuestions: {
            self.title = @"查看错题";
        }
            
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
        if (weakSelf.currentIndex >= weakSelf.questions.count - 1) {
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
    
    questionView.answeredBlock = ^(HHQuestion *question) {
        if (![question isAnswerCorrect:question.userAnswers]) {
            [weakSelf.wrongQuestions addObject:question];
            if (![[HHTestQuestionManager sharedManager] isFavoratedQuestion:question courseMode:self.currentCourseMode]) {
                [[HHTestQuestionManager sharedManager] favorateQuestion:question courseMode:weakSelf.currentCourseMode];
            }
            
        } else {
            [weakSelf.correctQuestions addObject:question];
        }
        [weakSelf.answeredQuestions addObject:question];
        
        if (weakSelf.currentIndex == weakSelf.questions.count-1 && weakSelf.currentTestMode == TestModeSimu) {
            [weakSelf showResultVC];
        }
        
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

- (void)finishTest {
    __weak HHTestQuestionViewController *weakSelf = self;
    NSString *msg = [NSString stringWithFormat:@"您已经回答了%ld道题, 答错了%ld道题, 确认交卷吗?", self.answeredQuestions.count, self.wrongQuestions.count];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"交卷提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续做题" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showResultVC];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateCountdown {
    __weak HHTestQuestionViewController *weakSelf = self;
    CountDown *countDown = [[CountDown alloc] init];
    NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:45*60 -1];
    if (self.currentCourseMode == CourseMode4) {
        finishDate = [NSDate dateWithTimeIntervalSinceNow:30*60 -1];
    }
    [countDown countDownWithStratDate:[NSDate date] finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        if (minute == 0 && second == 0) {
            [weakSelf showResultVC];
            return;
        }
        weakSelf.currentMin = minute;
        self.title = [NSString stringWithFormat:@"模拟考试 %ld:%ld", minute, second];
    }];
}

- (void)showResultVC {
    NSInteger min = 45-self.currentMin;
    if (self.currentCourseMode == CourseMode4) {
        min = 30-self.currentMin;
    }
    HHTestResultViewController *vc = [[HHTestResultViewController alloc] initWithCorrectQuestions:self.correctQuestions min:min courseMode:self.currentCourseMode wrongQuestions:self.wrongQuestions];

    [self.navigationController pushViewController:vc animated:YES];
}

@end
