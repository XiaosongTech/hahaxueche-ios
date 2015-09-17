//
//  HHCoachListViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachListViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHButton.h"
#import "UIColor+HHColor.h"
#import <pop/POP.h>
#import "UIView+HHRect.h"
#import "HHSearchBar.h"
#import "HHCoachListTableViewCell.h"
#import "HHCoachService.h"
#import "HHCoachProfileViewController.h"
#import "HHLoadingView.h"
#import "HHMapViewController.h"
#import "HHSearchViewController.h"
#import "HHNavigationController.h"
#import "HHTrainingFieldService.h"
#import "CMPopTipView.h"
#import "HHPointAnnotation.h"
#import "HHToastUtility.h"


#define kSmartSortString NSLocalizedString(@"智能排序",nil)
#define kBestRatingString NSLocalizedString(@"评价最好", nil)
#define kPopularCoach NSLocalizedString(@"人气最旺", nil)
#define kLowestPriceString NSLocalizedString(@"价格最低", nil)

#define kCourseTwoString NSLocalizedString(@"科目二", nil)
#define kCourseThreeString NSLocalizedString(@"科目三",nil)

#define kCoachListViewCellIdentifier @"coachListViewCellIdentifier"


@interface HHCoachListViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CMPopTipViewDelegate, MKMapViewDelegate>

@property (nonatomic, strong) HHButton *floatSortButton;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) NSMutableArray *floatButtonsArray;
@property (nonatomic)         SortOption currentSortOption;
@property (nonatomic)         CourseOption currentCourseOption;
@property (nonatomic, strong) HHButton *firstDropDownButton;
@property (nonatomic, strong) HHButton *secondDropDownButton;
@property (nonatomic, strong) HHButton *firstSortButton;
@property (nonatomic, strong) HHButton *secondSortButton;
@property (nonatomic, strong) HHButton *thirdSortButton;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic)         BOOL isfloatButtonsActive;
@property (nonatomic)         BOOL isdropDownButtonsActive;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *coachesArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) CMPopTipView *mapTipView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic)         BOOL isFetchingMoreCoaches;
@property (nonatomic)         BOOL isFetchingCoaches;
@property (nonatomic) BOOL shouldFetchMore;

@property (assign, nonatomic) CATransform3D initialTransformation;

@end

@implementation HHCoachListViewController

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)setCurrentSortOption:(SortOption)currentSortOption {
    _currentSortOption = currentSortOption;
    self.coachesArray = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldFetchMore = YES;
    self.navigationItem.title = @"教练";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentCourseOption = CourseAllInOne;
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.currentSortOption = SortOptionSmartSort;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [self fetchDataWithCompletion:^{
        [[HHLoadingView sharedInstance] hideLoadingView];
    }];
    [self initSubviews];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)fetchDataWithCompletion:(HHGenericCompletion)completion {
    if (self.isFetchingCoaches) {
        return;
    }
    self.isFetchingCoaches = YES;
    [[HHCoachService sharedInstance] fetchCoachesWithTraningFields:[HHTrainingFieldService sharedInstance].selectedFields skip:0 courseOption:self.currentCourseOption sortOption:self.currentSortOption completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
        self.isFetchingCoaches = NO;
        if (!error) {
            [self.coachesArray removeAllObjects];
            [self.coachesArray addObjectsFromArray:objects];
            if (self.coachesArray.count < totalCount) {
                self.shouldFetchMore = YES;
            } else {
                self.shouldFetchMore = NO;
            }
            if ([self.coachesArray count]) {
                [self.tableView reloadData];
            }
            
            if (completion) {
                completion();
            }
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据时出错！", nil) isError:YES];
        }
    }];
    
}

- (void)fetchMoreDataWithCompletion:(HHGenericCompletion)completion {
    [[HHCoachService sharedInstance] fetchCoachesWithTraningFields:[HHTrainingFieldService sharedInstance].selectedFields skip:self.coachesArray.count-1 courseOption:self.currentCourseOption sortOption:self.currentSortOption completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
        self.isFetchingMoreCoaches = NO;
        if (!error) {
            [self.coachesArray addObjectsFromArray:objects];
            if (self.coachesArray.count < totalCount) {
                self.shouldFetchMore = YES;
            } else {
                self.shouldFetchMore = NO;
            }
            [self.tableView reloadData];
            if (completion) {
                completion();
            }
        }
    }];

}

-(void)initSubviews {
    [self initNavBarItems];
    [self initTableView];
    [self initFloatButtons];
    [self autoLayoutSubviews];
}

- (void)initNavBarItems {
    UIBarButtonItem *mapItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"map"] action:@selector(mapIconPressed) target:self];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, mapItem]];
    
    UIBarButtonItem *searchButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"search"] action:@selector(searchIconPressed) target:self];
    UIBarButtonItem *positiveSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    positiveSpacer.width = -8.0f;//
    [self.navigationItem setRightBarButtonItems:@[positiveSpacer, searchButton]];

}

- (void)searchIconPressed {
    HHSearchViewController *searchViewController = [[HHSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:NO];

}

- (void)mapIconPressed {
    HHMapViewController *mapVC = [[HHMapViewController alloc] init];
    mapVC.selectedCompletion = ^(){
        self.coachesArray = [NSMutableArray array];
        [self fetchDataWithCompletion:nil];
    };
    [self presentViewController:mapVC animated:YES completion:nil];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[HHCoachListTableViewCell class] forCellReuseIdentifier:kCoachListViewCellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshData {
    __weak HHCoachListViewController *weakSelf = self;
    self.coachesArray = [NSMutableArray array];
    [self fetchDataWithCompletion:^(){
        [weakSelf.refreshControl endRefreshing];
    }];

}



- (void)initFloatButtons {
    
    self.currentSortOption = SortOptionSmartSort;
    
    self.firstSortButton = [self createFloatButtonWithTitle:kLowestPriceString textColor:[UIColor darkTextColor]];
    
    self.secondSortButton = [self createFloatButtonWithTitle:kBestRatingString textColor:[UIColor darkTextColor]];
    
    self.thirdSortButton = [self createFloatButtonWithTitle:kPopularCoach textColor:[UIColor darkTextColor]];
    
    self.floatSortButton = [[HHButton alloc] initFloatButtonWithTitle:kSmartSortString frame:CGRectMake(CGRectGetWidth(self.view.bounds)-110.0f, CGRectGetHeight(self.view.bounds)-160.0f, 100.0f, 30.0f) backgroundColor:[UIColor HHOrange] textColor:[UIColor whiteColor]];
    [self.view addSubview:self.floatSortButton];
    [self.floatSortButton addTarget:self action:@selector(popupFloatButtons) forControlEvents:UIControlEventTouchUpInside];
    
    self.floatButtonsArray = [NSMutableArray arrayWithArray:@[self.floatSortButton, self.firstSortButton, self.secondSortButton, self.thirdSortButton]];
}

- (HHButton *)createFloatButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor {
    HHButton *button = [[HHButton alloc] initFloatButtonWithTitle:title frame:CGRectMake(CGRectGetWidth(self.view.bounds)-110.0f, CGRectGetHeight(self.view.bounds)-160.0f, 100.0f, 30.0f) backgroundColor:[UIColor whiteColor] textColor:textColor];
    
    [button addTarget:self action:@selector(floatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.tableView constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.tableView constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.tableView constant:-CGRectGetHeight(self.tabBarController.tabBar.bounds)],
                             
                             
                             ];
    [self.view addConstraints:constraints];
}

- (void)floatButtonPressed:(id)sender {
    HHButton *button = sender;
    NSString *buttonTitle = button.titleLabel.text;
    [button setTitle:self.floatSortButton.titleLabel.text forState:UIControlStateNormal];
    [self.floatSortButton setTitle:buttonTitle forState:UIControlStateNormal];
    self.currentSortOption = [self stringToEnum:buttonTitle];
    __weak HHCoachListViewController *weakSelf = self;
    [self.coachesArray removeAllObjects];
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中", nil)];
    [self fetchDataWithCompletion:^{
        [[HHLoadingView sharedInstance] hideLoadingView];
        weakSelf.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
    }];
    [self popupFloatButtons];
}


- (SortOption)stringToEnum:(NSString *)string {
    SortOption selectedOption = SortOptionSmartSort;
    
    if ([string isEqualToString:kSmartSortString]) {
        selectedOption = SortOptionSmartSort;
        
    } else if ([string isEqualToString:kPopularCoach]) {
        selectedOption = SortOptionMostPopular;
        
    } else if ([string isEqualToString:kLowestPriceString]) {
        selectedOption = SortOptionLowestPrice;
        
    } else if ([string isEqualToString:kBestRatingString]) {
        selectedOption = SortOptionBestRating;
    }
    
    return selectedOption;

}

- (void)popupFloatButtons {
    if (self.isfloatButtonsActive) {
        [self.overlay removeFromSuperview];
        self.overlay = nil;
        [self floatButtonAnimateUp:NO];
        self.isfloatButtonsActive = NO;
    } else {
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        [self.overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped)];
        [self.overlay addGestureRecognizer:recognizer];
        [self.view insertSubview:self.overlay belowSubview:self.firstSortButton];
        [self floatButtonAnimateUp:YES];
        self.isfloatButtonsActive = YES;
    }
}

- (void)overlayTapped {
    [self popupFloatButtons];
}

- (void)floatButtonAnimateUp:(BOOL)isUp {
    int i =0;
    for (HHButton *button in self.floatButtonsArray) {
        POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
        springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
        CGRect newFrame = button.frame;
        if (isUp) {
            newFrame = CGRectMake(CGRectGetMinX(self.floatSortButton.frame), CGRectGetMinY(self.floatSortButton.frame)-i*50.0f, CGRectGetWidth(self.floatSortButton.frame), CGRectGetHeight(self.floatSortButton.frame));
             springAnimation.springBounciness = 10.0f;
        } else {
            newFrame = self.floatSortButton.frame;
             springAnimation.springBounciness = 0;
        }
        springAnimation.toValue = [NSValue valueWithCGRect:newFrame];
        springAnimation.name = @"floatButtonPopup";
        springAnimation.delegate = self;
        [button pop_addAnimation:springAnimation forKey:@"floatButtonPopup"];
        i++;
    }
}

#pragma mark Tableview Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coachesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachListViewCellIdentifier forIndexPath:indexPath];
    HHCoach *coach = self.coachesArray[indexPath.row];
    [cell setupCellWithCoach:coach];
    NSArray *filteredarray = [[HHTrainingFieldService sharedInstance].supportedFields filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(objectId == %@)", coach.trainingFieldId]];
    HHTrainingField *field = [filteredarray firstObject];
    [cell setupAddressViewWithTitle:field.district];
    __weak HHCoachListTableViewCell *weakCell = cell;
    cell.addressBlock = ^(){
        [self addMapVIewToCell:weakCell field:field];
    };
    return cell;
}


- (void)addMapVIewToCell:(HHCoachListTableViewCell *)cell field:(HHTrainingField *)field{
    if (!self.mapTipView){
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 180.0f)];
        self.mapView.delegate = self;
        HHPointAnnotation *point = [[HHPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]);
        point.title = field.name;
        point.subtitle = field.address;
        [self.mapView addAnnotation:point];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([field.latitude doubleValue]+0.005, [field.longitude doubleValue]), 2000, 2000);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
        self.mapTipView = [[CMPopTipView alloc] initWithCustomView:self.mapView];
        self.mapTipView.borderColor = [UIColor clearColor];
        self.mapTipView.has3DStyle = NO;
        self.mapTipView.backgroundColor = [UIColor HHOrange];
        self.mapTipView.disableTapToDismiss = YES;
        self.mapTipView.dismissTapAnywhere = YES;
        self.mapTipView.sidePadding = 2.0f;
        self.mapTipView.topMargin = 0;
        self.mapTipView.pointerSize = 5.0f;
        self.mapTipView.cornerRadius = 2.0f;
        self.mapTipView.delegate = self;
        [self.mapTipView presentPointingAtView:cell.addressLabel inView:self.view animated:YES];
    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
   self.mapTipView = nil;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 15.f;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.coachesArray.count < 1) {
        return 0;
    }
    if ([self.coachesArray[indexPath.row] isKindOfClass:[NSString class]]) {
        return 30.0;
    }
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachProfileViewController *coachProfiveVC = [[HHCoachProfileViewController alloc] initWithCoach:self.coachesArray[indexPath.row]];
    [self.navigationController pushViewController:coachProfiveVC animated:YES];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"HHPinID";
    pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    pinView.image = [UIImage imageNamed:@"car_icon"];
    pinView.canShowCallout = YES;
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
        [mapView selectAnnotation:currentAnnotation animated:NO];

    }
}

#pragma -mark Hide TabBar
- (BOOL)hidesBottomBarWhenPushed {
    return NO;
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldFetchMore) {
            return;
        }
        [self fetchMoreDataWithCompletion:nil];
    }
}

@end
