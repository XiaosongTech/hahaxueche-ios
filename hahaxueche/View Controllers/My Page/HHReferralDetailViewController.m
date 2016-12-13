//
//  HHReferralDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferralDetailViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHReferreeCell.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentService.h"
#import "HHReferrals.h"
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+EmptyDataSet.h"
#import "HHStudentStore.h"
#import "NSNumber+HHNumber.h"
#import "HHWithdrawViewController.h"

static NSString *const kCellId = @"kCellId";

@interface HHReferralDetailViewController() <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHReferrals *referrals;
@property (nonatomic, strong) NSMutableArray *referralsArray;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *withdrawButton;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;
@property (nonatomic, strong) HHStudent *student;

@end

@implementation HHReferralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.student = [HHStudentStore sharedInstance].currentStudent;
    self.title = @"推荐有奖";
    self.referralsArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self.view addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"可提现";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.topView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor whiteColor];
    self.valueLabel.text = [self.student.bonusBalance generateMoneyString];
    
    self.valueLabel.font = [UIFont systemFontOfSize:28.0f];
    [self.topView addSubview:self.valueLabel];
    
    self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
    [self.withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.withdrawButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.withdrawButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    self.withdrawButton.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    [self.withdrawButton addTarget:self action:@selector(showWithdrawVC) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.withdrawButton];

    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHReferreeCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] fetchReferralsWithCompletion:^(HHReferrals *referralsObject, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            self.referralsArray = [NSMutableArray arrayWithArray:self.referrals.referrals];
            self.referrals = referralsObject;
            [self.tableView reloadData];
        }
    }];
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.refreshHeader setTitle:@"下拉更新" forState:MJRefreshStateIdle];
    [self.refreshHeader setTitle:@"下拉更新" forState:MJRefreshStatePulling];
    [self.refreshHeader setTitle:@"正在刷新列表" forState:MJRefreshStateRefreshing];
    self.refreshHeader.stateLabel.textColor = [UIColor HHLightTextGray];
    self.refreshHeader.automaticallyChangeAlpha = YES;
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = self.refreshHeader;
    
    self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.loadMoreFooter setTitle:@"加载更多记录" forState:MJRefreshStateIdle];
    [self.loadMoreFooter setTitle:@"正在加载更多记录" forState:MJRefreshStateRefreshing];
    [self.loadMoreFooter setTitle:@"没有更多记录" forState:MJRefreshStateNoMoreData];
    [self.loadMoreFooter setHidden: YES];
    self.loadMoreFooter.automaticallyRefresh = NO;
    self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
    self.tableView.mj_footer = self.loadMoreFooter;
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5.0f);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];

    [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(30.0f);
        make.right.equalTo(self.topView.right).offset(-20.0f);
        make.width.mas_equalTo(60.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData {
    [[HHStudentService sharedInstance] fetchReferralsWithCompletion:^(HHReferrals *referralsObject, NSError *error) {
        [self.refreshHeader endRefreshing];
        if (!error) {
            self.referralsArray = [NSMutableArray arrayWithArray:self.referrals.referrals];
            self.referrals = referralsObject;
            [self.tableView reloadData];
        }
    }];
    
    [[HHStudentService sharedInstance] fetchStudentWithId:self.student.studentId completion:^(HHStudent *student, NSError *error) {
        if (student) {
            [HHStudentStore sharedInstance].currentStudent = student;
            self.student = student;
            self.valueLabel.text = [self.student.bonusBalance generateMoneyString];
        }
    }];
}

- (void)loadMoreData {
    [[HHStudentService sharedInstance] fetchMoreReferralsWithURL:self.referrals.nextPage completion:^(HHReferrals *referralsObject, NSError *error) {
        [self.loadMoreFooter endRefreshing];
        if (!error) {
            [self.referralsArray addObjectsFromArray:self.referrals.referrals];
            self.referrals = referralsObject;
            [self.tableView reloadData];
        }
    }];
}

- (void)setReferrals:(HHReferrals *)referrals {
    _referrals = referrals;
    if (!self.referrals.nextPage) {
        if ([self.referralsArray count]) {
            [self.loadMoreFooter setHidden:NO];
        } else {
            [self.loadMoreFooter setHidden:YES];
        }
        [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
    } else {
        [self.loadMoreFooter setHidden:NO];
        [self.loadMoreFooter setState:MJRefreshStateIdle];
    }
}


#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHReferreeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHReferral *referral = self.referralsArray[indexPath.row];
    [cell setupCellWithReferral:referral];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.referralsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSMutableAttributedString alloc] initWithString:@"您还木有推荐的小伙伴, 快去分享学车大礼包给好友, 赢取无上限现金奖励!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showWithdrawVC {
    HHWithdrawViewController *vc = [[HHWithdrawViewController alloc] initWithAvailableAmount:self.student.bonusBalance];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
