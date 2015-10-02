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
@property (nonatomic, strong) NSArray *filteredStudents;
@property (nonatomic, strong) UISegmentedControl *filterSegmentedControl;

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
    searchVC.transactionDic = self.transactionsDic;
    searchVC.hidesBottomBarWhenPushed = YES;
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
    
    
    NSString *option1 = [NSString stringWithFormat:NSLocalizedString(@"当前学员（%@）", nil), [[HHUserAuthenticator sharedInstance].currentCoach.currentStudentAmount stringValue]];
    
     NSString *option2 = [NSString stringWithFormat:NSLocalizedString(@"已通过学员（%@）", nil), [[HHUserAuthenticator sharedInstance].currentCoach.passedStudentAmount stringValue]];
    self.filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[option1, option2]];
    self.filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.filterSegmentedControl addTarget:self action:@selector(valueChanged) forControlEvents: UIControlEventValueChanged];
    self.filterSegmentedControl.selectedSegmentIndex = 0;
    self.filterSegmentedControl.tintColor = [UIColor HHOrange];
    [self.filterSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]} forState:UIControlStateNormal];
    [self.filterSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]} forState:UIControlStateSelected];
    [self.view addSubview:self.filterSegmentedControl];
    
    [self autoLayoutSubviews];
}

- (void)valueChanged {
    [self buildFilteredArray];
    [self.tableView reloadData];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.filterSegmentedControl multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.filterSegmentedControl constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.filterSegmentedControl multiplier:0 constant:30.0f],
                             [HHAutoLayoutUtility setViewWidth:self.filterSegmentedControl multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.tableView toView:self.filterSegmentedControl constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.tableView constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.tableView constant:0],
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
            [self buildFilteredArray];
            [self.tableView reloadData];
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"加载出错", nil) isError:YES];
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)buildFilteredArray {
    if (self.filterSegmentedControl.selectedSegmentIndex == 0) {
         self.filteredStudents = [self.students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(isFinished == %@)", @(0)]];
    } else {
        self.filteredStudents = [self.students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(isFinished == %@)", @(1)]];
    }
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
    return self.filteredStudents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHStudentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHStudent *student = self.filteredStudents[indexPath.row];
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
    studentVC.student = self.filteredStudents[indexPath.row];
    studentVC.transactionArray = @[self.transactionsDic[studentVC.student.studentId]];
    studentVC.hidesBottomBarWhenPushed = YES;
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
