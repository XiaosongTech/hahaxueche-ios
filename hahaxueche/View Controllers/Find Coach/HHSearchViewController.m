//
//  HHSearchCoachViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/23/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSearchViewController.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "HHCoachService.h"
#import "HHCoachListViewCell.h"
#import "HHConstantsStore.h"
#import "HHCoachDetailViewController.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentStore.h"
#import "HHSearchHistoryListView.h"
#import "UIScrollView+EmptyDataSet.h"

static NSString *const kCellId = @"kCoachListCellId";

static CGFloat const kCellHeightNormal = 100.0f;
static CGFloat const kCellHeightExpanded = 305.0f;

@interface HHSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSMutableArray *expandedCellIndexPath;
@property (nonatomic, strong) HHSearchHistoryListView *searchHistoryListView;

@end

@implementation HHSearchViewController

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
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keywords = [defaults objectForKey:@"coachSearchKeywords"];
    
    [self buildKeywordHistoryViewWithKeywords:keywords];
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    __weak HHSearchViewController *weakSelf = self;
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keywords = [defaults objectForKey:@"coachSearchKeywords"];
    NSMutableArray *newKeywords = [NSMutableArray arrayWithArray:keywords];
    if ([newKeywords containsObject:searchBar.text]) {
        [newKeywords removeObject:searchBar.text];
    }
    [newKeywords insertObject:searchBar.text atIndex:0];
    [defaults setObject:newKeywords forKey:@"coachSearchKeywords"];
    
    [self buildKeywordHistoryViewWithKeywords:newKeywords];
    self.searchHistoryListView.hidden = YES;
    self.tableView.hidden = NO;
    
    
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


- (void)buildKeywordHistoryViewWithKeywords:(NSArray *)keywords {
    if(self.searchHistoryListView) {
        [self.searchHistoryListView removeFromSuperview];
    }
    __weak HHSearchViewController *weakSelf = self;
    self.searchHistoryListView = [[HHSearchHistoryListView alloc] initWithHistory:keywords];
    self.searchHistoryListView.keywordBlock = ^(NSString *keyword) {
        weakSelf.searchBar.text = keyword;
        [weakSelf searchBarSearchButtonClicked:weakSelf.searchBar];
    };
    [self.view addSubview:self.searchHistoryListView];
    
    [self.searchHistoryListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(([keywords count] + 1) * 40.0f + 45.0f);
    }];

}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSMutableAttributedString alloc] initWithString:@"木有找到匹配的教练, 换个关键词重新试试吧~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    
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


@end
