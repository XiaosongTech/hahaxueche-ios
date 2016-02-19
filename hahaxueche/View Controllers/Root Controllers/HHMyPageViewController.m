//
//  HHMyPageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageViewController.h"
#import "ParallaxHeaderView.h"
#import "HHMyPageUserInfoCell.h"
#import "UIColor+HHColor.h"
#import "HHMyPageCoachCell.h"
#import "HHMyPageSupportCell.h"
#import "HHMyPageHelpCell.h"
#import "HHMyPageLogoutCell.h"
#import "HHMyCoachDetailViewController.h"

static NSString *const kUserInfoCell = @"userInfoCell";
static NSString *const kCoachCell = @"coachCell";
static NSString *const kSupportCell = @"supportCell";
static NSString *const kHelpCell = @"helpCell";
static NSString *const kLogoutCell = @"logoutCell";

typedef NS_ENUM(NSInteger, MyPageCell) {
    MyPageCellUserInfo,
    MyPageCellCoach,
    MyPageCellSupport,
    MyPageCellHelp,
    MyPageCellLogout,
    MyPageCellCount,
};

@interface HHMyPageViewController() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的页面";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    
    [self initSubviews];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)- CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor HHBackgroundGary];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHMyPageUserInfoCell class] forCellReuseIdentifier:kUserInfoCell];
    [self.tableView registerClass:[HHMyPageCoachCell class] forCellReuseIdentifier:kCoachCell];
    [self.tableView registerClass:[HHMyPageSupportCell class] forCellReuseIdentifier:kSupportCell];
    [self.tableView registerClass:[HHMyPageHelpCell class] forCellReuseIdentifier:kHelpCell];
    [self.tableView registerClass:[HHMyPageLogoutCell class] forCellReuseIdentifier:kLogoutCell];

    UIImageView *topBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150.0f)];
    topBackgroundView.backgroundColor = [UIColor blackColor];
    //topBackgroundView.image = [UIImage imageNamed:@"pic_local"];
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"pic_local"] forSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 150.0f)];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MyPageCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak HHMyPageViewController *weakSelf = self;
    switch (indexPath.row) {
        case MyPageCellUserInfo: {
            HHMyPageUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCell];
            [cell setupCellWithStudent:nil];
            return cell;
            
        } break;
            
        case MyPageCellCoach: {
            HHMyPageCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachCell];
            cell.myCoachView.actionBlock = ^(){
                HHMyCoachDetailViewController *myCoachVC = [[HHMyCoachDetailViewController alloc] initWithCoachId:nil];
                myCoachVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myCoachVC animated:YES];
            };
            cell.followedCoachView.actionBlock = ^(){
                
            };
            [cell setupCellWithCoach:nil coachList:nil];
            return cell;
        } break;
            
        case MyPageCellSupport: {
            HHMyPageSupportCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupportCell];
            cell.supportQQView.actionBlock = ^() {
                
            };
            cell.supportNumberView.actionBlock = ^() {
                
            };
            return cell;
        } break;
            
        case MyPageCellHelp: {
            HHMyPageHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:kHelpCell];
            return cell;
        } break;
          
        case MyPageCellLogout: {
            HHMyPageLogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogoutCell];
            return cell;
        } break;
            
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        } break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MyPageCellUserInfo:
            return 150.0f;
            
        case MyPageCellCoach:
            return kTopPadding + kTitleViewHeight + kItemViewHeight;
            
        case MyPageCellSupport:
            return kTopPadding + kTitleViewHeight + kItemViewHeight * 2.0f;
            
        case MyPageCellHelp:
            return kTopPadding + kTitleViewHeight + kItemViewHeight * 2.0f;
            
        case MyPageCellLogout:
            return 50 + kTopPadding * 2.0f;
            
        default:
            return 50;
    }
    
}


#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.tableView.contentOffset];
    }
}

@end
