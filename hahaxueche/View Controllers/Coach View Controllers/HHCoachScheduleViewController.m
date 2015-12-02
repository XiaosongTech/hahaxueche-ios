//
//  HHCoachScheduleViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachScheduleViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCoachAddTimeViewController.h"
#import "HHCoachScheduleCell.h"
#import "HHCoachStudentProfileViewController.h"
#import "HHTimeSlotSectionTitleView.h"
#import "UIView+HHRect.h"
#import "HHCourseProgressStore.h"

static NSString *const cellID = @"ScheduleCellId";

@interface HHCoachScheduleViewController ()

@end

@implementation HHCoachScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = nil;
    self.title = NSLocalizedString(@"练车时间", nil);
    
    UIBarButtonItem *addTimeBarButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"添加课程", nil) action:@selector(addTime) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = addTimeBarButton;
    
    [self.tableView registerClass:[HHCoachScheduleCell class] forCellReuseIdentifier:cellID];
}

- (void)addTime {
    [[HHCourseProgressStore sharedInstance] getCourseProgressArrayWithCompletion:^(NSArray *courseProgressArray, NSError *error) {
        HHCoachAddTimeViewController *addTimeVC = [[HHCoachAddTimeViewController alloc] init];
        addTimeVC.successCompletion = ^(){
            [super fetchSchedulesWithCompletion:nil];
        };
        addTimeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addTimeVC animated:YES];
    }];
}

#pragma -mark TableView Delegate & DataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachScheduleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    HHCoachSchedule *schedule = (HHCoachSchedule *)self.groupedSchedules[indexPath.section][indexPath.row];
    cell.schedule = schedule;
    __weak HHCoachScheduleViewController *weakSelf = self;
    cell.block = ^(HHStudent *student) {
        HHCoachStudentProfileViewController *studentVC = [[HHCoachStudentProfileViewController alloc] init];
        studentVC.student = student;
        studentVC.transactionArray = nil;
        studentVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:studentVC animated:YES];
    };

    cell.students = schedule.fullStudents;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:self.sectionTiltes[section]];
    view.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0f];
    [view.titleLabel sizeToFit];
    [view.titleLabel setFrameWithY:(40.0f - CGRectGetHeight(view.titleLabel.bounds) + 10.0f)/2.0f];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145.0f;
}


@end
