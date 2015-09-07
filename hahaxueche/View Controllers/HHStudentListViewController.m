//
//  HHStudentListViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/3/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHStudentListViewController.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import "HHStudentListTableViewCell.h"
#import "HHCoachService.h"
#import "HHLoadingView.h"
#import "HHToastUtility.h"
#import "HHPaymentTransactionService.h"
#import "HHFormatUtility.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import <pop/POP.h>
#import "HHStudentService.h"
#import "HHStudentSearchViewController.h"
#import "HHCoachStudentProfileViewController.h"
#import "HHUserAuthenticator.h"

#define kCellId @"StudentListCellId"

@interface HHStudentListViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *students;

@property (nonatomic, strong) NSMutableDictionary *transactionsDic;
@property (nonatomic) BOOL shouldLoadMore;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation HHStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"学员列表", nil);
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.students = [NSMutableArray array];
    self.transactionsDic = [NSMutableDictionary dictionary];
    self.shouldLoadMore = YES;
    [self initSubviews];
    
    UIBarButtonItem *searchButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"search"] action:@selector(searchIconPressed) target:self];
    UIBarButtonItem *positiveSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    positiveSpacer.width = -8.0f;//
    [self.navigationItem setRightBarButtonItems:@[positiveSpacer, searchButton]];

    
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [self fetchStudentsWithCompletion:^{
        [[HHLoadingView sharedInstance] hideLoadingView];
    }];
    
}

- (void)searchIconPressed {
    HHStudentSearchViewController *searchVC =  [[HHStudentSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[HHStudentListTableViewCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50.0f)];
    UILabel *currentStudentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    currentStudentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    currentStudentLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    currentStudentLabel.textColor = [UIColor HHOrange];
    currentStudentLabel.text = [NSString stringWithFormat:@"当前学员数：%@", [[HHUserAuthenticator sharedInstance].currentCoach.currentStudentAmount stringValue]];
    [currentStudentLabel sizeToFit];
    [headerView addSubview:currentStudentLabel];
    
    
    UILabel *passedStudentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    passedStudentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    passedStudentLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    passedStudentLabel.textColor = [UIColor HHOrange];
    passedStudentLabel.text = [NSString stringWithFormat:@"已通过学员数：%@", [[HHUserAuthenticator sharedInstance].currentCoach.passedStudentAmount stringValue]];
    [passedStudentLabel sizeToFit];
    [headerView addSubview:passedStudentLabel];
    self.tableView.tableHeaderView = headerView;
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:currentStudentLabel constant:10.0f],
                             [HHAutoLayoutUtility setCenterY:currentStudentLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:passedStudentLabel constant:-10.0f],
                            [HHAutoLayoutUtility setCenterY:passedStudentLabel multiplier:1.0f constant:0],
    
                             ];
    [self.view addConstraints:constraints];
    
    
    
    [self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                             ];
    [self.view addConstraints:constraints];
}

- (void)refreshData {
    __weak HHStudentListViewController *weakSelf = self;
    [self fetchStudentsWithCompletion:^{
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)fetchStudentsWithCompletion:(HHGenericCompletion)completion {
    [[HHCoachService sharedInstance] fetchMyStudentsForAuthedCoachWithSkip:0 completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
        if (!error) {
            self.students = [NSMutableArray arrayWithArray:objects];
            if (self.students.count == totalCount) {
                self.shouldLoadMore = NO;
            } else {
                self.shouldLoadMore = YES;
            }
            [self.tableView reloadData];
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"加载出错", nil) isError:YES];
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)fetchMoreStudentsWithCompletion:(HHGenericCompletion)completion {
    [[HHCoachService sharedInstance] fetchMyStudentsForAuthedCoachWithSkip:self.students.count completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
        if (!error) {
            [self.students addObjectsFromArray:objects];
            if (self.students.count == totalCount) {
                self.shouldLoadMore = NO;
            } else {
                self.shouldLoadMore = YES;
            }
            [self.tableView reloadData];
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"加载出错", nil) isError:YES];
        }
        if (completion) {
            completion();
        }
    }];

}


#pragma -mark TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHStudentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHStudent *student = self.students[indexPath.row];
    __block HHTransaction *transaction =self.transactionsDic[student.studentId];
    if (transaction){
        [cell setupViewsWithStudent:student priceString:[[HHFormatUtility moneyFormatter] stringFromNumber:transaction.paidPrice]];
    } else {
        [[HHPaymentTransactionService sharedInstance] fetchTransactionWithStudentId:student.studentId completion:^(NSArray *objects, NSError *error) {
            if (!error) {
                transaction = [objects firstObject];
                [cell setupViewsWithStudent:student priceString:[[HHFormatUtility moneyFormatter] stringFromNumber:transaction.paidPrice]];
                self.transactionsDic[student.studentId] = transaction;
            }
        }];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 15.f;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachStudentProfileViewController *studentVC = [[HHCoachStudentProfileViewController alloc] init];
    studentVC.student = self.students[indexPath.row];
    studentVC.transactionArray = @[self.transactionsDic[studentVC.student.studentId]];
    [self.navigationController pushViewController:studentVC animated:YES];
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldLoadMore) {
            return;
        }
        [self fetchMoreStudentsWithCompletion:nil];
    }
}

@end
