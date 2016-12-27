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
#import "HHConstantsStore.h"
#import "HHToastManager.h"
#import "HHCoachService.h"
#import "HHStudentStore.h"
#import "HHPopupUtility.h"
#import <KLCPopup/KLCPopup.h>
#import "HHCoachDetailViewController.h"
#import "HHSearchCoachViewController.h"
#import "HHGifRefreshHeader.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SwipeView.h"
#import "HHPersonalCoachTableViewCell.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHPersonalCoachFilters.h"
#import "HHPersonalCoachFiltersView.h"
#import "HHPersonalCoachSortView.h"
#import "HHPersonalCoachDetailViewController.h"
#import "HHPersonalCoaches.h"
#import "HHAppVersionUtility.h"
#import <pop/POP.h>

typedef NS_ENUM(NSInteger, CoachType) {
    CoachTypeDrivingSchoolCoach,
    CoachTypePersonalCoach,
    CoachTypeCount,
};

static NSString *const kCellId = @"kCoachListCellId";
static NSString *const kPersonalCoachCellId = @"kPersonalCoachCellId";
static NSString *const kFindCoachGuideKey = @"kFindCoachGuideKey";
static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 325.0f;

@interface HHFindCoachViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) UIView *topButtonsView;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;

@property (nonatomic, strong) HHButton *filterButton;
@property (nonatomic, strong) HHButton *sortButton;


@property (nonatomic, strong) UIView *topButtonsView2;
@property (nonatomic, strong) UIView *verticalLine2;
@property (nonatomic, strong) UIView *horizontalLine2;

@property (nonatomic, strong) HHButton *filterButton2;
@property (nonatomic, strong) HHButton *sortButton2;

@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHFiltersView *filtersView;
@property (nonatomic, strong) HHPersonalCoachFiltersView *filtersView2;
@property (nonatomic, strong) HHCoachFilters *coachFilters;
@property (nonatomic, strong) HHPersonalCoachFilters *coachFilters2;

@property (nonatomic, strong) HHSortView *sortView;
@property (nonatomic) SortOption currentSortOption;
@property (nonatomic, strong) HHPersonalCoachSortView *sortView2;
@property (nonatomic) PersonalCoachSortOption currentSortOption2;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) HHGifRefreshHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;
@property (nonatomic, strong) HHGifRefreshHeader *refreshHeader2;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter2;

@property (nonatomic, strong) NSMutableArray *selectedFields;
@property (nonatomic, strong) NSMutableArray *expandedCellIndexPath;

@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSMutableArray *personalCoaches;

@property (nonatomic, strong) HHCity *userCity;
@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) HHCoaches *coachesObject;
@property (nonatomic, strong) HHPersonalCoaches *personalCoachesObject;

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) HHGenericOneButtonPopupView *personalCoachExplanationView;

@property (nonatomic, strong) UIButton *floatButton;

@end

@implementation HHFindCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"寻找教练";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDefaultSortAndFilter];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_maplist_btn"] action:@selector(jumpToFieldsMapView) target:self];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_search"] action:@selector(jumpToSearchVC) target:self];
    
    self.selectedFields = [NSMutableArray array];
    self.expandedCellIndexPath = [NSMutableArray array];
    [self initSubviews];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    self.segControl = [[UISegmentedControl alloc] initWithItems:@[@"驾校教练", @"陪练教练"]];
    self.segControl.tintColor = [UIColor whiteColor];
    [self.segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} forState:UIControlStateNormal];
    [self.segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} forState:UIControlStateSelected];
    self.segControl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segControl.backgroundColor = [UIColor HHOrange];
    [self.segControl addTarget:self action:@selector(segValueChanged) forControlEvents:UIControlEventValueChanged];
    self.segControl.selectedSegmentIndex = CoachTypeDrivingSchoolCoach;
    self.navigationItem.titleView = self.segControl;
    
    __weak HHFindCoachViewController *weakSelf = self;
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [self getUserLocationWithCompletion:^{
        [weakSelf refreshCoachList:NO completion:^{
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [self refreshPersonalCoachList:NO completion:nil];
            //check app version
            [[HHAppVersionUtility sharedManager] checkVersionInVC:weakSelf];
            [self buildFloatButton];
        }];
        
    }];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_viewed attributes:nil];
}

- (void)buildFloatButton {
    self.floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.floatButton setImage:[UIImage imageNamed:@"flyingredbag"] forState:UIControlStateNormal];
    [self.view addSubview:self.floatButton];
    [self.floatButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-70.0f);
        make.right.equalTo(self.view.right);
    }];
}

- (void)refreshCoachList:(BOOL)showLoading completion:(HHRefreshCoachCompletionBlock)completion {
    [self.expandedCellIndexPath removeAllObjects];
    __weak HHFindCoachViewController *weakSelf = self;
    if (showLoading) {
        [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"加载中"];
    }
    NSNumber *lat = @(weakSelf.userLocation.coordinate.latitude);
    NSNumber *lon = @(weakSelf.userLocation.coordinate.longitude);
    NSArray *locationArray = @[lat, lon];
    [[HHCoachService sharedInstance] fetchCoachListWithCityId:[HHStudentStore sharedInstance].currentStudent.cityId filters:weakSelf.coachFilters sortOption:weakSelf.currentSortOption fields:weakSelf.selectedFields userLocation:locationArray completion:^(HHCoaches *coaches, NSError *error) {
        if (!error) {
            weakSelf.coaches = [NSMutableArray arrayWithArray:coaches.coaches];
            weakSelf.coachesObject = coaches;
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


- (void)refreshPersonalCoachList:(BOOL)showLoading completion:(HHRefreshCoachCompletionBlock)completion {
    __weak HHFindCoachViewController *weakSelf = self;
    if (showLoading) {
        [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"加载中"];
    }
   
    [[HHCoachService sharedInstance] fetchPersoanlCoachWithFilters:self.coachFilters2 sortOption:self.currentSortOption2 completion:^(HHPersonalCoaches *coaches, NSError *error) {
        if (!error) {
            weakSelf.personalCoaches = [NSMutableArray arrayWithArray:coaches.coaches];
            weakSelf.personalCoachesObject = coaches;
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

- (void)loadMorePersonalCoachesWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    [[HHCoachService sharedInstance] getMorePersonalCoachWithURL:self.personalCoachesObject.nextPage completion:^(HHPersonalCoaches *coaches, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            [self.personalCoaches addObjectsFromArray:coaches.coaches];
            self.personalCoachesObject = coaches;
            [self.tableView2 reloadData];
        }

    }];

}

- (void)setPersonalCoachesObject:(HHPersonalCoaches *)personalCoachesObject {
    _personalCoachesObject = personalCoachesObject;
    if (!personalCoachesObject.nextPage) {
        if ([self.personalCoaches count]) {
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

- (void)setupDefaultSortAndFilter {
    self.userCity = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    NSNumber *defaultDistance = self.userCity.distanceRanges[self.userCity.distanceRanges.count - 1];
    NSNumber *defaultPrice = [self.userCity.priceRanges lastObject];
    HHCoachFilters *defaultFilters = [[HHCoachFilters alloc] init];
    defaultFilters.price = defaultPrice;
    defaultFilters.distance = defaultDistance;
    defaultFilters.onlyGoldenCoach = @(0);
    defaultFilters.onlyVIPCoach = @(0);
    defaultFilters.licenseType = @(3);
    defaultFilters.onlyVIPCoach = @(0);
    self.coachFilters = defaultFilters;
    
    self.currentSortOption = SortOptionSmartSort;
    
    
    HHPersonalCoachFilters *defaultFilters2 = [[HHPersonalCoachFilters alloc] init];
    defaultFilters2.priceLimit = @(200000);
    defaultFilters2.licenseType = nil;
    
    self.coachFilters2 = defaultFilters2;
    
    self.currentSortOption2 = PersonalCoachSortOptionPrice;
    
    
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
        make.height.equalTo(self.view.height);
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
    
    if ([tableView isEqual:self.tableView]) {
        HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        __weak HHCoachListViewCell *weakCell = cell;
        
        HHCoach *coach = self.coaches[indexPath.row];
        [cell setupCellWithCoach:coach field:[[HHConstantsStore sharedInstance] getFieldWithId:coach.fieldId] userLocation:self.userLocation mapShowed:[weakSelf.expandedCellIndexPath containsObject:indexPath]];
        
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

    } else {
        HHPersonalCoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonalCoachCellId forIndexPath:indexPath];
        [cell setupCellWithCoach:self.personalCoaches[indexPath.row]];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.coaches.count;
    } else {
        return self.personalCoaches.count;
    }
    
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
    __weak HHFindCoachViewController *weakSelf = self;
    if ([tableView isEqual:self.tableView]) {
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
        HHCoach *selectedCoach = self.personalCoaches[indexPath.row];
        HHPersonalCoachDetailViewController *vc = [[HHPersonalCoachDetailViewController alloc] initWithCoach:self.personalCoaches[indexPath.row]];
        vc.coachUpdateBlock = ^(HHPersonalCoach *coach) {
            [weakSelf.personalCoaches replaceObjectAtIndex:indexPath.row withObject:coach];
            [weakSelf.tableView2 reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
         [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_personal_coach_tapped attributes:@{@"coach_id":selectedCoach.coachId}];
    }
    
}



#pragma mark - Button Actions 

- (void)filterTapped {
    __weak HHFindCoachViewController *weakSelf = self;
    self.filtersView = [[HHFiltersView alloc] initWithFilters:[self.coachFilters copy] frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 440.0f) city:self.userCity];
    self.filtersView.confirmBlock = ^(HHCoachFilters *filters){
        weakSelf.coachFilters = filters;
        [weakSelf refreshCoachList:YES completion:nil];
        [weakSelf.popup dismiss:YES];
    };
    self.filtersView.cancelBlock = ^(){
        [weakSelf.popup dismiss:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.filtersView];
    [HHPopupUtility showPopup:self.popup];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_filter_tapped_tapped attributes:nil];
}

- (void)sortTapped {
    __weak HHFindCoachViewController *weakSelf = self;
    self.sortView = [[HHSortView alloc] initWithDefaultSortOption:self.currentSortOption];
    self.sortView.frame = CGRectMake(0, 0, 130.0f, 200.0f);
    self.sortView.selectedOptionBlock = ^(SortOption sortOption){
        weakSelf.currentSortOption = sortOption;
        [weakSelf refreshCoachList:YES completion:nil];
        [weakSelf.popup dismiss:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_sort_tapped attributes:@{@"sort_type":[weakSelf.sortView getSortNameWithSortOption:sortOption]}];
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
            [weakSelf refreshCoachList:YES completion:nil];
        };
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
        [self presentViewController:navVC animated:YES completion:nil];
    } else {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [self getUserLocationWithCompletion:^() {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (weakSelf.userLocation) {
                HHFieldsMapViewController *mapVC = [[HHFieldsMapViewController alloc] initWithUserLocation:weakSelf.userLocation selectedFields:weakSelf.selectedFields];
                mapVC.conformBlock = ^(NSMutableArray *selectedFields) {
                    weakSelf.selectedFields = selectedFields;
                    [weakSelf refreshCoachList:YES completion:nil];

                };
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
                [weakSelf presentViewController:navVC animated:YES completion:nil];
            }
        }];
    }
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_field_icon_tapped attributes:nil];
}



- (void)getUserLocationWithCompletion:(HHUserLocationCompletionBlock)completion {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:2.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            self.userLocation = currentLocation;
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
            
        } else if (status == INTULocationStatusTimedOut) {
            self.userLocation = currentLocation;
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
            
        } else if (status == INTULocationStatusError) {
            self.userLocation = nil;
        } else {
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
    if (self.segControl.selectedSegmentIndex == CoachTypeDrivingSchoolCoach) {
        [self refreshCoachList:NO completion:^{
            [weakSelf.refreshHeader endRefreshing];
        }];
    } else {
        [self refreshPersonalCoachList:NO completion:^{
            [weakSelf.refreshHeader2 endRefreshing];
        }];
    }
    
}

- (void)loadMoreData {
    __weak HHFindCoachViewController *weakSelf = self;
    if (self.segControl.selectedSegmentIndex == CoachTypeDrivingSchoolCoach) {
        [self loadMoreCoachesWithCompletion:^{
            [weakSelf.loadMoreFooter endRefreshing];
        }];
    } else {
        [self loadMorePersonalCoachesWithCompletion:^{
            [weakSelf.loadMoreFooter2 endRefreshing];
        }];
    }
    
}

- (void)jumpToSearchVC {
    HHSearchCoachViewController *vc = [[HHSearchCoachViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:NO completion:nil];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_search_tapped attributes:nil];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        return [[NSMutableAttributedString alloc] initWithString:@"啥？！没有匹配到教练啊/(ㄒoㄒ)/~~点击左上角筛选按钮，并调节距离等因素来寻找更多教练吧!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    } else {
        return [[NSMutableAttributedString alloc] initWithString:@"该城市还没开通哟~敬请期待！" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
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
    return NO;
}

#pragma mark -SwipeView methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return CoachTypeCount;
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
    if (index == CoachTypeDrivingSchoolCoach) {
        self.topButtonsView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topButtonsView.backgroundColor = [UIColor whiteColor];
        [view addSubview:self.topButtonsView];
        
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
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.refreshHeader = [HHGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        NSString *imgString = [[NSBundle mainBundle] pathForResource:@"loading_car" ofType:@"gif"];
        NSData *imgData = [NSData dataWithContentsOfFile:imgString];
        self.refreshHeader.imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imgData];
        self.tableView.mj_header = self.refreshHeader;
        
        self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self.loadMoreFooter setTitle:@"加载更多教练" forState:MJRefreshStateIdle];
        [self.loadMoreFooter setTitle:@"一大波教练接近中~~~" forState:MJRefreshStateRefreshing];
        [self.loadMoreFooter setTitle:@"已经到底啦~再往上选选吧！" forState:MJRefreshStateNoMoreData];
        [self.loadMoreFooter setHidden:YES];
        self.loadMoreFooter.automaticallyRefresh = NO;
        self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
        self.tableView.mj_footer = self.loadMoreFooter;
        
        [self.tableView registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCellId];
        
        [view addSubview:self.tableView];
        
        [self.topButtonsView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.width.equalTo(view.width);
            make.height.mas_equalTo(40.0f);
            make.left.equalTo(view.left);
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
            make.left.equalTo(view.left);
            make.bottom.equalTo(view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));
            make.width.equalTo(view.width);
        }];
    } else {
        self.topButtonsView2 = [[UIView alloc] initWithFrame:CGRectZero];
        self.topButtonsView2.backgroundColor = [UIColor whiteColor];
        [view addSubview:self.topButtonsView2];
        
        self.verticalLine2 = [[UIView alloc] initWithFrame:CGRectZero];
        self.verticalLine2.backgroundColor = [UIColor HHLightLineGray];
        [self.topButtonsView2 addSubview:self.verticalLine2];
        
        self.horizontalLine2 = [[UIView alloc] initWithFrame:CGRectZero];
        self.horizontalLine2.backgroundColor = [UIColor HHLightLineGray];
        [self.topButtonsView2 addSubview:self.horizontalLine2];
        
        self.filterButton2 = [self createTopButtonWithTitle:@"筛选" image:[UIImage imageNamed:@"ic_screen_normal_btn"]];
        [self.filterButton2 addTarget:self action:@selector(filterTapped2) forControlEvents:UIControlEventTouchUpInside];
        [self.topButtonsView2 addSubview:self.filterButton2];
        
        self.sortButton2 = [self createTopButtonWithTitle:@"排序" image:[UIImage imageNamed:@"ic_sort_normal_btn"]];
        [self.sortButton2 addTarget:self action:@selector(sortTapped2) forControlEvents:UIControlEventTouchUpInside];
        [self.topButtonsView2 addSubview:self.sortButton2];
        
        self.tableView2 = [[UITableView alloc] init];
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        self.tableView2.emptyDataSetSource = self;
        self.tableView2.emptyDataSetDelegate = self;
        self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView2.showsVerticalScrollIndicator = NO;
        
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
        
        [self.tableView2 registerClass:[HHPersonalCoachTableViewCell class] forCellReuseIdentifier:kPersonalCoachCellId];
        
        [view addSubview:self.tableView2];
        
        [self.topButtonsView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.width.equalTo(view.width);
            make.height.mas_equalTo(40.0f);
            make.left.equalTo(view.left);
        }];
        
        [self.verticalLine2 makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.topButtonsView2);
            make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
            make.height.mas_equalTo(20.0f);
        }];
        
        [self.horizontalLine2 makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topButtonsView2.bottom);
            make.left.equalTo(self.topButtonsView2.left);
            make.width.equalTo(self.topButtonsView2.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        [self.filterButton2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topButtonsView2.left);
            make.width.equalTo(self.topButtonsView2.width).multipliedBy(0.5f);
            make.height.equalTo(self.topButtonsView2);
            make.top.equalTo(self.topButtonsView2.top);
        }];
        
        [self.sortButton2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verticalLine2.left);
            make.width.equalTo(self.topButtonsView2.width).multipliedBy(0.5f);
            make.height.equalTo(self.topButtonsView2);
            make.top.equalTo(self.topButtonsView2.top);
        }];
        
        [self.tableView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalLine2.bottom);
            make.left.equalTo(view.left);
            make.bottom.equalTo(view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));
            make.width.equalTo(view.width);
        }];
    }
    
}

- (void)segValueChanged {
    [self.swipeView scrollToPage:self.segControl.selectedSegmentIndex duration:0.3f];
    if (self.segControl.selectedSegmentIndex == CoachTypeDrivingSchoolCoach) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_maplist_btn"] action:@selector(jumpToFieldsMapView) target:self];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_search"] action:@selector(jumpToSearchVC) target:self];
        [self.tableView reloadData];
    } else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_explain"] action:@selector(showPersonalCoachExplanation) target:self];
        self.navigationItem.rightBarButtonItem = nil;
        [self.tableView2 reloadData];
    }
}

- (void)showPersonalCoachExplanation {
    __weak HHFindCoachViewController *weakSelf = self;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 3.0f;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"面向初学拿到驾照或有驾照数年未驾过车的客户,提供的陪练服务,包括驾驶技术的提升,驾驶经验的传授,安全应变能力的强化:以及在考驾照中所学不到的交通繁忙道路的实际行驶,使学员在短时间内历练出高超的驾车技术,从而达到安全行车的目的。" attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSParagraphStyleAttributeName:paragraphStyle}];
    self.personalCoachExplanationView = [[HHGenericOneButtonPopupView alloc] initWithTitle:@"什么是陪练教练?" info:string];
    self.personalCoachExplanationView.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.personalCoachExplanationView];
    [HHPopupUtility showPopup:self.popup];
    
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_what_is_personal_coach_tapped attributes:nil];

}

- (void)filterTapped2 {
    __weak HHFindCoachViewController *weakSelf = self;
    self.filtersView2 = [[HHPersonalCoachFiltersView alloc] initWithFilters:self.coachFilters2 frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 210.0f)];
    self.filtersView2.cancelAction = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    self.filtersView2.confirmAction = ^(HHPersonalCoachFilters *filters) {
        weakSelf.coachFilters2 = filters;
        [weakSelf refreshPersonalCoachList:YES completion:nil];
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.filtersView2];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_filter_personal_coach_tapped attributes:nil];
}

- (void)sortTapped2 {
    __weak HHFindCoachViewController *weakSelf = self;
    self.sortView2 = [[HHPersonalCoachSortView alloc] initWithDefaultSortOption:self.currentSortOption2];
    self.sortView2.frame = CGRectMake(0, 0, 130.0f, 80.0f);
    self.sortView2.selectedOptionBlock = ^(PersonalCoachSortOption sortOption){
        weakSelf.currentSortOption2 = sortOption;
        [weakSelf refreshPersonalCoachList:YES completion:nil];
        [weakSelf.popup dismiss:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_sort_personal_coach_tapped attributes:@{@"sort_type":[weakSelf.sortView2 getSortNameWithSortOption:sortOption]}];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.sortView2];
    CGPoint center = CGPointMake(CGRectGetMidX(self.sortButton2.frame), 90.0f);
    [HHPopupUtility showPopup:self.popup AtCenter:center inView:self.view];
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



@end
