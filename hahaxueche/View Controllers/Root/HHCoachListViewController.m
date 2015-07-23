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


typedef enum : NSUInteger {
    SortOptionSmartSort,
    SortOptionLowestPrice,
    SortOptionBestRating,
    SortOptionMostRating,
} SortOption;

typedef enum : NSUInteger {
    CourseTwo,
    CourseThree,
} CourseOption;

#define kSmartSortString @"智能排序"
#define kBestRatingString @"评价最好"
#define kPopularCoach @"人气最旺"
#define kLowestPriceString @"价格最低"

#define kCourseTwoString @"科目二"
#define kCourseThreeString @"科目三"

#define kCoachListViewCellIdentifier @"coachListViewCellIdentifier"



@interface HHCoachListViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MKMapViewDelegate>

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
@property (nonatomic, strong) HHSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *coachesArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (assign, nonatomic) CATransform3D initialTransformation;

@end

@implementation HHCoachListViewController

- (void)setCurrentCourseOption:(CourseOption)currentCourseOption {
    _currentCourseOption = currentCourseOption;
    
    NSString *courseSting = nil;
    switch (self.currentCourseOption) {
        case CourseTwo: {
            courseSting = kCourseTwoString;
        }
            break;
            
        case CourseThree: {
            courseSting = kCourseThreeString;
        }
            break;
            
        default:{
            courseSting = kCourseTwoString;
        }
            break;
    }
    
    if (!self.title) {
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleButton setTitle:[NSString stringWithFormat:@"教练 (%@) \u25BE", courseSting] forState:UIControlStateNormal];
        self.titleButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Medium" size:15.0f];
        [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleButton.backgroundColor = [UIColor clearColor];
        [self.titleButton addTarget:self action:@selector(titleViewPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = self.titleButton;
        [self.titleButton setFrameWithHeight:20.0f];
        [self.titleButton setFrameWithY:0];
    } else {
        [self.titleButton setTitle:[NSString stringWithFormat:@"教练 (%@)", courseSting] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self fetchDataWithStartIndex:0];
    self.view.backgroundColor = [UIColor clearColor];
    self.currentCourseOption = CourseTwo;
    [self initSubviews];
}

- (void)fetchDataWithStartIndex:(NSInteger)index {
    self.coachesArray = [NSMutableArray array];
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [[HHCoachService sharedInstance] fetchCoachesWithTraningFieldIds:nil startIndex:self.coachesArray.count completion:^(NSArray *objects, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            self.coachesArray = [NSMutableArray arrayWithArray: objects];
            [self.tableView reloadData];
        }
    }];
    
}

-(void)initSubviews {
    [self initNavBarItems];
    [self initTableView];
    [self initSearchBar];
    [self initFloatButtons];
    [self initDropdownButtons];
    [self autoLayoutSubviews];
}

- (void)initNavBarItems {
    UIBarButtonItem *mapItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"map"] action:@selector(mapIconPressed) target:self];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, mapItem]];

}

- (void)mapIconPressed {
    
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
    self.coachesArray = [NSMutableArray array];
    [[HHCoachService sharedInstance] fetchCoachesWithTraningFieldIds:nil startIndex:self.coachesArray.count completion:^(NSArray *objects, NSError *error) {
        [self.refreshControl endRefreshing];
        if (!error) {
            self.coachesArray = [NSMutableArray arrayWithArray: objects];
            [self.tableView reloadData];
        }
    }];

}

- (void)initSearchBar {
    self.searchBar = [[HHSearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 25.0f)];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索教练";
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 30.0f)];
    searchBarView.backgroundColor = [UIColor clearColor];
    [searchBarView addSubview:self.searchBar];
    self.tableView.tableHeaderView = searchBarView;
    
}


- (void)cancelButtonPressed {
    [self dropDownButtonsAnimate];
}


- (void)titleViewPressed {
    [self dropDownButtonsAnimate];
}

- (void)dropDownButtonsAnimate {
    if (self.isdropDownButtonsActive) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.overlay removeFromSuperview];
        self.overlay = nil;
        
    } else {
        UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:@"取消" action:@selector(cancelButtonPressed) target:self isLeft:NO];
        [self.navigationItem setRightBarButtonItems:@[cancelButton]];
        
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        [self.overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayForDropDownTapped)];
        [self.overlay addGestureRecognizer:recognizer];
        [self.view insertSubview:self.overlay belowSubview:self.firstDropDownButton];
    }
    [self dropDownButtonAnimateDown:!self.isdropDownButtonsActive button:self.firstDropDownButton];
    [self dropDownButtonAnimateDown:!self.isdropDownButtonsActive button:self.secondDropDownButton];
    self.isdropDownButtonsActive = !self.isdropDownButtonsActive;
}

- (void)overlayForDropDownTapped {
    [self dropDownButtonsAnimate];
}

- (void)initDropdownButtons {
    self.firstDropDownButton = [self createDropDownButtonWithTitle:kCourseTwoString];
    self.secondDropDownButton = [self createDropDownButtonWithTitle:kCourseThreeString];
    
}

- (HHButton *)createDropDownButtonWithTitle:(NSString *)title {
    HHButton *button = [[HHButton alloc] initDropDownButtonWithTitle:title frame:CGRectMake(0, 20.0f, CGRectGetWidth(self.view.bounds), 44.0f)];
    button.hidden = YES;
    [button addTarget:self action:@selector(dropDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view insertSubview:button belowSubview:self.navigationController.navigationBar];
    return button;
}

- (void)dropDownButtonPressed:(id)sender {
    HHButton *button = sender;
    if ([button.titleLabel.text isEqualToString:kCourseTwoString]) {
        self.currentCourseOption = CourseTwo;
    } else {
        self.currentCourseOption = CourseThree;
    }
    [self dropDownButtonsAnimate];
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
    [self popupFloatButtons];
}

- (SortOption)stringToEnum:(NSString *)string {
    SortOption selectedOption = SortOptionSmartSort;
    
    if ([string isEqualToString:kSmartSortString]) {
        selectedOption = SortOptionSmartSort;
        
    } else if ([string isEqualToString:kPopularCoach]) {
        selectedOption = SortOptionMostRating;
        
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

- (void)dropDownButtonAnimateDown:(BOOL)isDown button:(HHButton *)button {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    CGFloat offsetY = 0;
    if ([button isEqual:self.firstDropDownButton]) {
        offsetY = CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20.0f;
    } else {
        offsetY = CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20.0f + CGRectGetHeight(button.bounds);
    }
    
    CGRect toFrame = CGRectZero;
    if (isDown) {
        toFrame = CGRectMake(0, offsetY, CGRectGetWidth(self.view.bounds), 44.0f);
    } else {
        toFrame = CGRectMake(0, 20.0f, CGRectGetWidth(self.view.bounds), 44.0f);
    }
   
    springAnimation.springBounciness = 0;
    springAnimation.toValue = [NSValue valueWithCGRect:toFrame];
    springAnimation.name = @"floatButtonPopup";
    springAnimation.delegate = self;
    [button pop_addAnimation:springAnimation forKey:@"dropDown"];
    button.hidden = !button.hidden;
}

#pragma mark Tableview Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coachesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachListViewCellIdentifier forIndexPath:indexPath];
    [cell setupCellWithCoach:self.coachesArray[indexPath.row]];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
//    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];    
//    springAnimation.springBounciness = 0;
//    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)];
//    springAnimation.name = @"scaleCell";
//    springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(15, 10)];
//    springAnimation.delegate = self;
//    [cell pop_addAnimation:springAnimation forKey:@"scaleCell"];

//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34 = 1.0/ -600;
//    
//    
//    //2. Define the initial state (Before the animation)
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    cell.layer.transform = rotation;
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    
//    //3. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.5];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachProfileViewController *coachProfiveVC = [[HHCoachProfileViewController alloc] initWithCoach:self.coachesArray[indexPath.row]];
    [self.navigationController pushViewController:coachProfiveVC animated:YES];
}



#pragma mark Search Bar Delegate 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

@end
