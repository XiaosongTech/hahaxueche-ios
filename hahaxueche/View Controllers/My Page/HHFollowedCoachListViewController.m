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
#import "HHCoachService.h"
#import "HHStudentStore.h"
#import "UIScrollView+EmptyDataSet.h"

static NSString *const kCellId = @"kCoachListCellId";
static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 305.0f;

@interface HHFollowedCoachListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;
@property (nonatomic, strong) NSMutableArray *expandedCellIndexPath;

@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) HHCity *userCity;
@property (nonatomic, strong) HHCoaches *coachesObject;

@end

@implementation HHFollowedCoachListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的教练";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.expandedCellIndexPath = [NSMutableArray array];
    [self initSubviews];
    [self refreshCoachListWithCompletion:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoach:) name:@"kUnfollowCoach" object:nil];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.refreshHeader setTitle:@"下拉更新" forState:MJRefreshStateIdle];
    [self.refreshHeader setTitle:@"下拉更新" forState:MJRefreshStatePulling];
    [self.refreshHeader setTitle:@"正在刷新教练列表" forState:MJRefreshStateRefreshing];
    self.refreshHeader.stateLabel.textColor = [UIColor HHLightTextGray];
    self.refreshHeader.automaticallyChangeAlpha = YES;
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = self.refreshHeader;
    
    self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.loadMoreFooter setTitle:@"一大波教练接近中~~~" forState:MJRefreshStateIdle];
    [self.loadMoreFooter setTitle:@"正在加载更多教练" forState:MJRefreshStateRefreshing];
    [self.loadMoreFooter setTitle:@"已经到底啦~再往上选选吧！" forState:MJRefreshStateNoMoreData];
    [self.loadMoreFooter setHidden:YES];
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
    [cell setupCellWithCoach:coach field:[[HHConstantsStore sharedInstance] getFieldWithId:coach.fieldId] mapShowed:[weakSelf.expandedCellIndexPath containsObject:indexPath]];
    
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
    CGFloat height = 0;
    if ([tableView isEqual:self.tableView]) {
        if ([self.expandedCellIndexPath containsObject:indexPath]) {
            height = kCellHeightExpanded + 40.0f;
            
        } else {
            height = kCellHeightNormal + 40.0f;
        }
        return height;
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
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }

    [[HHCoachService sharedInstance] fetchFollowedCoachListWithCompletion:^(HHCoaches *coaches, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (completion) {
            completion();
        }
        if (!error) {
            weakSelf.coaches = [NSMutableArray arrayWithArray:coaches.coaches];
            weakSelf.coachesObject = coaches;
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
            [self.coaches addObjectsFromArray:coaches.coaches];
            self.coachesObject = coaches;
            [self.tableView reloadData];
        }
        
        
    }];
}

- (void)setCoachesObject:(HHCoaches *)coachesObject {
    _coachesObject = coachesObject;
    if (!coachesObject.nextPage) {
        if ([self.coaches count]) {
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

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeCoach:(NSNotification *)notification {
    NSString *coachId = notification.object[@"coachId"];
    if (coachId) {
        for (HHCoach *coach in self.coaches) {
            if ([coach.coachId isEqualToString:coachId]) {
                [self.coaches removeObject:coach];
                [self.tableView reloadData];
                if (![self.coaches count]) {
                    [self.loadMoreFooter setHidden:YES];
                } else {
                    [self.loadMoreFooter setHidden:NO];
                }
                break;
            }
        }
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSMutableAttributedString alloc] initWithString:@"您还木有关注的教练, 快去关注吧!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
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
