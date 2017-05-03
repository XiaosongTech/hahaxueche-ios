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
#import "KLCPopup.h"
#import "HHPopupUtility.h"
#import "HHFilters.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "INTULocationManager.h"
#import "HHAskLocationPermissionViewController.h"
#import "HHLoadingViewUtility.h"
#import "HHFieldsMapViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "HHCoachListViewCell.h"
#import "HHConstantsStore.h"
#import "HHToastManager.h"
#import "HHCoachService.h"
#import "HHStudentStore.h"
#import "HHPopupUtility.h"
#import <KLCPopup/KLCPopup.h>
#import "HHCoachDetailViewController.h"
#import "HHSearchViewController.h"
#import "HHGifRefreshHeader.h"
#import "UIScrollView+EmptyDataSet.h"
#import "HHDrivingSchoolListViewCell.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHAppVersionUtility.h"
#import <pop/POP.h>
#import "HHWebViewController.h"
#import "HHSupportUtility.h"
#import "DOPDropDownMenu.h"
#import "HHHotSchoolsTableViewCell.h"


static NSString *const kCellId = @"kCoachListCellId";
static NSString *const kDrivingSchoolCellId = @"kDrivingSchoolCellId";
static NSString *const kHotSchoolCellId = @"kHotSchoolCellId";
static NSString *const kFindCoachGuideKey = @"kFindCoachGuideKey";
static CGFloat const kCellHeightNormal = 100.0f;
static NSInteger const kHotSchoolIndex = 4;

@interface HHFindCoachViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,SwipeViewDataSource, SwipeViewDelegate, DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>


@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic, strong) DOPDropDownMenu *coachFilterMenu;
@property (nonatomic, strong) DOPDropDownMenu *schoolFilterMenu;
@property (nonatomic, strong) HHFilters *coachFilters;
@property (nonatomic, strong) HHFilters *schoolFilters;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) HHGifRefreshHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;
@property (nonatomic, strong) HHGifRefreshHeader *refreshHeader2;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter2;

@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSMutableArray *schools;

@property (nonatomic, strong) HHCity *userCity;
@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) HHCoaches *coachesObject;
@property (nonatomic, strong) HHDrivingSchools *schoolsObject;

@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) HHGenericOneButtonPopupView *personalCoachExplanationView;

@property (nonatomic, strong) UIButton *floatButton;

@property (nonatomic) CoachSortOption coachSortOption;
@property (nonatomic) SchoolSortOption schoolSortOption;

@property (nonatomic) NSInteger filterIndex;

@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) NSMutableArray *distances;
@property (nonatomic, strong) NSMutableArray *priceRanges;
@property (nonatomic, strong) NSMutableArray *licenseTypes;
@property (nonatomic, strong) NSMutableArray *sortOptions;

@end

@implementation HHFindCoachViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"驾校教练";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem  buttonItemWithImage:[UIImage imageNamed:@"ic_map_firstscreen"] action:@selector(jumpToFieldsMapView) target:self];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_search"] action:@selector(jumpToSearchVC) target:self];
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    self.segControl = [[UISegmentedControl alloc] initWithItems:@[@"选驾校", @"挑教练"]];
    self.segControl.tintColor = [UIColor whiteColor];
    [self.segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} forState:UIControlStateNormal];
    [self.segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} forState:UIControlStateSelected];
    self.segControl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segControl.backgroundColor = [UIColor HHOrange];
    [self.segControl addTarget:self action:@selector(segValueChanged) forControlEvents:UIControlEventValueChanged];
    self.segControl.selectedSegmentIndex = ListTypeDrivingSchool;
    self.navigationItem.titleView = self.segControl;
    
    __weak HHFindCoachViewController *weakSelf = self;
    [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
    [self getUserLocationWithCompletion:^{
        [weakSelf setupDefaultSortAndFilterForSchool];
        [weakSelf refreshDrivingSchoolList:YES completion:nil];
        [weakSelf buildFloatButton];
        [weakSelf refreshCoachList:NO completion:nil];
        [[HHAppVersionUtility sharedManager] checkVersionInVC:weakSelf];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged) name:@"cityChanged" object:nil];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_viewed attributes:nil];
}

- (void)buildFloatButton {
    self.floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.floatButton setImage:[UIImage imageNamed:@"list_popup_help"] forState:UIControlStateNormal];
    [self.floatButton addTarget:self action:@selector(jumpToOnlineSupport) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.floatButton];
    [self.floatButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-70.0f);
        make.right.equalTo(self.view.right);
    }];
}

- (void)refreshCoachList:(BOOL)showLoading completion:(HHRefreshCoachCompletionBlock)completion {
    __weak HHFindCoachViewController *weakSelf = self;
    if (showLoading) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    NSArray *locationArray;
    if ([HHStudentStore sharedInstance].currentLocation) {
        NSNumber *lat = @([HHStudentStore sharedInstance].currentLocation.coordinate.latitude);
        NSNumber *lon = @([HHStudentStore sharedInstance].currentLocation.coordinate.longitude);
        locationArray = @[lat, lon];
        
    }
    [[HHCoachService sharedInstance] fetchCoachListWithCityId:self.userCity.cityId filters:self.coachFilters sortOption:self.coachSortOption userLocation:locationArray fields:nil perPage:nil completion:^(HHCoaches *coaches, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            weakSelf.coaches = [NSMutableArray arrayWithArray:coaches.coaches];
            if (weakSelf.coaches.count > kHotSchoolIndex) {
                [weakSelf.coaches insertObject:kHotSchoolCellId atIndex:kHotSchoolIndex];
            } else {
                [weakSelf.coaches addObject:kHotSchoolCellId];
            }
            weakSelf.coachesObject = coaches;
            [weakSelf.tableView2 reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
        if (completion) {
            completion();
        }
        if (showLoading) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
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
           [self.tableView2 reloadData];
       }
       
   }];
}


- (void)refreshDrivingSchoolList:(BOOL)showLoading completion:(HHRefreshCoachCompletionBlock)completion {
        __weak HHFindCoachViewController *weakSelf = self;
    if (showLoading) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    NSArray *locationArray;
    if ([HHStudentStore sharedInstance].currentLocation) {
        NSNumber *lat = @([HHStudentStore sharedInstance].currentLocation.coordinate.latitude);
        NSNumber *lon = @([HHStudentStore sharedInstance].currentLocation.coordinate.longitude);
        locationArray = @[lat, lon];
        
    }
    [[HHCoachService sharedInstance] fetchDrivingSchoolListWithCityId:self.userCity.cityId filters:self.schoolFilters sortOption:self.schoolSortOption userLocation:locationArray perPage:@(20) completion:^(HHDrivingSchools *schools, NSError *error) {
        if (!error) {
            weakSelf.schools = [NSMutableArray arrayWithArray:schools.schools];
            weakSelf.schoolsObject = schools;
            if (weakSelf.schools.count > kHotSchoolIndex) {
                [weakSelf.schools insertObject:kHotSchoolCellId atIndex:kHotSchoolIndex];
            } else {
                [weakSelf.schools addObject:kHotSchoolCellId];
            }
            [weakSelf.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
        if (completion) {
            completion();
        }
        if (showLoading) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        }
    }];
}

- (void)loadMoreSchoolsWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    [[HHCoachService sharedInstance] fetchNextPageDrivingSchoolListWithURL:self.schoolsObject.nextPage completion:^(HHDrivingSchools *schools, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            [self.schools addObjectsFromArray:schools.schools];
            self.schoolsObject = schools;
            [self.tableView reloadData];
        }
        
    }];

}

- (void)setSchoolsObject:(HHDrivingSchools *)schoolsObject {
    _schoolsObject = schoolsObject;
    if (!schoolsObject.nextPage) {
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


- (void)setCoachesObject:(HHCoaches *)coachesObject {
    _coachesObject = coachesObject;
    if (!coachesObject.nextPage) {
        if ([self.coaches count]) {
            [self.loadMoreFooter2 setHidden:NO];
            
        } else {
            [self.loadMoreFooter2 setHidden:YES];
        }
        [self.loadMoreFooter2 setState:MJRefreshStateNoMoreData];
    } else {
        [self.loadMoreFooter2 setHidden:NO];
        [self.loadMoreFooter2 setState:MJRefreshStateIdle];
    }
}

- (void)setupDefaultSortAndFilterForSchool{
    self.userCity = [[HHConstantsStore sharedInstance] getCityWithId:[HHStudentStore sharedInstance].selectedCityId];
    
    self.schoolFilters = [[HHFilters alloc] init];
    self.schoolFilters.distance = nil;
    self.schoolFilters.zone = nil;
    self.schoolFilters.priceStart = nil;
    self.schoolFilters.priceEnd = nil;
    self.schoolFilters.licenseType = nil;
    self.schoolSortOption = SchoolSortOptionDefault;
    
    self.areas = [NSMutableArray arrayWithObject:@"附近"];
    [self.areas addObjectsFromArray:self.userCity.zones];
    
    self.distances = [NSMutableArray array];
    for (NSNumber *num in self.userCity.distanceRanges) {
        [self.distances addObject:[NSString stringWithFormat:@"%@km", [num stringValue]]];
    }
    [self.distances addObject:@"全城"];
    
    self.priceRanges = [NSMutableArray array];
    for (NSArray *rangeArray in self.userCity.priceRanges) {
        NSString *title = [NSString stringWithFormat:@"%@-%@元", [rangeArray firstObject], rangeArray[1]];
        [self.priceRanges addObject:title];
    }
    [self.priceRanges addObject:[NSString stringWithFormat:@"%@元以上", [self.userCity.priceRanges lastObject][1]]];
    [self.priceRanges insertObject:@"不限" atIndex:0];

    self.licenseTypes = [NSMutableArray arrayWithArray:@[@"不限", @"C1手动挡", @"C2自动挡"]];
    
    self.sortOptions = [NSMutableArray arrayWithArray:@[@"综合排序", @"距离最近", @"评价最多", @"价格最低"]];
    
    
    [self.schoolFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:self.distances.count-1]];
    [self.schoolFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:1 row:0 item:-1]];
    [self.schoolFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:2 row:0 item:-1]];
    [self.schoolFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:3 row:0 item:-1]];
    
}

- (void)setupDefaultSortAndFilterForCoach {
    self.coachFilters = [[HHFilters alloc] init];
    self.coachFilters.distance = nil;
    self.coachFilters.zone = nil;
    self.coachFilters.priceStart = nil;
    self.coachFilters.priceEnd = nil;
    self.coachFilters.licenseType = nil;
    self.coachSortOption = CoachSortOptionPrice;
    
    [self.coachFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:self.distances.count-1]];
    [self.coachFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:1 row:0 item:-1]];
    [self.coachFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:2 row:0 item:-1]];
    [self.coachFilterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:3 row:self.sortOptions.count-1 item:-1]];
}


- (void)initSubviews {
    self.swipeView = [[SwipeView alloc] init];
    self.swipeView.pagingEnabled = YES;
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    [self.view addSubview:self.swipeView];
    [self.swipeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
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


#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHFindCoachViewController *weakSelf = self;
    
    if ([tableView isEqual:self.tableView2]) {
        if (indexPath.row == kHotSchoolIndex || indexPath.row == self.coaches.count-1) {
            if ([self.coaches[indexPath.row] isKindOfClass:[NSString class]]) {
                HHHotSchoolsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotSchoolCellId forIndexPath:indexPath];
                return cell;
            }
            
        }
        HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        HHCoach *coach = self.coaches[indexPath.row];
        [cell setupCellWithCoach:coach field:[[HHConstantsStore sharedInstance] getFieldWithId:coach.fieldId]];
        
        
        cell.drivingSchoolBlock = ^(HHDrivingSchool *school) {
            HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://m.hahaxueche.com/jiaxiao/%@", [school.schoolId stringValue]]]];
            webVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        };
        
        return cell;

    } else {
        if (indexPath.row == kHotSchoolIndex || indexPath.row == self.schools.count-1) {
            if ([self.schools[indexPath.row] isKindOfClass:[NSString class]]) {
                HHHotSchoolsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotSchoolCellId forIndexPath:indexPath];
                return cell;
            }
            
        }
        HHDrivingSchoolListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDrivingSchoolCellId forIndexPath:indexPath];
        [cell setupCellWithSchool:self.schools[indexPath.row]];
        cell.grouponBlock = ^{
            HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://m.hahaxueche.com/tuan?promo_code=456134"]];
            webVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        };
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView2]) {
        return self.coaches.count;
    } else {
        return self.schools.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        if ([self.schools[indexPath.row] isKindOfClass:[NSString class]]) {
            return 170.0f;
        } else {
            return kCellHeightNormal + 40.0f;
        }
    } else {
        if ([self.coaches[indexPath.row] isKindOfClass:[NSString class]]) {
            return 170.0f;
        } else {
            return kCellHeightNormal + 40.0f;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHFindCoachViewController *weakSelf = self;
    if ([tableView isEqual:self.tableView2]) {
        if ([self.coaches[indexPath.row] isKindOfClass:[NSString class]]) {
            return;
        }
        HHCoach *selectedCoach = self.coaches[indexPath.row];
        HHCoachDetailViewController *coachDetailVC = [[HHCoachDetailViewController alloc] initWithCoach:self.coaches[indexPath.row]];
        coachDetailVC.coachUpdateBlock = ^(HHCoach *coach) {
            [weakSelf.coaches replaceObjectAtIndex:indexPath.row withObject:coach];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        coachDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coachDetailVC animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_coach_tapped attributes:@{@"coach_id":selectedCoach.coachId}];
    } else {
        if ([self.schools[indexPath.row] isKindOfClass:[NSString class]]) {
            return;
        }
    }
    
}



#pragma mark - Button Actions


- (void)jumpToFieldsMapView {
    __weak HHFindCoachViewController *weakSelf = self;
    [self getUserLocationWithCompletion:^() {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (weakSelf.userLocation) {
            [[HHConstantsStore sharedInstance] getFieldsWithCityId:[HHStudentStore sharedInstance].selectedCityId completion:^(NSArray *fields) {
                if (fields.count > 0) {
                    HHFieldsMapViewController *vc = [[HHFieldsMapViewController alloc] initWithFields:fields selectedField:nil];
                    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:navVC animated:YES completion:nil];
                }
            }];
        }
    }];

    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_field_icon_tapped attributes:nil];
}



- (void)getUserLocationWithCompletion:(HHUserLocationCompletionBlock)completion {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyNeighborhood timeout:2.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            self.userLocation = currentLocation;
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
            
        } else if (status == INTULocationStatusTimedOut) {
            self.userLocation = currentLocation;
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
            
        } else if (status == INTULocationStatusError) {
            self.userLocation = nil;
            [HHStudentStore sharedInstance].currentLocation = nil;
        } else {
            [HHStudentStore sharedInstance].currentLocation = nil;
            HHAskLocationPermissionViewController *vc = [[HHAskLocationPermissionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.userLocation = nil;

        }
        if (completion) {
            completion();
        }
    }];
}


- (void)refreshData {
    __weak HHFindCoachViewController *weakSelf = self;
    if (self.segControl.selectedSegmentIndex == ListTypeCoach) {
        [self refreshCoachList:NO completion:^{
            [weakSelf.refreshHeader2 endRefreshing];
        }];
    } else {
        [self refreshDrivingSchoolList:NO completion:^{
            [weakSelf.refreshHeader endRefreshing];
        }];
    }
    
}

- (void)loadMoreData {
    __weak HHFindCoachViewController *weakSelf = self;
    if (self.segControl.selectedSegmentIndex == ListTypeCoach) {
        [self loadMoreCoachesWithCompletion:^{
            [weakSelf.loadMoreFooter2 endRefreshing];
        }];
    } else {
        [self loadMoreSchoolsWithCompletion:^{
            [weakSelf.loadMoreFooter endRefreshing];
        }];
    }
    
}

- (void)jumpToSearchVC {
    HHSearchViewController *vc = [[HHSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:NO completion:nil];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_search_tapped attributes:nil];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView2]) {
        return [[NSMutableAttributedString alloc] initWithString:@"啥？！没有匹配到教练啊/(ㄒoㄒ)/~~点击页面上方筛选选项，并调节距离等因素来寻找更多教练吧!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    } else {
        return [[NSMutableAttributedString alloc] initWithString:@"啥？！没有匹配到驾校啊/(ㄒoㄒ)/~~点击页面上方筛选选项，并调节距离等因素来寻找更多驾校吧!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    }
    
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

#pragma mark -SwipeView methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return ListTypeCount;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view) {
        return view;
    }
    UIView *containerView = [[UIView alloc] init];
    [self initViewForSwiptView:containerView index:index];
    return containerView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.swipeView.bounds.size;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView {
    self.segControl.selectedSegmentIndex = swipeView.currentPage;
    [self segValueChanged];
}


- (void)initViewForSwiptView:(UIView *)view index:(NSInteger)index {
    __weak HHFindCoachViewController *weakSelf = self;
    if (index == ListTypeCoach) {
        self.coachFilterMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        self.coachFilterMenu.delegate = self;
        self.coachFilterMenu.dataSource = self;
        self.coachFilterMenu.textColor = [UIColor HHLightTextGray];
        self.coachFilterMenu.tintColor = [UIColor HHOrange];
        self.coachFilterMenu.textSelectedColor = [UIColor HHOrange];
        self.coachFilterMenu.indicatorColor = [UIColor HHLightestTextGray];
        [view addSubview:self.coachFilterMenu];
        
        
        self.coachFilterMenu.finishedBlock=^(DOPIndexPath *indexPath){
            if (indexPath.column == 0) {
                if (indexPath.row == 0) {
                    if (indexPath.item >= weakSelf.userCity.distanceRanges.count) {
                        weakSelf.coachFilters.distance = nil;
                    } else {
                        weakSelf.coachFilters.distance = weakSelf.userCity.distanceRanges[indexPath.item];
                    }
                } else {
                    weakSelf.coachFilters.zone = weakSelf.userCity.zones[indexPath.row -1];
                }
            } else if (indexPath.column == 1) {
                if (indexPath.row == 0) {
                    weakSelf.coachFilters.priceStart = nil;
                    weakSelf.coachFilters.priceEnd = nil;
                } else if (indexPath.row == weakSelf.userCity.priceRanges.count + 1) {
                    weakSelf.coachFilters.priceStart = weakSelf.userCity.priceRanges[indexPath.row-2][1];
                    weakSelf.coachFilters.priceEnd = nil;
                    
                } else {
                    weakSelf.coachFilters.priceStart = weakSelf.userCity.priceRanges[indexPath.row-1][0];
                    weakSelf.coachFilters.priceEnd = weakSelf.userCity.priceRanges[indexPath.row-1][1];
                }
                
            } else if (indexPath.column == 2) {
                if (indexPath.row == 0) {
                    weakSelf.coachFilters.licenseType = nil;
                } else {
                    weakSelf.coachFilters.licenseType = @(indexPath.row);
                }
            } else {
                weakSelf.coachSortOption = indexPath.row;
            }
            [weakSelf refreshCoachList:YES completion:nil];

        };
        
        self.tableView2 = [[UITableView alloc] init];
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        self.tableView2.emptyDataSetSource = self;
        self.tableView2.emptyDataSetDelegate = self;
        self.tableView2.showsVerticalScrollIndicator = NO;
        self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.refreshHeader2 = [HHGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        NSString *imgString = [[NSBundle mainBundle] pathForResource:@"loading_car" ofType:@"gif"];
        NSData *imgData = [NSData dataWithContentsOfFile:imgString];
        self.refreshHeader2.imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imgData];
        self.tableView2.mj_header = self.refreshHeader2;
        
        self.loadMoreFooter2 = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self.loadMoreFooter2 setTitle:@"加载更多教练" forState:MJRefreshStateIdle];
        [self.loadMoreFooter2 setTitle:@"一大波教练接近中~~~" forState:MJRefreshStateRefreshing];
        [self.loadMoreFooter2 setTitle:@"已经到底啦~再往上选选吧！" forState:MJRefreshStateNoMoreData];
        [self.loadMoreFooter2 setHidden:YES];
        self.loadMoreFooter2.automaticallyRefresh = NO;
        self.loadMoreFooter2.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        self.loadMoreFooter2.stateLabel.textColor = [UIColor HHLightTextGray];
        self.tableView2.mj_footer = self.loadMoreFooter2;
        
        [self.tableView2 registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCellId];
        [self.tableView2 registerClass:[HHHotSchoolsTableViewCell class] forCellReuseIdentifier:kHotSchoolCellId];
        
        [view addSubview:self.tableView2];
        
        
        [self.tableView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coachFilterMenu.bottom);
            make.left.equalTo(view.left);
            make.bottom.equalTo(view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));
            make.width.equalTo(view.width);
        }];
        [self setupDefaultSortAndFilterForCoach];
    } else {
        
        self.schoolFilterMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        self.schoolFilterMenu.delegate = self;
        self.schoolFilterMenu.dataSource = self;
        self.schoolFilterMenu.textColor = [UIColor HHLightTextGray];
        self.schoolFilterMenu.tintColor = [UIColor HHOrange];
        self.schoolFilterMenu.textSelectedColor = [UIColor HHOrange];
        self.schoolFilterMenu.indicatorColor = [UIColor HHLightestTextGray];
        [view addSubview:self.schoolFilterMenu];
        
        self.schoolFilterMenu.finishedBlock=^(DOPIndexPath *indexPath){
            if (indexPath.column == 0) {
                if (indexPath.row == 0) {
                    if (indexPath.item >= weakSelf.userCity.distanceRanges.count) {
                        weakSelf.schoolFilters.distance = nil;
                    } else {
                        weakSelf.schoolFilters.distance = weakSelf.userCity.distanceRanges[indexPath.item];
                    }
                } else {
                    weakSelf.schoolFilters.zone = weakSelf.userCity.zones[indexPath.row -1];
                }
            } else if (indexPath.column == 1) {
                if (indexPath.row == 0) {
                    weakSelf.schoolFilters.priceStart = nil;
                    weakSelf.schoolFilters.priceEnd = nil;
                } else if (indexPath.row == weakSelf.userCity.priceRanges.count + 1) {
                    weakSelf.schoolFilters.priceStart = weakSelf.userCity.priceRanges[indexPath.row-2][1];
                    weakSelf.schoolFilters.priceEnd = nil;
                    
                } else {
                    weakSelf.schoolFilters.priceStart = weakSelf.userCity.priceRanges[indexPath.row-1][0];
                    weakSelf.schoolFilters.priceEnd = weakSelf.userCity.priceRanges[indexPath.row-1][1];
                }
                
            } else if (indexPath.column == 2) {
                if (indexPath.row == 0) {
                    weakSelf.schoolFilters.licenseType = nil;
                } else {
                    weakSelf.schoolFilters.licenseType = @(indexPath.row);
                }
            } else {
                weakSelf.schoolSortOption = indexPath.row;
            }
            [weakSelf refreshDrivingSchoolList:YES completion:nil];
        };
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        self.refreshHeader = [HHGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        NSString *imgString = [[NSBundle mainBundle] pathForResource:@"loading_car" ofType:@"gif"];
        NSData *imgData = [NSData dataWithContentsOfFile:imgString];
        self.refreshHeader.imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imgData];
        self.tableView.mj_header = self.refreshHeader;
        
        self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self.loadMoreFooter setTitle:@"加载更多驾校" forState:MJRefreshStateIdle];
        [self.loadMoreFooter setTitle:@"一大波驾校接近中~~~" forState:MJRefreshStateRefreshing];
        [self.loadMoreFooter setTitle:@"已经到底啦~再往上选选吧！" forState:MJRefreshStateNoMoreData];
        [self.loadMoreFooter setHidden:YES];
        self.loadMoreFooter.automaticallyRefresh = NO;
        self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
        self.tableView.mj_footer = self.loadMoreFooter;
        
        [self.tableView registerClass:[HHDrivingSchoolListViewCell class] forCellReuseIdentifier:kDrivingSchoolCellId];
        [self.tableView registerClass:[HHHotSchoolsTableViewCell class] forCellReuseIdentifier:kHotSchoolCellId];
        
        [view addSubview:self.tableView];
        
        
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.schoolFilterMenu.bottom);
            make.left.equalTo(view.left);
            make.bottom.equalTo(view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));
            make.width.equalTo(view.width);
        }];
        [self setupDefaultSortAndFilterForSchool];
    }
    
}

- (void)segValueChanged {
    [self.swipeView scrollToPage:self.segControl.selectedSegmentIndex duration:0.3f];
    if (self.segControl.selectedSegmentIndex == ListTypeCoach) {
        [self.tableView2 reloadData];
    } else {
        [self.tableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.toValue = @(CGRectGetWidth(self.view.bounds) + 20.0f);
    [self.floatButton pop_addAnimation:anim forKey:@"move"];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.toValue = @(CGRectGetWidth(self.view.bounds) - 45.0f);
    [self.floatButton pop_addAnimation:anim forKey:@"move"];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        anim.toValue = @(CGRectGetWidth(self.view.bounds) - 45.0f);
        [self.floatButton pop_addAnimation:anim forKey:@"move"];
    }
}

- (void)jumpToOnlineSupport {
    [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
}

- (void)cityChanged {
    self.userCity = [[HHConstantsStore sharedInstance] getCityWithId:[HHStudentStore sharedInstance].selectedCityId];
    [self setupDefaultSortAndFilterForCoach];
    [self setupDefaultSortAndFilterForSchool];
    [self refreshCoachList:NO completion:nil];
    [self refreshDrivingSchoolList:NO completion:nil];
}


#pragma -mark DropDown Delegate & Datasource Methods

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.areas.count;
        
    } else if (column == 1) {
        return self.priceRanges.count;
        
    } else if (column == 2) {
        return self.licenseTypes.count;
        
    } else {
        return self.sortOptions.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.areas[indexPath.row];
        
    } else if (indexPath.column == 1) {
        return self.priceRanges[indexPath.row];
        
    } else if (indexPath.column == 2) {
        return self.licenseTypes[indexPath.row];
        
    } else {
        return self.sortOptions[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column {
    if (column == 0) {
        if (row == 0) {
            return self.distances.count;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            return self.distances[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
}

@end
