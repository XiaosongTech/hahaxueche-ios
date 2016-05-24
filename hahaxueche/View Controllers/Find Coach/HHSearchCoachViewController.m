//
//  HHSearchCoachViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/23/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSearchCoachViewController.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "HHCoachService.h"
#import "HHCoachListViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import "HHConstantsStore.h"
#import "HHCoachDetailViewController.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentStore.h"
#import "HHSearchCoachEmptyCell.h"
#import "HHSearchHistoryListView.h"

static NSString *const kCellId = @"kCoachListCellId";
static NSString *const kEmptyCellId = @"kEmptyCellId";

static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 300.0f;

@interface HHSearchCoachViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSMutableArray *expandedCellIndexPath;
@property (nonatomic, strong) UIView *searchHistoryListView;

@end

@implementation HHSearchCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.expandedCellIndexPath = [NSMutableArray array];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.tintColor = [UIColor HHOrange];
    self.searchBar.placeholder = @"搜索教练姓名";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"取消" titleColor:[UIColor whiteColor] action:@selector(popupVC) target:self isLeft:NO];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCellId];
    [self.tableView registerClass:[HHSearchCoachEmptyCell class] forCellReuseIdentifier:kEmptyCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keywords = [defaults objectForKey:@"coachSearchKeywords"];
    
    self.searchHistoryListView = [[HHSearchHistoryListView alloc] initWithHistory:keywords];
    [self.view addSubview:self.searchHistoryListView];
    
    [self.searchHistoryListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(([keywords count] + 1) * 40.0f);
    }];
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.coaches count]) {
        HHSearchCoachEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellId forIndexPath:indexPath];
        return cell;
    }
    
    
    HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    __weak HHSearchCoachViewController *weakSelf = self;
    __weak HHCoachListViewCell *weakCell = cell;
    
    HHCoach *coach = self.coaches[indexPath.row];
    [cell setupCellWithCoach:coach field:[[HHConstantsStore sharedInstance] getFieldWithId:coach.fieldId] userLocation:[HHStudentStore sharedInstance].currentLocation];
    
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
    if ([self.coaches count]) {
        return self.coaches.count;
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.coaches count]) {
        if ([self.expandedCellIndexPath containsObject:indexPath]) {
            return kCellHeightExpanded;
        } else {
            return kCellHeightNormal;
        }
    } else {
        return CGRectGetHeight(self.view.bounds);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.coaches count]) {
        HHCoachDetailViewController *coachDetailVC = [[HHCoachDetailViewController alloc] initWithCoach:self.coaches[indexPath.row]];
        coachDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coachDetailVC animated:YES];
    }
}

- (void)popupVC {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchHistoryListView.hidden = YES;
    self.tableView.hidden = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keywords = [defaults objectForKey:@"coachSearchKeywords"];
    NSMutableArray *newKeywords = [NSMutableArray arrayWithArray:keywords];
    if ([newKeywords containsObject:searchBar.text]) {
        [newKeywords removeObject:searchBar.text];
    }
    [newKeywords insertObject:searchBar.text atIndex:0];
    [defaults setObject:newKeywords forKey:@"coachSearchKeywords"];
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHCoachService sharedInstance] searchCoachWithKeyword:searchBar.text completion:^(NSArray *coaches, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            [self.searchBar resignFirstResponder];
            self.coaches = [NSMutableArray arrayWithArray:coaches];
            [self.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tableView.hidden = YES;
    self.searchHistoryListView.hidden = NO;
}



@end
