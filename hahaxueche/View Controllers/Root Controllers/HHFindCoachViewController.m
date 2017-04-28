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
#import "HHFiltersView.h"
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
#import "SwipeView.h"
#import "HHPersonalCoachTableViewCell.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHAppVersionUtility.h"
#import <pop/POP.h>
#import "HHWebViewController.h"
#import "HHSupportUtility.h"
#import "HHDropDownView.h"

typedef NS_ENUM(NSInteger, ListType) {
    ListTypeDrivingSchool,
    ListTypeCoach,
    ListTypeCount,
};

static NSString *const kCellId = @"kCoachListCellId";
static NSString *const kPersonalCoachCellId = @"kPersonalCoachCellId";
static NSString *const kFindCoachGuideKey = @"kFindCoachGuideKey";
static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 325.0f;

@interface HHFindCoachViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,SwipeViewDataSource, SwipeViewDelegate>


@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic, strong) HHFiltersView *filtersView;
@property (nonatomic, strong) HHFilters *coachFilters;
@property (nonatomic, strong) HHFilters *schoolFilters;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) HHGifRefreshHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;
@property (nonatomic, strong) HHGifRefreshHeader *refreshHeader2;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter2;

@property (nonatomic, strong) NSMutableArray *expandedCellIndexPath;

@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSMutableArray *schools;

@property (nonatomic, strong) HHCity *userCity;
@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) HHCoaches *coachesObject;

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) HHGenericOneButtonPopupView *personalCoachExplanationView;

@property (nonatomic, strong) UIButton *floatButton;
@property (nonatomic, strong) HHDropDownView *dropDownView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic) CoachSortOption coachSortOption;
@property (nonatomic) SchoolSortOption schoolSortOption;

@property (nonatomic) NSInteger filterIndex;

@end

@implementation HHFindCoachViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"驾校教练";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDefaultSortAndFilter];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem  buttonItemWithImage:[UIImage imageNamed:@"ic_map_firstscreen"] action:@selector(jumpToFieldsMapView) target:self];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_search"] action:@selector(jumpToSearchVC) target:self];
    
    self.expandedCellIndexPath = [NSMutableArray array];
    [self initSubviews];
    
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
    [self getUserLocationWithCompletion:^{
        [self refreshDrivingSchoolList:NO completion:^{
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [weakSelf refreshCoachList:NO completion:nil];
            [[HHAppVersionUtility sharedManager] checkVersionInVC:weakSelf];
            [self buildFloatButton];
        }];
        
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
    [self.expandedCellIndexPath removeAllObjects];
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
//    [[HHCoachService sharedInstance] fetchCoachListWithCityId:self.userCity.cityId filters:weakSelf.coachFilters sortOption:weakSelf.currentSortOption userLocation:locationArray fields:nil perPage:nil completion:^(HHCoaches *coaches, NSError *error) {
//        if (!error) {
//            weakSelf.coaches = [NSMutableArray arrayWithArray:coaches.coaches];
//            weakSelf.coachesObject = coaches;
//            [weakSelf.tableView reloadData];
//        } else {
//            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
//        }
//        if (completion) {
//            completion();
//        }
//        if (showLoading) {
//            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
//        }
//        
//        
//    }];
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


- (void)refreshDrivingSchoolList:(BOOL)showLoading completion:(HHRefreshCoachCompletionBlock)completion {
//    __weak HHFindCoachViewController *weakSelf = self;
//    if (showLoading) {
//        [[HHLoadingViewUtility sharedInstance] showLoadingView];
//    }
//   
//    [[HHCoachService sharedInstance] fetchPersoanlCoachWithFilters:self.coachFilters2 sortOption:self.currentSortOption2 completion:^(HHPersonalCoaches *coaches, NSError *error) {
//        if (!error) {
//            weakSelf.personalCoaches = [NSMutableArray arrayWithArray:coaches.coaches];
//            weakSelf.personalCoachesObject = coaches;
//            [weakSelf.tableView2 reloadData];
//        } else {
//            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
//        }
//        if (completion) {
//            completion();
//        }
//        if (showLoading) {
//            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
//        }
//    }];
}

- (void)loadMorePersonalCoachesWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    

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
    self.userCity = [[HHConstantsStore sharedInstance] getCityWithId:[HHStudentStore sharedInstance].selectedCityId];
    self.coachFilters = [[HHFilters alloc] init];
    self.coachFilters.distance = self.userCity.distanceRanges[self.userCity.distanceRanges.count - 1];
    self.coachFilters.zone = nil;
//    self.coachFilters.priceStart =
//    self.coachFilters.priceEnd =
    self.coachSortOption = CoachSortOptionPrice;
    
    self.schoolFilters = [[HHFilters alloc] init];
    self.schoolFilters.distance = self.userCity.distanceRanges[self.userCity.distanceRanges.count - 1];
    self.schoolFilters.zone = nil;
//    self.coachFilters.priceStart =
//    self.coachFilters.priceEnd =
    self.schoolSortOption = SchoolSortOptionDefault;
    
}

- (void)initSubviews {
    __weak HHFindCoachViewController *weakSelf = self;
    self.filtersView = [[HHFiltersView alloc] initWithFilter:nil];
    self.filtersView.itemBlock = ^(HHFilterItemView *itemView) {
        NSInteger index = itemView.tag;
        NSMutableArray *data = [NSMutableArray array];
        if (weakSelf.segControl.selectedSegmentIndex == ListTypeDrivingSchool) {
            
        } else {
            
        }
        
        if (index == 0) {
            NSMutableArray *disArray = [NSMutableArray array];
            for (NSNumber *num in weakSelf.userCity.distanceRanges) {
                [disArray addObject:[NSString stringWithFormat:@"%@km", [num stringValue]]];
            }
            [disArray addObject:@"全城"];
            NSDictionary *distance = @{@"附近":disArray};
            [data addObject:distance];
            [data addObjectsFromArray:weakSelf.userCity.zones];
            
        } else if (index == 1) {
            for (NSArray *rangeArray in weakSelf.userCity.priceRanges) {
                NSString *title = [NSString stringWithFormat:@"%@-%@元", [rangeArray firstObject], rangeArray[1]];
                [data addObject:title];
            }
        } else if (index == 2) {
            [data addObject:@"C1手动挡"];
            [data addObject:@"C2自动挡"];
        } else {
            [data addObject:@"综合排序"];
            [data addObject:@"距离最近"];
            [data addObject:@"评价最多"];
            [data addObject:@"价格最低"];
        }
        
        [weakSelf showDropDownWithData:data itemView:itemView];
    };
    [self.view addSubview:self.filtersView];
    [self.filtersView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(40.0f);

    }];
    
    self.swipeView = [[SwipeView alloc] init];
    self.swipeView.pagingEnabled = YES;
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    [self.view addSubview:self.swipeView];
    [self.swipeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filtersView.bottom);
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
    
    if ([tableView isEqual:self.tableView]) {
        HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
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
        
        cell.drivingSchoolBlock = ^(HHDrivingSchool *school) {
            HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://m.hahaxueche.com/jiaxiao/%@", [school.schoolId stringValue]]]];
            webVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        };
        
        return cell;

    } else {
//        HHPersonalCoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonalCoachCellId forIndexPath:indexPath];
//        [cell setupCellWithCoach:self.personalCoaches[indexPath.row]];
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.coaches.count;
    } else {
        return self.schools.count;
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
        
    }
    
}



#pragma mark - Button Actions 

- (void)filterTapped {
//    __weak HHFindCoachViewController *weakSelf = self;
//    self.filtersView = [[HHFiltersView alloc] initWithFilters:[self.coachFilters copy] frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 440.0f) city:self.userCity];
//    self.filtersView.confirmBlock = ^(HHFilters *filters){
//        weakSelf.coachFilters = filters;
//        [weakSelf refreshCoachList:YES completion:nil];
//        [weakSelf.popup dismiss:YES];
//    };
//    self.filtersView.cancelBlock = ^(){
//        [weakSelf.popup dismiss:YES];
//    };
//    self.popup = [HHPopupUtility createPopupWithContentView:self.filtersView];
//    [HHPopupUtility showPopup:self.popup];
//    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_filter_tapped_tapped attributes:nil];
}

- (void)sortTapped {
//    __weak HHFindCoachViewController *weakSelf = self;
//    self.sortView = [[HHSortView alloc] initWithDefaultSortOption:self.currentSortOption];
//    self.sortView.frame = CGRectMake(0, 0, 130.0f, 200.0f);
//    self.sortView.selectedOptionBlock = ^(SortOption sortOption){
//        weakSelf.currentSortOption = sortOption;
//        [weakSelf refreshCoachList:YES completion:nil];
//        [weakSelf.popup dismiss:YES];
//        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_sort_tapped attributes:@{@"sort_type":[weakSelf.sortView getSortNameWithSortOption:sortOption]}];
//    };
//    self.popup = [HHPopupUtility createPopupWithContentView:self.sortView];
//    CGPoint center = CGPointMake(CGRectGetMidX(self.sortButton.frame), 150.0f);
//    [HHPopupUtility showPopup:self.popup AtCenter:center inView:self.view];
    

}


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
            [weakSelf.refreshHeader endRefreshing];
        }];
    } else {
        [self refreshDrivingSchoolList:NO completion:^{
            [weakSelf.refreshHeader2 endRefreshing];
        }];
    }
    
}

- (void)loadMoreData {
    __weak HHFindCoachViewController *weakSelf = self;
    if (self.segControl.selectedSegmentIndex == ListTypeCoach) {
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
    HHSearchViewController *vc = [[HHSearchViewController alloc] init];
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
    if (index == ListTypeCoach) {
        
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
        
        
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.top);
            make.left.equalTo(view.left);
            make.bottom.equalTo(view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));
            make.width.equalTo(view.width);
        }];
    } else {
        
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
        [self.loadMoreFooter2 setTitle:@"加载更多驾校" forState:MJRefreshStateIdle];
        [self.loadMoreFooter2 setTitle:@"一大波驾校接近中~~~" forState:MJRefreshStateRefreshing];
        [self.loadMoreFooter2 setTitle:@"已经到底啦~再往上选选吧！" forState:MJRefreshStateNoMoreData];
        [self.loadMoreFooter2 setHidden:YES];
        self.loadMoreFooter2.automaticallyRefresh = NO;
        self.loadMoreFooter2.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        self.loadMoreFooter2.stateLabel.textColor = [UIColor HHLightTextGray];
        self.tableView2.mj_footer = self.loadMoreFooter2;
        
        [self.tableView2 registerClass:[HHPersonalCoachTableViewCell class] forCellReuseIdentifier:kPersonalCoachCellId];
        
        [view addSubview:self.tableView2];
        
        
        [self.tableView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.top);
            make.left.equalTo(view.left);
            make.bottom.equalTo(view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));
            make.width.equalTo(view.width);
        }];
    }
    
}

- (void)segValueChanged {
    [self.swipeView scrollToPage:self.segControl.selectedSegmentIndex duration:0.3f];
    if (self.segControl.selectedSegmentIndex == ListTypeCoach) {
        [self.tableView reloadData];
    } else {
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
//    __weak HHFindCoachViewController *weakSelf = self;
//    self.filtersView2 = [[HHPersonalCoachFiltersView alloc] initWithFilters:self.coachFilters2 frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 210.0f)];
//    self.filtersView2.cancelAction = ^() {
//        [HHPopupUtility dismissPopup:weakSelf.popup];
//    };
//    self.filtersView2.confirmAction = ^(HHPersonalCoachFilters *filters) {
//        weakSelf.coachFilters2 = filters;
//        [weakSelf refreshDrivingSchoolList:YES completion:nil];
//        [HHPopupUtility dismissPopup:weakSelf.popup];
//    };
//    self.popup = [HHPopupUtility createPopupWithContentView:self.filtersView2];
//    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
//    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_filter_personal_coach_tapped attributes:nil];
}

- (void)sortTapped2 {
//    __weak HHFindCoachViewController *weakSelf = self;
//    self.sortView2 = [[HHPersonalCoachSortView alloc] initWithDefaultSortOption:self.currentSortOption2];
//    self.sortView2.frame = CGRectMake(0, 0, 130.0f, 80.0f);
//    self.sortView2.selectedOptionBlock = ^(PersonalCoachSortOption sortOption){
//        weakSelf.currentSortOption2 = sortOption;
//        [weakSelf refreshDrivingSchoolList:YES completion:nil];
//        [weakSelf.popup dismiss:YES];
//        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:find_coach_page_sort_personal_coach_tapped attributes:@{@"sort_type":[weakSelf.sortView2 getSortNameWithSortOption:sortOption]}];
//    };
//    self.popup = [HHPopupUtility createPopupWithContentView:self.sortView2];
//    CGPoint center = CGPointMake(CGRectGetMidX(self.sortButton2.frame), 90.0f);
//    [HHPopupUtility showPopup:self.popup AtCenter:center inView:self.view];
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
    [self setupDefaultSortAndFilter];
    [self refreshCoachList:NO completion:nil];
    [self refreshDrivingSchoolList:NO completion:nil];
}


- (void)showDropDownWithData:(NSArray *)data itemView:(HHFilterItemView *)itemView {
    NSInteger columnCount = 1;
    NSInteger index = itemView.tag;
    if (index == 0) {
        columnCount = 2;
    }
    
    if (!self.bgView) {
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        [self.view addSubview:self.bgView];
        [self.bgView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(self.view.width);
            make.height.equalTo(self.view.height);
        }];
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownView)];
        [self.bgView addGestureRecognizer:rec];
    }
    
    
    if (self.dropDownView) {
        [self dismissDropDownView];
        if (index == self.filterIndex) {
            return;
        }
    }
    
    
    CGFloat height = data.count * 40.0f;
    if (height > 8 * 40.0f) {
        height = 40.0f * 8;
    }
    self.dropDownView = [[HHDropDownView alloc] initWithColumnCount:columnCount data:data selectedIndexes:@[@(0), @(1)]];
    self.dropDownView.frame = CGRectMake(0, -1.0f * height + CGRectGetMaxY(self.filtersView.frame), CGRectGetWidth(self.view.frame), height);
    [self.view addSubview:self.dropDownView];
    [self.view bringSubviewToFront:self.filtersView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectGetMaxY(self.filtersView.frame), CGRectGetWidth(self.view.frame), height)];
    anim.springBounciness = 0;
    [self.dropDownView pop_addAnimation:anim forKey:@"move"];
    self.bgView.hidden = NO;
    itemView.imgView.image = [UIImage imageNamed:@"list_arrow_orange"];
    
    self.filterIndex = index;
}


- (void)dismissDropDownView {
    [self.dropDownView removeFromSuperview];
    self.dropDownView = nil;
    self.bgView.hidden = YES;
    
    for (HHFilterItemView *view in self.filtersView.itemArray) {
        view.imgView.image = [UIImage imageNamed:@"list_arrow_gray"];
    }
}

@end
