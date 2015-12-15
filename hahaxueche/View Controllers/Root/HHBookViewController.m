//
//  HHBookViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/6/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHBookViewController.h"
#import "HHLoadingView.h"
#import "HHToastUtility.h"
#import "HHScheduleService.h"
#import "HHStudentService.h"
#import "HHUserAuthenticator.h"
#import "HHFormatUtility.h"
#import "UIColor+HHColor.h"
#import "HHTimeSlotTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "HHTimeSlotSectionTitleView.h"
#import "HHFullScreenImageViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHAvatarView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHCoachService.h"
#import "HHCoachProfileViewController.h"
#import <pop/POP.h>
#import "HHCoachListViewController.h"


#define kTimeSlotCellIdentifier @"kTimeSlotCellIdentifier"

@interface HHBookViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groupedSchedules;
@property (nonatomic, strong) NSArray *sectionTiltes;
@property (nonatomic, strong) NSMutableArray *selectedSchedules;
@property (nonatomic, strong) UISegmentedControl *filterSegmentedControl;
@property (nonatomic, strong) NSMutableArray *schedules;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIBarButtonItem *confirmBarButtonItem;
@property (nonatomic, strong) HHCoach *myCoach;

@property (nonatomic)         BOOL shouldLoadMore;
@property (nonatomic)         BOOL hasCoach;


@end

@implementation HHBookViewController


-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"预约练车", nil);
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.navigationItem.hidesBackButton = YES;
    self.selectedSchedules = [NSMutableArray array];
    self.schedules = [NSMutableArray array];
    
    if ([HHUserAuthenticator sharedInstance].myCoach) {
        self.myCoach = [HHUserAuthenticator sharedInstance].myCoach;
        self.hasCoach = YES;
    } else {
        self.hasCoach = NO;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor =[UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHTimeSlotTableViewCell class] forCellReuseIdentifier:kTimeSlotCellIdentifier];
    [self.view addSubview:self.tableView];
    
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
    

    if (self.hasCoach && ![[HHUserAuthenticator sharedInstance].currentStudent.isFinished boolValue]) {
        self.confirmBarButtonItem = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"确认", nil) action:@selector(confirmTimes) target:self isLeft:NO];
        self.navigationItem.rightBarButtonItem = self.confirmBarButtonItem;
        HHAvatarView *myCoachAvatar = [[HHAvatarView alloc] initWithImageURL:nil radius:15.0f borderColor:[UIColor whiteColor]];
        [myCoachAvatar setFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
        [myCoachAvatar.imageView sd_setImageWithURL:[NSURL URLWithString:self.myCoach.avatarURL] placeholderImage:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToMyCoachProfileView)];
        [myCoachAvatar addGestureRecognizer:tap];
        
        UIBarButtonItem *coachBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:myCoachAvatar];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -8.0f;
        
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, coachBarButtonItem]];
        [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
        [self fetchSchedulesWithCompletion:^{
            [[HHLoadingView sharedInstance] hideLoadingView];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"cancelSucceed" object:nil];
    
    [self autoLayoutSubviews];

}

-(void)updateData {
    [self fetchSchedulesWithCompletion:nil];
}

- (void)jumpToMyCoachProfileView {
    if (self.myCoach) {
         HHCoachProfileViewController *myCoachVC = [[HHCoachProfileViewController alloc] initWithCoach:self.myCoach];
        myCoachVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCoachVC animated:YES];
    }
   
}

- (void)confirmTimes {
    if (self.selectedSchedules.count <= 0) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请先选中至少一个时间段！", nil) isError:YES];
        return;
    }
    
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:@"请稍后..."];
    [[HHStudentService sharedInstance] bookTimeSlotsWithSchedules:self.selectedSchedules student:[HHUserAuthenticator sharedInstance].currentStudent coachId:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId completion:^(BOOL succeed, NSInteger succeedCount) {
        if (succeed) {
            [HHToastUtility showToastWitiTitle:[NSString stringWithFormat:NSLocalizedString(@"预约成功%ld个时间", nil), succeedCount] isError:NO];
            [self fetchSchedulesWithCompletion:^{
                [[HHLoadingView sharedInstance] hideLoadingView];
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bookSucceed" object:self];
        } else {
            [[HHLoadingView sharedInstance] hideLoadingView];
            [HHToastUtility showToastWitiTitle:[NSString stringWithFormat:NSLocalizedString(@"预约失败！", nil), succeedCount] isError:YES];
        }
        [self.selectedSchedules removeAllObjects];
        self.confirmBarButtonItem = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"确认", nil) action:@selector(confirmTimes) target:self isLeft:NO];
        self.navigationItem.rightBarButtonItem = self.confirmBarButtonItem;
    }];

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


- (void)valueChanged:(UISegmentedControl *)control {
    self.sectionTiltes = [self groupSchedulesTitleWithFilter:control.selectedSegmentIndex];
    [self.selectedSchedules removeAllObjects];
    [self.tableView reloadData];
}

- (void)refreshData {
    __weak HHBookViewController *weakSelf = self;
    [self fetchSchedulesWithCompletion:^{
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)fetchSchedulesWithCompletion:(HHGenericCompletion)completion {
    __weak HHBookViewController *weakSelf = self;
    if (![HHUserAuthenticator sharedInstance].currentStudent.myCoachId) {
        if (completion) {
            completion();
        }
        return;
    }
    [[HHScheduleService sharedInstance] fetchCoachSchedulesWithCoachId:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId skip:0 completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
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
    __weak HHBookViewController *weakSelf = self;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中...", nil)];
    [[HHScheduleService sharedInstance] fetchCoachSchedulesWithCoachId:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId skip:self.schedules.count completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
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
    cell.hidePlusImage = NO;
    HHCoachSchedule *schedule = (HHCoachSchedule *)self.groupedSchedules[indexPath.section][indexPath.row];
    cell.schedule = schedule;
    __weak HHBookViewController *weakSelf = self;
    __weak HHTimeSlotTableViewCell *weakCell = cell;
    cell.block = ^(HHStudent *student) {
        if (student.avatarURL) {
            HHFullScreenImageViewController *vc = [[HHFullScreenImageViewController alloc] initWithImageURLArray:@[student.avatarURL] titleArray:@[student.fullName] initalIndex:0];
            [weakSelf.tabBarController presentViewController:vc animated:YES completion:nil];
        }
    };
    
    cell.emptyAvatarblock = ^(void){
        [weakSelf handleCellSelection:weakCell indexPath:indexPath];
    };
    
    if ([self.selectedSchedules containsObject:schedule]) {
        cell.selectedIndicatorView.hidden = NO;
        [cell.containerView bringSubviewToFront:cell.selectedIndicatorView];
    } else {
        cell.selectedIndicatorView.hidden = YES;
    }
    cell.students = schedule.fullStudents;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 15.f;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:self.sectionTiltes[section]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHTimeSlotTableViewCell *cell = (HHTimeSlotTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self handleCellSelection:cell indexPath:indexPath];
}

- (void)handleCellSelection:(HHTimeSlotTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {

    HHCoachSchedule *schedule = (HHCoachSchedule *)self.groupedSchedules[indexPath.section][indexPath.row];
    if ([schedule.reservedStudents containsObject:[HHUserAuthenticator sharedInstance].currentStudent.studentId]) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"已成功预约此时间段, 无需再预约！", nil) isError:YES];
        return;
    }
    
    if (schedule.reservedStudents.count == 4) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"该时间段人数已满（每个时间段最多4名学员）", nil) isError:YES];
        return;
    }
    
    if (cell.selectedIndicatorView.hidden) {
        if (self.selectedSchedules.count > 4) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"一次性最多选择5个时间段！", nil) isError:YES];
            return;
        }
        cell.selectedIndicatorView.hidden = NO;
        [cell.containerView bringSubviewToFront:cell.selectedIndicatorView];
        [self.selectedSchedules addObject:schedule];
        [self changeConfirmButtonTitle];
    } else {
        cell.selectedIndicatorView.hidden = YES;
        [self.selectedSchedules removeObject:schedule];
        [self changeConfirmButtonTitle];
        
    }
    
}

- (void)changeConfirmButtonTitle {
    if (self.selectedSchedules.count > 0) {
        self.confirmBarButtonItem = [UIBarButtonItem buttonItemWithTitle:[NSString stringWithFormat:@"%@(%ld)", NSLocalizedString(@"确认", nil), self.selectedSchedules.count] action:@selector(confirmTimes) target:self isLeft:NO];
    } else {
        self.confirmBarButtonItem = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"确认", nil) action:@selector(confirmTimes) target:self isLeft:NO];
    }
    self.navigationItem.rightBarButtonItem = self.confirmBarButtonItem;
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
