//
//  HHFindCoachViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHFindCoachViewController.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHButton.h"
#import "HHSliderView.h"
#import "KLCPopup.h"
#import "HHPopupUtility.h"
#import "HHFiltersView.h"
#import "HHCoachFilters.h"
#import "HHSortView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "INTULocationManager.h"
#import "HHAskLocationPermissionViewController.h"
#import "HHLoadingViewUtility.h"
#import "HHFieldsMapViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "HHCoachListViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import "HHConstantsStore.h"
#import "HHToastManager.h"
#import "HHCoachService.h"
#import "HHStudentStore.h"
#import "HHPopupUtility.h"
#import <KLCPopup/KLCPopup.h>
#import "HHCoachDetailViewController.h"

static NSString *const kCellId = @"kCoachListCellId";
static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 300.0f;

typedef void (^HHRefreshCoachCompletionBlock)();
typedef void (^HHUserLocationCompletionBlock)();

@interface HHFindCoachViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topButtonsView;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;

@property (nonatomic, strong) HHButton *filterButton;
@property (nonatomic, strong) HHButton *sortButton;

@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHFiltersView *filtersView;
@property (nonatomic, strong) HHCoachFilters *coachFilters;

@property (nonatomic, strong) HHSortView *sortView;
@property (nonatomic) SortOption currentSortOption;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;

@property (nonatomic, strong) NSMutableArray *selectedFields;
@property (nonatomic, strong) NSMutableArray *expandedCellIndexPath;

@property (nonatomic, strong) NSMutableArray *coaches;

@property (nonatomic, strong) HHCity *userCity;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation HHFindCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"寻找教练";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDefaultSortAndFilter];
    
    UIBarButtonItem *mapButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_maplist_btn"] action:@selector(jumpToFieldsMapView) target:self];
    self.navigationItem.leftBarButtonItem = mapButton;
    
    self.selectedFields = [NSMutableArray array];
    self.expandedCellIndexPath = [NSMutableArray array];
    [self initSubviews];
    [self refreshCoachListWithCompletion:nil];

}

- (void)refreshCoachListWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    __weak HHFindCoachViewController *weakSelf = self;
    if (!self.userLocation) {
        [self getUserLocationWithCompletion:^{
            if (weakSelf.userLocation) {
                if (!completion) {
                    [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"加载中"];
                }
                NSNumber *lat = @(weakSelf.userLocation.coordinate.latitude);
                NSNumber *lon = @(weakSelf.userLocation.coordinate.longitude);
                NSArray *locationArray = @[lat, lon];
                [[HHCoachService sharedInstance] fetchCoachListWithCityId:[HHStudentStore sharedInstance].currentStudent.cityId filters:weakSelf.coachFilters sortOption:weakSelf.currentSortOption fields:weakSelf.selectedFields userLocation:locationArray completion:^(HHCoaches *coaches, NSError *error) {
                    [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                    if (completion) {
                        completion();
                    }
                    weakSelf.coaches = [NSMutableArray arrayWithArray:coaches.coachesArray];
                    [weakSelf.tableView reloadData];
                }];

            }
        }];
    } else {
        if (!completion) {
            [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"加载中"];
        }
        NSNumber *lat = @(weakSelf.userLocation.coordinate.latitude);
        NSNumber *lon = @(weakSelf.userLocation.coordinate.longitude);
        NSArray *locationArray = @[lat, lon];
        [[HHCoachService sharedInstance] fetchCoachListWithCityId:[HHStudentStore sharedInstance].currentStudent.cityId filters:weakSelf.coachFilters sortOption:weakSelf.currentSortOption fields:weakSelf.selectedFields userLocation:locationArray completion:^(HHCoaches *coaches, NSError *error) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (completion) {
                completion();
            }
            weakSelf.coaches = [NSMutableArray arrayWithArray:coaches.coachesArray];
            [weakSelf.tableView reloadData];
        }];

    }
}


- (void)setupDefaultSortAndFilter {
    self.userCity = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    NSNumber *defaultDistance = [self.userCity.distanceRanges lastObject];
    NSNumber *defaultPrice = [self.userCity.priceRanges lastObject];
    HHCoachFilters *defailtFilters = [[HHCoachFilters alloc] init];
    defailtFilters.price = defaultPrice;
    defailtFilters.distance = defaultDistance;
    defailtFilters.onlyGoldenCoach = @(0);
    defailtFilters.licenseType = @(3);
    self.coachFilters = defailtFilters;
    
    self.currentSortOption = SortOptionSmartSort;
}

- (void)initSubviews {
    self.topButtonsView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topButtonsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topButtonsView];
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topButtonsView addSubview:self.verticalLine];
    
    self.horizontalLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topButtonsView addSubview:self.horizontalLine];
    
    self.filterButton = [self createTopButtonWithTitle:@"筛选" image:[UIImage imageNamed:@"ic_screen_normal_btn"]];
    [self.filterButton addTarget:self action:@selector(filterTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topButtonsView addSubview:self.filterButton];
    
    self.sortButton = [self createTopButtonWithTitle:@"排序" image:[UIImage imageNamed:@"ic_sort_normal_btn"]];
    [self.sortButton addTarget:self action:@selector(sortTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topButtonsView addSubview:self.sortButton];
    
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
    self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
    self.tableView.tableFooterView = self.loadMoreFooter;
    
    [self.tableView registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCellId];
    
    [self.view addSubview:self.tableView];
    
    [self makeConstraints];
}

- (HHButton *)createTopButtonWithTitle:(NSString *)title image:(UIImage *)image {
    HHButton *button = [[HHButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -10.0f, 0, 20.0f);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30.0f);
    return button;
}

- (void)makeConstraints {
    [self.topButtonsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(40.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topButtonsView);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.horizontalLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topButtonsView.bottom);
        make.left.equalTo(self.topButtonsView.left);
        make.width.equalTo(self.topButtonsView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.filterButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topButtonsView.left);
        make.width.equalTo(self.topButtonsView.width).multipliedBy(0.5f);
        make.height.equalTo(self.topButtonsView);
        make.top.equalTo(self.topButtonsView.top);
    }];
    
    [self.sortButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalLine.left);
        make.width.equalTo(self.topButtonsView.width).multipliedBy(0.5f);
        make.height.equalTo(self.topButtonsView);
        make.top.equalTo(self.topButtonsView.top);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.horizontalLine.bottom);
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
    }];
}

#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    __weak HHFindCoachViewController *weakSelf = self;
    __weak HHCoachListViewCell *weakCell = cell;
    
    
    [cell setupCellWithCoach:nil field:nil];

    
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.expandedCellIndexPath containsObject:indexPath]) {
        return kCellHeightExpanded;
    } else {
        return kCellHeightNormal;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachDetailViewController *coachDetailVC = [[HHCoachDetailViewController alloc] initWithCoach:nil];
    coachDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coachDetailVC animated:YES];
}


#pragma mark - Button Actions 

- (void)filterTapped {
    __weak HHFindCoachViewController *weakSelf = self;
    self.filtersView = [[HHFiltersView alloc] initWithFilters:[self.coachFilters copy] frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 380.0f) city:self.userCity];
    self.filtersView.confirmBlock = ^(HHCoachFilters *filters){
        weakSelf.coachFilters = filters;
        [weakSelf refreshCoachListWithCompletion:nil];
        [weakSelf.popup dismiss:YES];
    };
    self.filtersView.cancelBlock = ^(){
        [weakSelf.popup dismiss:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.filtersView];
    [HHPopupUtility showPopup:self.popup];
}

- (void)sortTapped {
     __weak HHFindCoachViewController *weakSelf = self;
    self.sortView = [[HHSortView alloc] initWithDefaultSortOption:self.currentSortOption];
    self.sortView.frame = CGRectMake(0, 0, 130.0f, 200.0f);
    self.sortView.selectedOptionBlock = ^(SortOption sortOption){
        weakSelf.currentSortOption = sortOption;
        [weakSelf refreshCoachListWithCompletion:nil];
        [weakSelf.popup dismiss:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.sortView];
    CGPoint center = CGPointMake(CGRectGetMidX(self.sortButton.frame), 150.0f);
    [HHPopupUtility showPopup:self.popup AtCenter:center inView:self.view];

}


- (void)jumpToFieldsMapView {
    __weak HHFindCoachViewController *weakSelf = self;
    if (self.userLocation) {
        __weak HHFindCoachViewController *weakSelf = self;
        HHFieldsMapViewController *mapVC = [[HHFieldsMapViewController alloc] initWithUserLocation:self.userLocation selectedFields:self.selectedFields];
        mapVC.conformBlock = ^(NSMutableArray *selectedFields) {
            weakSelf.selectedFields = selectedFields;
            [weakSelf refreshCoachListWithCompletion:nil];
        };
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
        [self presentViewController:navVC animated:YES completion:nil];
    } else {
        [self getUserLocationWithCompletion:^() {
            if (weakSelf.userLocation) {
                HHFieldsMapViewController *mapVC = [[HHFieldsMapViewController alloc] initWithUserLocation:weakSelf.userLocation selectedFields:weakSelf.selectedFields];
                mapVC.conformBlock = ^(NSMutableArray *selectedFields) {
                    weakSelf.selectedFields = selectedFields;
                    [weakSelf refreshCoachListWithCompletion:nil];
                };
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
                [weakSelf presentViewController:navVC animated:YES completion:nil];
            }
        }];
    }
}



- (void)getUserLocationWithCompletion:(HHUserLocationCompletionBlock)completion {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:10.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            self.userLocation = currentLocation;
            if (completion) {
                completion();
            }
        } else if (status == INTULocationStatusServicesDenied){
            HHAskLocationPermissionViewController *vc = [[HHAskLocationPermissionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.userLocation = nil;
            if (completion) {
                completion(nil);
            }
        } else if (status == INTULocationStatusError) {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试"];
            self.userLocation = nil;
            if (completion) {
                completion();
            }
        }

    }];
}


- (void)refreshData {
    [self refreshCoachListWithCompletion:^{
        [self.refreshHeader endRefreshing];
    }];
}

- (void)loadMoreData {
    [self.loadMoreFooter endRefreshing];
}



@end
