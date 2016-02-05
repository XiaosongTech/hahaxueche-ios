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
#import "HHCitySelectView.h"
#import "HHPopupUtility.h"
#import <KLCPopup/KLCPopup.h>

static NSString *const kCellId = @"kCoachListCellId";
static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 300.0f;

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
@property (nonatomic, strong) HHCitySelectView *citySelectView;

@end

@implementation HHFindCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"寻找教练";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDefaultSortAndFilter];
    
    UIBarButtonItem *mapButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_maplist_btn"] action:@selector(getUserLocation) target:self];
    self.navigationItem.leftBarButtonItem = mapButton;
    
    self.selectedFields = [NSMutableArray array];
    self.expandedCellIndexPath = [NSMutableArray array];
    
    [self initSubviews];
    
    // Enter as a guest
    if (![HHStudentStore sharedInstance].currentStudent.cityId) {
        __weak HHFindCoachViewController *weakSelf = self;
        [[HHConstantsStore sharedInstance] getConstantsWithCompletion:^(HHConstants *constants) {
            if ([constants.cities count]) {
                CGFloat height = MAX(300.0f, CGRectGetHeight(weakSelf.view.bounds)/2.0f);
                weakSelf.citySelectView = [[HHCitySelectView alloc] initWithCities:constants.cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:nil];
                weakSelf.citySelectView.completion = ^(HHCity *selectedCity) {
                    [HHStudentStore sharedInstance].currentStudent.cityId = selectedCity.cityId;
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                    [weakSelf updateCoachList];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
                [weakSelf.popup show];
            }
        }];

    }

}

- (void)updateCoachList {
    __weak HHFindCoachViewController *weakSelf = self;
    [[HHCoachService sharedInstance] fetchCoachListWithCityId:nil filters:nil sortOption:self.currentSortOption fields:nil completion:^(NSArray *coaches, NSError *error) {
        weakSelf.coaches = [NSMutableArray arrayWithArray:coaches];
        [weakSelf.tableView reloadData];
    }];
}

- (void)setupDefaultSortAndFilter {
    self.coachFilters = [[HHCoachFilters alloc] init];
    self.coachFilters.price = @(3000);
    self.coachFilters.distance = @(3);
    self.coachFilters.onlyGoldenCoach = @(1);
    self.coachFilters.licenseType = @(1);
    
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
    
    [[HHConstantsStore sharedInstance] getConstantsWithCompletion:^(HHConstants *constants) {
        [cell setupCellWithCoach:nil field:[constants.fields firstObject]];
    }];
    
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


#pragma mark - Button Actions 

- (void)filterTapped {
    __weak HHFindCoachViewController *weakSelf = self;
    self.filtersView = [[HHFiltersView alloc] initWithFilters:[self.coachFilters copy] frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 380.0f)];
    self.filtersView.confirmBlock = ^(HHCoachFilters *filters){
        weakSelf.coachFilters = filters;
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
        [weakSelf.popup dismiss:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.sortView];
    CGPoint center = CGPointMake(CGRectGetMidX(self.sortButton.frame), 150.0f);
    [HHPopupUtility showPopup:self.popup AtCenter:center inView:self.view];

}

- (void)jumpToMapViewWithUserLocation:(CLLocation *)userLocation {
     __weak HHFindCoachViewController *weakSelf = self;
    HHFieldsMapViewController *mapVC = [[HHFieldsMapViewController alloc] initWithUserLocation:userLocation selectedFields:self.selectedFields];
    mapVC.conformBlock = ^(NSMutableArray *selectedFields) {
        weakSelf.selectedFields = selectedFields;
    };
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [self presentViewController:navVC animated:YES completion:nil];
}


- (void)getUserLocation {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:10.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        
        if (status == INTULocationStatusSuccess) {
            [self jumpToMapViewWithUserLocation:currentLocation];
        } else if (status == INTULocationStatusServicesDenied){
            HHAskLocationPermissionViewController *vc = [[HHAskLocationPermissionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == INTULocationStatusError) {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试"];
        }

    }];
}


- (void)refreshData {
    [self.refreshHeader endRefreshing];
}

- (void)loadMoreData {
    [self.loadMoreFooter endRefreshing];
}


@end