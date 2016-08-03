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


typedef void (^HHWithdrawTransactionCompletion)();

static NSString *const kCellId = @"cellId";

@interface HHWithdrawHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HHWithdraws *withdrawsObject;
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
    [self.refreshHeader setTitle:@"正在刷新列表" forState:MJRefreshStateRefreshing];
    self.refreshHeader.stateLabel.textColor = [UIColor HHLightTextGray];
    self.refreshHeader.automaticallyChangeAlpha = YES;
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = self.refreshHeader;
    
    self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.loadMoreFooter setTitle:@"加载更多提现记录" forState:MJRefreshStateIdle];
    [self.loadMoreFooter setTitle:@"正在加载更多提现记录" forState:MJRefreshStateRefreshing];
    [self.loadMoreFooter setTitle:@"没有更多提现记录" forState:MJRefreshStateNoMoreData];
    self.loadMoreFooter.automaticallyRefresh = NO;
    self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
    self.tableView.mj_footer = self.loadMoreFooter;
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [self refreshWithdrawsWithCompletion:^{
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
    }];
    
}


- (void)refreshWithdrawsWithCompletion:(HHWithdrawTransactionCompletion)completion {
    [[HHStudentService sharedInstance] fetchWithdrawTransactionWithCompletion:^(HHWithdraws *withdrawsObject, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            self.withdrawsObject = withdrawsObject;
            self.withdraws = [NSMutableArray arrayWithArray:self.withdrawsObject.withdraws];
            [self.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
    }];
}

- (void)loadMoreWithdrawsWithCompletion:(HHWithdrawTransactionCompletion)completion {
    [[HHStudentService sharedInstance] fetchMoreWithdrawTransactionsWithURL:self.withdrawsObject.nextPage completion:^(HHWithdraws *withdrawsObject, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            self.withdrawsObject = withdrawsObject;
            [self.withdraws addObjectsFromArray:self.withdrawsObject.withdraws];
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

- (void)loadMoreData {
    __weak HHWithdrawHistoryViewController *weakSelf = self;
    [self loadMoreWithdrawsWithCompletion:^{
        [weakSelf.loadMoreFooter endRefreshing];
    }];
}

- (void)setWithdrawsObject:(HHWithdraws *)withdrawsObject {
    _withdrawsObject = withdrawsObject;
    if (!self.withdrawsObject.nextPage) {
        [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
    } else {
        [self.loadMoreFooter setState:MJRefreshStateIdle];
    }
}


@end
