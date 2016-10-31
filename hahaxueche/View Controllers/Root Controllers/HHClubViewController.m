//
//  HHClubViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHClubItemView.h"
#import "HHEventsViewController.h"
#import "HHTestStartViewController.h"
#import "HHClubPostTableViewCell.h"
#import "HHClubPostDetailViewController.h"
#import "HMSegmentedControl.h"
#import "SwipeView.h"
#import "UIScrollView+EmptyDataSet.h"
#import <MJRefresh/MJRefresh.h>

static NSString *const kCellID = @"kCellId";

@interface HHClubViewController () <UITableViewDelegate, UITableViewDataSource, SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *headLineView;
@property (nonatomic, strong) UILabel *headLineLabel;

@property (nonatomic, strong) HHClubItemView *eventView;
@property (nonatomic, strong) HHClubItemView *testView;

@property (nonatomic, strong) HMSegmentedControl *articlePageControl;
@property (nonatomic, strong) UIView *pageControlContainerView;

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *tableViewArray;

@end

@implementation HHClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小哈俱乐部";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.tableViewArray = [NSMutableArray array];

    [self initSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:club_page_viewed attributes:nil];
}

- (void)initSubviews {
    __weak HHClubViewController *weakSelf = self;
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 10.0f;
    [self.view addSubview:self.topView];
    
    self.eventView = [[HHClubItemView alloc] initWithIcon:[UIImage imageNamed:@"clock"] title:@"限时团购" subTitle:@"学车团购底价" showRightLine:YES showBotLine:YES];
    self.eventView.actionBlock = ^() {
        HHEventsViewController *vc = [[HHEventsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:club_page_group_purchase_tapped attributes:nil];
    };
    [self.topView addSubview:self.eventView];
    
    self.testView = [[HHClubItemView alloc] initWithIcon:[UIImage imageNamed:@"exercise"] title:@"在线题库" subTitle:@"题库想练就练" showRightLine:NO showBotLine:YES];
    self.testView.actionBlock = ^() {
        HHTestStartViewController *vc = [[HHTestStartViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:club_page_online_test_tapped attributes:nil];
    };
    [self.topView addSubview:self.testView];
    
    
    self.headLineView = [self buildHeadLineView];
    self.headLineLabel.text = @"哈哈学车优化驾培行业 成湖北省首批\"青创版\"挂牌企业";
    [self.view addSubview:self.headLineView];
    
    self.pageControlContainerView = [[UIView alloc] init];
    self.pageControlContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageControlContainerView];
    
    self.articlePageControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"热门新闻",@"学车资讯", @"驾考指南", @"开车技巧"]];
    self.articlePageControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.articlePageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.articlePageControl.selectionIndicatorColor = [UIColor HHOrange];
    self.articlePageControl.selectionIndicatorHeight = 4.0f/[UIScreen mainScreen].scale;
    self.articlePageControl.shouldAnimateUserSelection = YES;
    self.articlePageControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHLightestTextGray], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    self.articlePageControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHTextDarkGray], NSFontAttributeName:[UIFont systemFontOfSize:15.0f]};
    [self.articlePageControl addTarget:self action:@selector(pageControlChangedValue) forControlEvents:UIControlEventValueChanged];
    [self.pageControlContainerView addSubview:self.articlePageControl];

    
    self.swipeView = [[SwipeView alloc] init];
    self.swipeView.pagingEnabled = YES;
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    [self.view addSubview:self.swipeView];

    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(10.0f);
        make.left.equalTo(self.view.left).offset(10.0f);
        make.width.equalTo(self.view.width).offset(-20.0f);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self.eventView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top);
        make.left.equalTo(self.topView.left);
        make.width.equalTo(self.topView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self.testView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top);
        make.left.equalTo(self.eventView.right);
        make.width.equalTo(self.topView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self.headLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(40.0f);
        make.top.equalTo(self.topView.bottom).offset(10.0f);
    }];
    
    [self.pageControlContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(40.0f);
        make.top.equalTo(self.headLineView.bottom).offset(10.0f);
    }];
    
    [self.articlePageControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pageControlContainerView.centerX);
        make.width.equalTo(self.pageControlContainerView.width).offset(-40.0f);
        make.height.mas_equalTo(40.0f);
        make.centerY.equalTo(self.pageControlContainerView.centerY);
    }];
    
    [self.swipeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageControlContainerView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));
    }];
    
}

#pragma mark -SwipeView methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return 4;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *containerView = [[UIView alloc] init];
    [self initViewForSwiptViewWithIndex:index containerView:containerView];
    return containerView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.swipeView.bounds.size;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView {
    self.articlePageControl.selectedSegmentIndex = swipeView.currentPage;
}

- (void)initViewForSwiptViewWithIndex:(NSInteger)index containerView:(UIView *)containerView{
    UITableView *tableView = [[UITableView alloc] init];
    tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[HHClubPostTableViewCell class] forCellReuseIdentifier:kCellID];
    [containerView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(containerView);
        make.width.equalTo(containerView.width);
        make.height.equalTo(containerView.height);
    }];
    
    MJRefreshNormalHeader *refreshHeader = [self buildHeader];
    MJRefreshAutoNormalFooter *loadMoreFooter = [self buildFooter];
    
    tableView.mj_header = refreshHeader;
    tableView.mj_footer = loadMoreFooter;

}

- (MJRefreshNormalHeader *)buildHeader {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    header.stateLabel.textColor = [UIColor HHLightTextGray];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    return header;
}

- (MJRefreshAutoNormalFooter *)buildFooter {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    footer.stateLabel.textColor = [UIColor HHLightTextGray];
    return footer;
}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHClubPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    [cell setupCellWithClubPost:nil];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 333.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHClubPostDetailViewController *vc = [[HHClubPostDetailViewController alloc] initWithClubPost:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIView *)buildHeadLineView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_headline"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(20.0f);
        make.width.mas_equalTo(28.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    self.headLineLabel = [[UILabel alloc] init];
    self.headLineLabel.textColor = [UIColor HHLightTextGray];
    self.headLineLabel.font = [UIFont systemFontOfSize:15.0f];
    self.headLineLabel.adjustsFontSizeToFitWidth = YES;
    self.headLineLabel.minimumScaleFactor = 0.5;
    [view addSubview:self.headLineLabel];
    [self.headLineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(10.0f);
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right).offset(-30.0f);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headLineTapped)];
    [view addGestureRecognizer:tapRec];
    
    return view;
}

- (void)headLineTapped {
    
}

- (void)pageControlChangedValue {
    [self.swipeView scrollToPage:self.articlePageControl.selectedSegmentIndex duration:0.3f];
}

- (void)refreshData {
    
}

- (void)loadMoreData {
    
}



@end
