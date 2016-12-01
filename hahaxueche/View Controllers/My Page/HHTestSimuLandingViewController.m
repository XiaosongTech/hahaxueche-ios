//
//  HHTestSimuLandingViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestSimuLandingViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import <UIImageView+WebCache.h>
#import "HHStudentStore.h"
#import "HHTestSimuInfoView.h"
#import "HHTestQuestionViewController.h"
#import "HHTestQuestionManager.h"

@interface HHTestSimuLandingViewController ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) HHTestSimuInfoView *firstView;
@property (nonatomic, strong) HHTestSimuInfoView *secView;
@property (nonatomic, strong) HHTestSimuInfoView *thirdView;
@property (nonatomic, strong) HHTestSimuInfoView *forthView;

@property (nonatomic, strong) UILabel *ruleLabel;
@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HHTestSimuLandingViewController

- (instancetype)initWithCourseMode:(CourseMode)courseMode {
    self = [super init];
    if (self) {
        self.courseMode = courseMode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHOrange];
    self.title = @"模拟考试";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 35.0f;
    self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarView.layer.borderWidth = 2.0f;
    [self.scrollView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.scrollView addSubview:self.nameLabel];
    
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[HHStudentStore sharedInstance].currentStudent.avatarURL] placeholderImage:[UIImage imageNamed:@"ic_mypage_ava"]];
        self.nameLabel.text = [HHStudentStore sharedInstance].currentStudent.name;
    } else {
        self.avatarView.image = [UIImage imageNamed:@"ic_mypage_ava"];
        self.nameLabel.text = @"未登录";
    }
    
    NSString *examMin = @"45分钟";
    NSString *courseString = @"科目一";
    NSString *ruleString = @"计分规则:模拟考试下不能修改答案, 每答对一题得一分, 合格标准为90分, 答题时间45分钟.";
    if (self.courseMode == CourseMode4) {
        examMin = @"30分钟";
        courseString = @"科目四";
        ruleString = @"计分规则:模拟考试下不能修改答案, 每答对一题得两分, 合格标准为90分, 答题时间30分钟.";
    }

    
    self.firstView = [[HHTestSimuInfoView alloc] initWithTitle:@"考试时间" value:examMin showBotLine:YES];
    [self.scrollView addSubview:self.firstView];
    
    self.secView = [[HHTestSimuInfoView alloc] initWithTitle:@"合格标准" value:@"90分" showBotLine:YES];
    [self.scrollView addSubview:self.secView];
    
    self.thirdView = [[HHTestSimuInfoView alloc] initWithTitle:@"出题规则" value:@"交管局出题规则" showBotLine:YES];
    [self.scrollView addSubview:self.thirdView];
    
    self.forthView = [[HHTestSimuInfoView alloc] initWithTitle:@"考试科目" value:courseString showBotLine:NO];
    [self.scrollView addSubview:self.forthView];
    
    self.ruleLabel = [[UILabel alloc] init];
    self.ruleLabel.text = ruleString;
    self.ruleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.ruleLabel.numberOfLines = 0;
    self.ruleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.scrollView addSubview:self.ruleLabel];
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startButton setTitle:@"开始考试" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    self.startButton.backgroundColor = [UIColor whiteColor];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.startButton.layer.masksToBounds = YES;
    self.startButton.layer.cornerRadius = 25.0f;
    [self.startButton addTarget:self action:@selector(startTest) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.startButton];
    
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
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.bottom).offset(15.0f);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [self.firstView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(20.0f);
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
    
    [self.thirdView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secView.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(250.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.forthView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.bottom);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.mas_equalTo(250.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.ruleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forthView.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-80.0f);
    }];
    
    [self.startButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ruleLabel.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-80.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.startButton
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-30.0f]];
    
    
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startTest {
    NSMutableArray *questions = [[HHTestQuestionManager sharedManager] generateQuestionsWithMode:TestModeSimu courseMode:self.courseMode];
    HHTestQuestionViewController *vc = [[HHTestQuestionViewController alloc] initWithTestMode:TestModeSimu courseMode:self.courseMode questions:questions startIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
