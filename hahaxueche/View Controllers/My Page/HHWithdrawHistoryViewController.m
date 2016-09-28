//
//  HHWithdrawHistoryViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHWithdrawHistoryViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHWithdrawHistoryCell.h"
#import "Masonry.h"
#import <MJRefresh/MJRefresh.h>
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentService.h"
#import "HHWithdraws.h"
#import "UIColor+HHColor.h"
#import "UIScrollView+EmptyDataSet.h"


typedef void (^HHWithdrawTransactionCompletion)();

static NSString *const kCellId = @"cellId";

@interface HHWithdrawHistoryViewController () <UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *withdraws;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;

@end

@implementation HHWithdrawHistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现历史";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
     self.withdraws = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[HHWithdrawHistoryCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
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
    
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [self refreshWithdrawsWithCompletion:^{
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
    }];
    
}


- (void)refreshWithdrawsWithCompletion:(HHWithdrawTransactionCompletion)completion {
    [[HHStudentService sharedInstance] fetchWithdrawTransactionWithCompletion:^(NSArray *withdraws, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            self.withdraws = [NSMutableArray arrayWithArray:withdraws];
            [self.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
       
    }];
}

#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHWithdrawHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHWithdraw *withdraw = self.withdraws[indexPath.row];
    [cell setupCellWithWithdraw:withdraw];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.withdraws.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData {
    __weak HHWithdrawHistoryViewController *weakSelf = self;
    [self refreshWithdrawsWithCompletion:^{
        [weakSelf.refreshHeader endRefreshing];
    }];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSMutableAttributedString alloc] initWithString:@"您目前还没有提现记录." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
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
