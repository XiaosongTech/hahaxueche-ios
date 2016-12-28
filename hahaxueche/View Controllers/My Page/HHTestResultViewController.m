//
//  HHTestResultViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestResultViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import <UIImageView+WebCache.h>
#import "HHStudentStore.h"
#import "HHTestSimuInfoView.h"
#import "HHTestQuestionViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHReferralShareView.h"
#import "HHPopupUtility.h"
#import "HHStudentService.h"

@interface HHTestResultViewController ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) HHTestSimuInfoView *firstView;
@property (nonatomic, strong) HHTestSimuInfoView *secView;

@property (nonatomic, strong) UIButton *startAgainButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *checkWrongQuestionsButton;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic) NSInteger qualifiedCount;
@property (nonatomic) NSInteger score;

@end

@implementation HHTestResultViewController

- (instancetype)initWithCorrectQuestions:(NSMutableArray *)correctQuestions min:(NSInteger)min courseMode:(CourseMode)courseMode wrongQuestions:(NSMutableArray *)wrongQuestions {
    self = [super init];
    if (self) {
        self.correctQuestions = correctQuestions;
        self.wrongQuestions = wrongQuestions;
        self.min = min;
        self.courseMode = courseMode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor HHOrange];
    self.title = @"模拟考试";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:nil action:nil target:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 35.0f;
    self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarView.layer.borderWidth = 2.0f;
    [self.scrollView addSubview:self.avatarView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.scrollView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.scrollView addSubview:self.subTitleLabel];
    
    if (self.courseMode == CourseMode4) {
        self.qualifiedCount = 45;
        self.score = self.correctQuestions.count * 2.0;
    } else {
        self.qualifiedCount = 90;
        self.score = self.correctQuestions.count;
    }

    if (self.correctQuestions.count < self.qualifiedCount) {
        self.titleLabel.text = @"继续努力!";
        self.subTitleLabel.text = @"本次模拟考试不及格, 联系后请继续尝试!";
    } else {
        self.titleLabel.text = @"通过啦!";
        self.subTitleLabel.text = @"本次模拟考试通过, 下面的驾驶学习继续努力!";
    }
    
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[HHStudentStore sharedInstance].currentStudent.avatarURL] placeholderImage:[UIImage imageNamed:@"ic_mypage_ava"]];
    
    self.firstView = [[HHTestSimuInfoView alloc] initWithTitle:@"考试用时" value:[NSString stringWithFormat:@"%ld分钟", (long)self.min] showBotLine:YES];
    [self.scrollView addSubview:self.firstView];
    
    self.secView = [[HHTestSimuInfoView alloc] initWithTitle:@"考试分数" value:[NSString stringWithFormat: @"%ld", (long)self.score] showBotLine:NO];
    [self.scrollView addSubview:self.secView];
    
    
    self.startAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startAgainButton setTitle:@"继续挑战" forState:UIControlStateNormal];
    [self.startAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startAgainButton.backgroundColor = [UIColor HHOrange];
    self.startAgainButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.startAgainButton.layer.masksToBounds = YES;
    self.startAgainButton.layer.cornerRadius = 25.0f;
    self.startAgainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.startAgainButton.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    [self.startAgainButton addTarget:self action:@selector(startTest) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.startAgainButton];
    
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    self.backButton.backgroundColor = [UIColor whiteColor];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.backButton.layer.masksToBounds = YES;
    self.backButton.layer.cornerRadius = 25.0f;
    [self.backButton addTarget:self action:@selector(backToHomePageVC) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.backButton];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"查看错题" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    self.checkWrongQuestionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkWrongQuestionsButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self.checkWrongQuestionsButton addTarget:self action:@selector(checkWrongQuestions) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.checkWrongQuestionsButton];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(70.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.bottom).offset(15.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(10.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.firstView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(250.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.secView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(250.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    
    [self.startAgainButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secView.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-80.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startAgainButton.bottom).offset(15.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-80.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.checkWrongQuestionsButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.bottom).offset(10.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.checkWrongQuestionsButton
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-30.0f]];
    
    [self showReferPopup];
    [[HHStudentService sharedInstance] saveTestScore:@(self.score) course:@(self.courseMode) completion:^(HHTestScore *score) {
        if (score.score.integerValue >= 90) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreAdded" object:nil userInfo:@{@"score":score}];
        }
        
    }];
    
    
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkWrongQuestions {
    HHTestQuestionViewController *vc = [[HHTestQuestionViewController alloc] initWithTestMode:TestModeWrongQuestions courseMode:self.courseMode questions:self.wrongQuestions startIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToHomePageVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startTest {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showReferPopup {
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        return;
    }
    __weak HHTestResultViewController *weakSelf = self;
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

@end
