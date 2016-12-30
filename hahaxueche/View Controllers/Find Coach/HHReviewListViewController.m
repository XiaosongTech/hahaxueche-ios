//
//  HHReviewListViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReviewListViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHStarRatingView.h"
#import "HHReviewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "HHCoachService.h"
#import "HHLoadingViewUtility.h"
#import "HHFindCoachViewController.h"
#import "UIScrollView+EmptyDataSet.h"


static NSString *kCellID = @"kCellId";

@interface HHReviewListViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) UILabel *reviewNumberLabel;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingLabel;

@property (nonatomic, strong) HHReviews *reviewsObject;
@property (nonatomic, strong) NSMutableArray *reviews;
@property (nonatomic, strong) HHCoach *coach;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;

@end

@implementation HHReviewListViewController

- (instancetype)initWithReviews:(HHReviews *)reviews coach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.reviews = [NSMutableArray arrayWithArray:reviews.reviews];
        self.reviewsObject = reviews;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学员评价";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    [self initSubviews];
    
}

- (void)initSubviews {
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topContainerView];
    
    self.reviewNumberLabel = [[UILabel alloc] init];
    self.reviewNumberLabel.textColor = [UIColor HHOrange];
    self.reviewNumberLabel.text = [NSString stringWithFormat:@"学员评价（%@）", [self.coach.reviewCount stringValue]];
    self.reviewNumberLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.topContainerView addSubview:self.reviewNumberLabel];
    
    self.ratingLabel = [[UILabel alloc] init];
    self.ratingLabel.textColor = [UIColor HHOrange];
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f分",[self.coach.averageRating floatValue]];;
    self.ratingLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.topContainerView addSubview:self.ratingLabel];
    
    self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    self.starRatingView.value = [self.coach.averageRating floatValue];
    [self.topContainerView addSubview:self.starRatingView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHReviewCell class] forCellReuseIdentifier:kCellID];
    
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.refreshHeader setTitle:@"下拉更新" forState:MJRefreshStateIdle];
    [self.refreshHeader setTitle:@"下拉更新" forState:MJRefreshStatePulling];
    [self.refreshHeader setTitle:@"正在刷新评价列表" forState:MJRefreshStateRefreshing];
    self.refreshHeader.stateLabel.textColor = [UIColor HHLightTextGray];
    self.refreshHeader.automaticallyChangeAlpha = YES;
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = self.refreshHeader;
    
    self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.loadMoreFooter setTitle:@"加载更多评价" forState:MJRefreshStateIdle];
    [self.loadMoreFooter setTitle:@"正在加载更多评价" forState:MJRefreshStateRefreshing];
    [self.loadMoreFooter setTitle:@"没有更多评价" forState:MJRefreshStateNoMoreData];
    self.loadMoreFooter.automaticallyRefresh = NO;
    self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
    self.tableView.mj_footer = self.loadMoreFooter;
    self.reviewsObject = self.reviewsObject;
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topContainerView addSubview:self.botLine];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.topContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topContainerView.bottom);
        make.left.equalTo(self.topContainerView.left);
        make.width.equalTo(self.topContainerView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.reviewNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topContainerView.centerY);
        make.left.equalTo(self.topContainerView.left).offset(15.0f);
    }];
    
    [self.ratingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topContainerView.centerY);
        make.right.equalTo(self.topContainerView.right).offset(-15.0f);
    }];
    
    [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topContainerView.centerY);
        make.right.equalTo(self.ratingLabel.left).offset(-5.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHReviewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    [cell setupViewWithReview:self.reviews[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHReview *review = self.reviews[indexPath.row];
    CGRect rect = [self getDescriptionTextSizeWithText:review.comment];
    
    return CGRectGetHeight(rect) + 70.0f;
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSMutableAttributedString alloc] initWithString:@"教练目前还没有评价." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
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

#pragma mark Button Actions

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGRect)getDescriptionTextSizeWithText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-90.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                     context:nil];
    return rect;
}

- (void)refreshData {
    __weak HHReviewListViewController *weakSelf = self;
    [self refreshCoachListWithCompletion:^{
        [weakSelf.refreshHeader endRefreshing];
    }];
}

- (void)loadMoreData {
    __weak HHReviewListViewController *weakSelf = self;
    [self loadMoreCoachesWithCompletion:^{
        [weakSelf.loadMoreFooter endRefreshing];
    }];
}

- (void)refreshCoachListWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    __weak HHReviewListViewController *weakSelf = self;
    if (!completion) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    
    [[HHCoachService sharedInstance] fetchReviewsWithUserId:self.coach.userId completion:^(HHReviews *reviews, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            weakSelf.reviews = [NSMutableArray arrayWithArray:reviews.reviews];
            weakSelf.reviewsObject = reviews;
            [weakSelf.tableView reloadData];
        }
    }];
    
}

- (void)loadMoreCoachesWithCompletion:(HHRefreshCoachCompletionBlock)completion {
    __weak HHReviewListViewController *weakSelf = self;
    [[HHCoachService sharedInstance] fetchNextPageReviewsWithURL:self.reviewsObject.nextPage completion:^(HHReviews *reviews, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            [weakSelf.reviews addObjectsFromArray:reviews.reviews];
            weakSelf.reviewsObject = reviews;
            [weakSelf.tableView reloadData];
        }

    }];
}

- (void)setReviewsObject:(HHReviews *)reviewsObject {
    _reviewsObject = reviewsObject;
    if (!reviewsObject.nextPage) {
        if ([self.reviews count]) {
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



@end
