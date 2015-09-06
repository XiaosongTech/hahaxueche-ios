//
//  HHSearchViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHSearchViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import "HHCoachListTableViewCell.h"
#import "HHCoachProfileViewController.h"
#import "HHCoachService.h"
#import "HHLoadingView.h"
#import "HHLoadingTableViewCell.h"

#define kLoadingCellIDentifier @"loadingCellIdentifier"
#define kCoachCellIdentifier @"CoachListViewCellID"

@interface HHSearchViewController ()

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSMutableArray *coachesArray;

@end

@implementation HHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"取消",nil) action:@selector(dismissView) target:self isLeft:NO];
    self.cancelButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    self.navigationItem.hidesBackButton = YES;
    CGRect searchBarFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-60.0f, 25.0f);
    self.searchBar = [[HHSearchBar alloc] initWithFrame:searchBarFrame];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor whiteColor];
    UIView *searchBarView = [[UIView alloc] initWithFrame:self.searchBar.frame];
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[HHCoachListTableViewCell class] forCellReuseIdentifier:kCoachCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLoadingCellIDentifier];
    [self.view addSubview:self.tableView];
    
    [self autoLayoutSubviews];

}


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.tableView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.tableView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:0],
                             
                             ];
    [self.view addConstraints:constraints];
}
- (void)dismissView {
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self updateTableViewWithSearchQuery:searchBar.text skip:0];
}

- (void)updateTableViewWithSearchQuery:(NSString *)query skip:(NSInteger)skip {
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [[HHCoachService sharedInstance] fetchCoachesWithQuery:query skip:skip completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            self.coachesArray = [NSMutableArray arrayWithArray: objects];
            if (self.coachesArray.count < totalCount) {
                [self.coachesArray addObject:kLoadingCellIDentifier];
            }
            [self.tableView reloadData];
        }

    }];

}

- (void)fetchMoreDataWithSearchQuery:(NSString *)query skip:(NSInteger)skip {
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [[HHCoachService sharedInstance] fetchCoachesWithQuery:query skip:skip completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            if ([[self.coachesArray lastObject] isEqualToString:kLoadingCellIDentifier]) {
                [self.coachesArray removeObject:kLoadingCellIDentifier];
            }
            [self.coachesArray addObjectsFromArray:objects];
            if (self.coachesArray.count < totalCount) {
                [self.coachesArray addObject:kLoadingCellIDentifier];
            }
            [self.tableView reloadData];
        }
    }];

}

#pragma mark Table View Delegate & DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coachesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.coachesArray[indexPath.row] isKindOfClass:[NSString class]]) {
        HHLoadingTableViewCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:kLoadingCellIDentifier forIndexPath:indexPath];
        return loadingCell;
    }
    HHCoachListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachCellIdentifier forIndexPath:indexPath];
    [cell setupCellWithCoach:self.coachesArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachProfileViewController *coachProfiveVC = [[HHCoachProfileViewController alloc] initWithCoach:self.coachesArray[indexPath.row]];
    [self.searchBar resignFirstResponder];
    [self.navigationController pushViewController:coachProfiveVC animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.coachesArray[indexPath.row] isKindOfClass:[NSString class]]) {
        [self fetchMoreDataWithSearchQuery:self.searchBar.text skip:self.coachesArray.count];
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setPreservesSuperviewLayoutMargins:NO];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
}



#pragma mark Hide TabBar

- (BOOL)hidesBottomBarWhenPushed {
    return (self.navigationController.topViewController == self);
}

@end
