//
//  HHMyReservationViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMyReservationViewController.h"
#import "HHAutoLayoutUtility.h"
#import "HHUserAuthenticator.h"
#import "HHScheduleService.h"
#import "HHLoadingView.h"
#import "HHFormatUtility.h"
#import "HHToastUtility.h"
#import "HHTimeSlotSectionTitleView.h"
#import "HHMyReservationTableViewCell.h"
#import "HHTrainingFieldService.h"
#import "HHTrainingField.h"
#import <pop/POP.h>
#import "HHCoachProfileViewController.h"
#import "HHStudentService.h"

typedef void (^HHGenericCompletion)();

#define kReservationCellId @"kReservationCellId"

@interface HHMyReservationViewController()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *reservations;
@property (nonatomic, strong) NSArray *groupedReservations;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSMutableDictionary *studentsForReservation;

@property (nonatomic, strong) HHTrainingField *trainingField;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic)         BOOL shouldLoadMore;


@end


@implementation HHMyReservationViewController

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"我的预约",nil);
    self.shouldLoadMore = YES;
    self.reservations = [NSMutableArray array];
    self.studentsForReservation = [NSMutableDictionary dictionary];
    [self initSubviews];
    [[HHTrainingFieldService sharedInstance] fetchTrainingFieldWithId:[HHUserAuthenticator sharedInstance].myCoach.trainingFieldId completion:^(HHTrainingField *field, NSError *error) {
        if (!error) {
            self.trainingField = field;
        }
    }];
    [self fetchReservationsWithCompletion:nil];

    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
}

- (void)refreshData {
    __weak HHMyReservationViewController *weakSelf = self;
    [self fetchReservationsWithCompletion:^{
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)fetchReservationsWithCompletion:(HHGenericCompletion)completion {
    __weak HHMyReservationViewController *weakSelf = self;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:[HHUserAuthenticator sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
        [[HHScheduleService sharedInstance] fetchAuthedStudentReservationsWithSkip:0 completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
            [[HHLoadingView sharedInstance] hideLoadingView];
            if (completion) {
                completion();
            }
            if (!error) {
                [weakSelf.studentsForReservation removeAllObjects];
                [weakSelf.reservations removeAllObjects];
                [weakSelf.reservations addObjectsFromArray:objects];
                weakSelf.sectionTitles = [weakSelf groupReservations];
                [weakSelf.tableView reloadData];
                if (weakSelf.reservations.count >= totalResults) {
                    weakSelf.shouldLoadMore = NO;
                } else {
                    weakSelf.shouldLoadMore = YES;
                }
            } else {
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据时出错！", nil) isError:YES];
            }
        }];
    }];
}

- (void)fetchMoreReservations {
    __weak HHMyReservationViewController *weakSelf = self;
    [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:[HHUserAuthenticator sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
        [[HHScheduleService sharedInstance] fetchAuthedStudentReservationsWithSkip:self.reservations.count completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
            if (!error) {
                [weakSelf.reservations addObjectsFromArray:objects];
                weakSelf.sectionTitles = [weakSelf groupReservations];
                [weakSelf.tableView reloadData];
                if (weakSelf.reservations.count >= totalResults) {
                    weakSelf.shouldLoadMore = NO;
                } else {
                    weakSelf.shouldLoadMore = YES;
                }
            } else {
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据时出错！", nil) isError:YES];
            }
        }];
    }];

}


- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHMyReservationTableViewCell class] forCellReuseIdentifier:kReservationCellId];
    [self.view addSubview:self.tableView];
    
    [self autolayoutSubview];
}

- (void)autolayoutSubview {
    NSArray *constraints  = @[
                              [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.tableView constant:0],
                              [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.tableView constant:0],
                              [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                              [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:0],
                              ];
    
    [self.view addConstraints:constraints];
    
}

- (NSArray *)groupReservations {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *filteredArray = self.reservations;

    if (filteredArray.count < 1) {
        self.reservations = nil;
        return nil;
    }
    HHCoachSchedule *firstSchedule = [filteredArray firstObject];
    NSDate *previousDate = firstSchedule.startDateTime;
    NSMutableArray *currentGroup = [NSMutableArray array];
    [currentGroup addObject:firstSchedule];
    if (filteredArray.count == 1) {
        self.groupedReservations = @[currentGroup];
    } else {
        for (int i = 1; i < filteredArray.count; i++) {
            HHCoachSchedule *schedule = filteredArray[i];
            if ([[[HHFormatUtility dateFormatter] stringFromDate:schedule.startDateTime] isEqualToString:[[HHFormatUtility dateFormatter] stringFromDate:previousDate]]) {
                [currentGroup addObject:schedule];
            } else {
                [array addObject:currentGroup];
                currentGroup = [NSMutableArray array];
                [currentGroup addObject:schedule];
            }
            if (i == filteredArray.count - 1) {
                [array addObject:currentGroup];
            }
        }
        self.groupedReservations = array;
    }
    
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.groupedReservations.count; i++) {
        HHCoachSchedule *schedule = [self.groupedReservations[i] firstObject];
        NSString *date = [[HHFormatUtility fullDateFormatter] stringFromDate:schedule.startDateTime];
        NSString *title = [NSString stringWithFormat:@"%@ (%@)", date, [[HHFormatUtility weekDayFormatter] stringFromDate:schedule.startDateTime]];
        [titles addObject:title];
    }
    return titles;
}



#pragma mark Tableview Delagate & Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedReservations.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:self.sectionTitles[section]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.groupedReservations.count) {
        NSArray *reservations = self.groupedReservations[section];
        return reservations.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHMyReservationViewController *weakSelf = self;
    HHMyReservationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReservationCellId forIndexPath:indexPath];
    HHCoachSchedule *reservation = self.groupedReservations[indexPath.section][indexPath.row];
    cell.reservation = reservation;
    if (self.studentsForReservation[reservation.objectId]) {
        cell.students = self.studentsForReservation[reservation.objectId];
        [cell setupViews];
    } else {
        [[HHStudentService sharedInstance] fetchStudentsForScheduleWithIds:reservation.reservedStudents completion:^(NSArray *objects, NSError *error) {
            weakSelf.studentsForReservation[reservation.objectId] = objects;
            cell.students = objects;
            [cell setupViews];
        }];
    }
    
    cell.nameButtonBlock = ^(){
        HHCoachProfileViewController *coachProfileVC =  [[HHCoachProfileViewController alloc] initWithCoach:[HHUserAuthenticator sharedInstance].myCoach];
        [weakSelf.navigationController pushViewController:coachProfileVC animated:YES];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    CGRect fromRect = [tableView rectForRowAtIndexPath:indexPath];
    fromRect.origin = CGPointMake(0, CGRectGetMinY(fromRect) - CGRectGetHeight(fromRect));
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    springAnimation.toValue = [NSValue valueWithCGRect:[tableView rectForRowAtIndexPath:indexPath]];
    springAnimation.name = @"slideInCellFromTop";
    springAnimation.delegate = self;
    springAnimation.springSpeed = 0.8f;
    springAnimation.springBounciness = 0.5f;
    [cell pop_addAnimation:springAnimation forKey:@"slideInCellFromTop"];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}


#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldLoadMore) {
            return;
        }
        [self fetchMoreReservations];
    }
}

@end
