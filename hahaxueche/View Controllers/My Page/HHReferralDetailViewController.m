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

static NSString *const kCellId = @"kCellId";

@interface HHReferralDetailViewController() <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHReferrals *referrals;
@property (nonatomic, strong) NSMutableArray *referralsArray;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;

@end

@implementation HHReferralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐有奖";
    self.referralsArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
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
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
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
    return [[NSMutableAttributedString alloc] initWithString:@"您还木有推荐的小伙伴, 快去分享专自己的专属二维码, 赢取无上限现金奖励!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
