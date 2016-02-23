//
//  HHFollowedCoachListViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/23/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHFollowedCoachListViewController.h"
#import "HHCoachListViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "HHCity.h"
#import "HHCoaches.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHConstantsStore.h"
#import "HHCoachDetailViewController.h"
#import "HHCoachService.h"
#import "HHLoadingViewUtility.h"
#import "HHFindCoachViewController.h"
#import "HHStudentStore.h"

static NSString *const kCellId = @"kCoachListCellId";
static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 300.0f;

@interface HHFollowedCoachListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;
@property (nonatomic, strong) NSMutableArray *expandedCellIndexPath;

@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) HHCity *userCity;
@property (nonatomic, strong) HHCoaches *coachesObject;

@property (nonatomic) BOOL hasMoreCoaches;


@end

@implementation HHFollowedCoachListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的教练";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.expandedCellIndexPath = [NSMutableArray array];
    [self initSubviews];
    [self refreshCoachListWithCompletion:nil];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.refreshHeader setTitle:@"正在刷新教练列表" forState:MJRefreshStateRefreshing];
    self.refreshHeader.stateLabel.textColor = [UIColor HHLightTextGray];
    self.refreshHeader.automaticallyChangeAlpha = YES;
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = self.refreshHeader;
    
    self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.loadMoreFooter setTitle:@"加载更多教练" forState:MJRefreshStateIdle];
    [self.loadMoreFooter setTitle:@"正在加载更多教练" forState:MJRefreshStateRefreshing];
    [self.loadMoreFooter setTitle:@"没有更多教练" forState:MJRefreshStateNoMoreData];
    self.loadMoreFooter.automaticallyRefresh = NO;
    self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
    self.tableView.mj_footer = self.loadMoreFooter;
    
    [self.tableView registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCellId];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCellId];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
    }];
}

#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    __weak HHFollowedCoachListViewController *weakSelf = self;
    __weak HHCoachListViewCell *weakCell = cell;
    
    HHCoach *coach = self.coaches[indexPath.row];
    [cell setupCellWithCoach:coach field:[[HHConstantsStore sharedInstance] getFieldWithId:coach.fieldId]];
    
    if ([self.expandedCellIndexPath containsObject:indexPath]) {
        cell.mapView.hidden = NO;
    } else {
        cell.mapView.hidden = YES;
    }
    
    cell.mapButtonBlock = ^(){
        if ([weakSelf.expandedCellIndexPath containsObject:indexPath]) {
            [weakSelf.expandedCellIndexPath removeObject:indexPath];
            weakCell.mapView.hidden = YES;
            
        } else {
            weakCell.mapView.hidden = NO;
            [weakSelf.expandedCellIndexPath addObject:indexPath];
        }
        [weakSelf.tableView reloadData];
    };
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coaches.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.expandedCellIndexPath containsObject:indexPath]) {
        return kCellHeightExpanded;
    } else {
        return kCellHeightNormal;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachDetailViewController *coachDetailVC = [[HHCoachDetailViewController alloc] initWithCoach:self.coaches[indexPath.row]];
    coachDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coachDetailVC animated:YES];
}



- (void)refreshData {
    __weak HHFollowedCoachListViewController *weakSelf = self;
    [self refreshCoachListWithCompletion:^{
        [weakSelf.refreshHeader endRefreshing];
    }];
}

- (void)loadMoreData {
    __weak HHFollowedCoachListViewController *weakSelf = self;
    [self loadMoreCoachesWithCompletion:^{
        [weakSelf.loadMoreFooter endRefreshing];
    }];
}

- (void)refreshCoachListWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    __weak HHFollowedCoachListViewController *weakSelf = self;
    if (!completion) {
        [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"加载中"];
    }

    [[HHCoachService sharedInstance] fetchCoachListWithCityId:0 filters:nil sortOption:0 fields:nil userLocation:nil completion:^(HHCoaches *coaches, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (completion) {
            completion();
        }
        if (!error) {
            weakSelf.coachesObject = coaches;
            weakSelf.coaches = [NSMutableArray arrayWithArray:coaches.coaches];
            if (coaches.nextPage) {
                weakSelf.hasMoreCoaches = YES;
            } else {
                weakSelf.hasMoreCoaches = NO;
            }
            
            [weakSelf.tableView reloadData];
        }
        
    }];
}

- (void)loadMoreCoachesWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    [[HHCoachService sharedInstance] fetchNextPageCoachListWithURL:self.coachesObject.nextPage completion:^(HHCoaches *coaches, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            self.coachesObject = coaches;
            [self.coaches addObjectsFromArray:coaches.coaches];
            if (coaches.nextPage) {
                self.hasMoreCoaches = YES;
            } else {
                self.hasMoreCoaches = NO;
            }
            
            [self.tableView reloadData];
        }
        
        
    }];
}

- (void)setHasMoreCoaches:(BOOL)hasMoreCoaches {
    _hasMoreCoaches = hasMoreCoaches;
    if (!hasMoreCoaches) {
        [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
    } else {
        [self.loadMoreFooter setState:MJRefreshStateIdle];
    }
}

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
