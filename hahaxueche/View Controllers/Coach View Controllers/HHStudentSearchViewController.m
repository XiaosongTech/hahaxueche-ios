//
//  HHStudentSearchViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/6/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHStudentSearchViewController.h"
#import "HHLoadingView.h"
#import "HHToastUtility.h"
#import "HHStudentService.h"
#import "HHStudentListTableViewCell.h"
#import "HHTransaction.h"
#import "HHPaymentTransactionService.h"
#import "HHFormatUtility.h"
#import "UIColor+HHColor.h"
#import "HHCoachStudentProfileViewController.h"

#define kCellId @"cellId"

@interface HHStudentSearchViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, strong) NSMutableDictionary *transactionsDic;
@property (nonatomic) BOOL shouldLoadMore;

@end

@implementation HHStudentSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.students = [NSMutableArray array];
    self.transactionsDic = [NSMutableDictionary dictionary];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shouldLoadMore = YES;
    [self.tableView registerClass:[HHStudentListTableViewCell class] forCellReuseIdentifier:kCellId];
    self.tableView.backgroundColor = [UIColor HHLightGrayBackgroundColor];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self updateTableViewWithSearchQuery:searchBar.text skip:0];
}

- (void)updateTableViewWithSearchQuery:(NSString *)query skip:(NSInteger)skip {
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [[HHStudentService sharedInstance] fetchStudentWithQueryForAuthedCoach:query skip:skip completion:^(NSArray *students, NSInteger totalResults, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            self.students = [NSMutableArray arrayWithArray:students];
            [self.tableView reloadData];
            if (self.students.count == totalResults) {
                self.shouldLoadMore = NO;
            } else {
                self.shouldLoadMore = YES;
            }
        }
    }];
}

- (void)fetchMoreDataWithSearchQuery:(NSString *)query skip:(NSInteger)skip {
    [[HHStudentService sharedInstance] fetchStudentWithQueryForAuthedCoach:query skip:skip completion:^(NSArray *students, NSInteger totalResults, NSError *error) {
        if (!error) {
            [self.students addObjectsFromArray:students];
            [self.tableView reloadData];
            if (self.students.count == totalResults) {
                self.shouldLoadMore = NO;
            } else {
                self.shouldLoadMore = YES;
            }
        }
    }];

}

#pragma mark Table View Delegate & DataSource Methods

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachStudentProfileViewController *studentProfileVC = [[HHCoachStudentProfileViewController alloc] init];
    HHStudent *student = self.students[indexPath.row];
    studentProfileVC.student = student;
    studentProfileVC.transactionArray =@[self.transactionsDic[student.studentId]];
    [self.navigationController pushViewController:studentProfileVC animated:YES];
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldLoadMore) {
            return;
        }
        [self fetchMoreDataWithSearchQuery:self.searchBar.text skip:self.students.count];
    }
}

@end
