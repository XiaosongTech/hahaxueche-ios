//
//  HHScheduleViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTimeSlotsViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHCoachSchedule.h"
#import "HHFormatUtility.h"
#import "HHTimeSlotTableViewCell.h"
#import "HHTimeSlotSectionTitleView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHToastUtility.h"
#import "HHStudentService.h"
#import "HHFullScreenImageViewController.h"
#import "HHUserAuthenticator.h"
#import "HHStudentService.h"
#import "HHScheduleService.h"
#import "HHLoadingView.h"
#import "HHUserAuthenticator.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHRootViewController.h"
#import <pop/POP.h>
#import "HHCoachStudentProfileViewController.h"

#define kTimeSlotCellIdentifier @"kTimeSlotCellIdentifier"

@interface HHTimeSlotsViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groupedSchedules;
@property (nonatomic, strong) NSArray *sectionTiltes;
@property (nonatomic)         BOOL canSelectTime;
@property (nonatomic, strong) UISegmentedControl *filterSegmentedControl;
@property (nonatomic, strong) NSMutableArray *schedules;
@property (nonatomic)         BOOL shouldLoadMore;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HHTimeSlotsViewController

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)fetchSchedulesWithCompletion:(HHGenericCompletion)completion {
    __weak HHTimeSlotsViewController *weakSelf = self;
    [[HHScheduleService sharedInstance] fetchCoachSchedulesWithCoachId:self.coach.coachId skip:0 completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            [weakSelf.schedules removeAllObjects];
            [weakSelf.schedules addObjectsFromArray:objects];
            if (weakSelf.schedules.count >= totalResults) {
                weakSelf.shouldLoadMore = NO;
            } else {
                weakSelf.shouldLoadMore = YES;
            }
            weakSelf.sectionTiltes = [weakSelf groupSchedulesTitleWithFilter:weakSelf.filterSegmentedControl.selectedSegmentIndex];
            [weakSelf.tableView reloadData];

        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据是出错！", nil) isError:YES];
        }
    }];
    
}

- (void)fetchMoreSchedules {
    __weak HHTimeSlotsViewController *weakSelf = self;
    [[HHScheduleService sharedInstance] fetchCoachSchedulesWithCoachId:self.coach.coachId skip:self.schedules.count completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
        if (!error) {
            [weakSelf.schedules addObjectsFromArray:objects];
            if (weakSelf.schedules.count >= totalResults) {
                weakSelf.shouldLoadMore = NO;
            } else {
                weakSelf.shouldLoadMore = YES;
            }
            weakSelf.sectionTiltes = [weakSelf groupSchedulesTitleWithFilter:weakSelf.filterSegmentedControl.selectedSegmentIndex];
            [weakSelf.tableView reloadData];
            
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据是出错！", nil) isError:YES];
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.title = NSLocalizedString(@"查看时间", nil);
    self.navigationItem.hidesBackButton = YES;
    self.schedules = [NSMutableArray array];
    
    UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    
    UIBarButtonItem *bookBarButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"去预约", nil) action:@selector(jumpToBookView) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = bookBarButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor =[UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHTimeSlotTableViewCell class] forCellReuseIdentifier:kTimeSlotCellIdentifier];
    [self.view addSubview:self.tableView];
    
    if ([self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        self.canSelectTime = YES;
    } else {
        self.canSelectTime = NO;
    }
    

    self.filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"全部", nil), NSLocalizedString(@"科目二", nil), NSLocalizedString(@"科目三", nil)]];
    self.filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.filterSegmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    self.filterSegmentedControl.selectedSegmentIndex = 0;
    self.filterSegmentedControl.tintColor = [UIColor HHOrange];
    [self.filterSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]} forState:UIControlStateNormal];
    [self.filterSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]} forState:UIControlStateSelected];
    [self.view addSubview:self.filterSegmentedControl];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [self fetchSchedulesWithCompletion:^{
         [[HHLoadingView sharedInstance] hideLoadingView];
    }];
    [self autoLayoutSubviews];
}

- (void)jumpToBookView {
    if ([[HHUserAuthenticator sharedInstance].currentStudent.myCoachId isEqualToString:self.coach.coachId]) {
        HHRootViewController *rootVC = (HHRootViewController *)self.parentViewController.parentViewController;
        rootVC.selectedIndex = TabBarItemBookView;
    } else {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"确认教练并付款后，才能预约时间", nil) isError:YES];
    }
   
}

- (void)refreshData {
    __weak HHTimeSlotsViewController *weakSelf = self;
    [self fetchSchedulesWithCompletion:^{
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)valueChanged:(UISegmentedControl *)control {
    self.sectionTiltes =[self groupSchedulesTitleWithFilter:control.selectedSegmentIndex];
    [self.tableView reloadData];
}


- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)autoLayoutSubviews {
    

    NSArray *constraints = @[
                             
                             [HHAutoLayoutUtility setCenterX:self.filterSegmentedControl multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.filterSegmentedControl constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.filterSegmentedControl multiplier:0 constant:30.0f],
                             [HHAutoLayoutUtility setViewWidth:self.filterSegmentedControl multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.tableView toView:self.filterSegmentedControl constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.tableView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                       
                             ];

    [self.view addConstraints:constraints];
}

- (NSArray *)groupSchedulesTitleWithFilter:(TimeSlotFilter)filter {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *filteredArray = self.schedules;
    switch (filter) {
        case TimeSlotFilterCourseTwo: {
            filteredArray = [filteredArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(course == %@)", NSLocalizedString(@"科目二", nil)]];
        }
            break;
        case TimeSlotFilterCourseThree: {
            filteredArray = [filteredArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(course == %@)", NSLocalizedString(@"科目三", nil)]];
        }
            break;
            
        default:
            break;
    }

    if (filteredArray.count < 1) {
        self.groupedSchedules = nil;
        return nil;
    }
    HHCoachSchedule *firstSchedule = [filteredArray firstObject];
    NSDate *previousDate = firstSchedule.startDateTime;
    NSMutableArray *currentGroup = [NSMutableArray array];
    [currentGroup addObject:firstSchedule];
    if (filteredArray.count == 1) {
        self.groupedSchedules = @[currentGroup];
    } else {
        for (int i = 1; i < filteredArray.count; i++) {
            HHCoachSchedule *schedule = filteredArray[i];
            if ([[[HHFormatUtility dateFormatter] stringFromDate:schedule.startDateTime] isEqualToString:[[HHFormatUtility dateFormatter] stringFromDate:previousDate]]) {
                [currentGroup addObject:schedule];
            } else {
                [array addObject:currentGroup];
                currentGroup = [NSMutableArray array];
                [currentGroup addObject:schedule];
                previousDate = schedule.startDateTime;
            }
            if (i == filteredArray.count - 1) {
                [array addObject:currentGroup];
            }
        }
        self.groupedSchedules = array;
    }

    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.groupedSchedules.count; i++) {
        HHCoachSchedule *schedule = [self.groupedSchedules[i] firstObject];
        NSString *date = [[HHFormatUtility fullDateFormatter] stringFromDate:schedule.startDateTime];
        NSString *title = [NSString stringWithFormat:@"%@ (%@)", date, [[HHFormatUtility weekDayFormatter] stringFromDate:schedule.startDateTime]];
        [titles addObject:title];
    }
    return titles;
}


#pragma -mark TableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.groupedSchedules.count) {
        return self.groupedSchedules.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHTimeSlotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTimeSlotCellIdentifier forIndexPath:indexPath];
    HHCoachSchedule *schedule = (HHCoachSchedule *)self.groupedSchedules[indexPath.section][indexPath.row];
    cell.schedule = schedule;
    __weak HHTimeSlotsViewController *weakSelf = self;
    if ([HHUserAuthenticator sharedInstance].currentStudent) {
        cell.block = ^(HHStudent *student) {
            HHFullScreenImageViewController *vc = [[HHFullScreenImageViewController alloc] initWithImageURLArray:@[student.avatarURL] titleArray:@[student.fullName] initalIndex:0];
            [weakSelf presentViewController:vc animated:YES completion:nil];
        };
    } else if ([HHUserAuthenticator sharedInstance].currentCoach) {
        cell.block = ^(HHStudent *student) {
            HHCoachStudentProfileViewController *studentVC = [[HHCoachStudentProfileViewController alloc] init];
            studentVC.student = student;
            studentVC.transactionArray = nil;
            studentVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:studentVC animated:YES];
        };

    }
    
    cell.students = schedule.fullStudents;
    [cell setupViews];
    [cell setupAvatars];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.groupedSchedules.count) {
        NSArray *schedules = self.groupedSchedules[section];
        return schedules.count;
    } else {
        return 0;
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:self.sectionTiltes[section]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 15.f;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}


- (UIButton *)createButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor font:(UIFont *)font action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:bgColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}


#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldLoadMore) {
            return;
        }
        [self fetchMoreSchedules];
    }
}


@end
