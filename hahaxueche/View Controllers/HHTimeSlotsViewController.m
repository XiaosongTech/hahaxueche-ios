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

#define kTimeSlotCellIdentifier @"kTimeSlotCellIdentifier"

@interface HHTimeSlotsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groupedSchedules;
@property (nonatomic, strong) NSArray *sectionTiltes;
@property (nonatomic, strong) NSMutableArray *selectedSchedules;

@end

@implementation HHTimeSlotsViewController

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)setSchedules:(NSArray *)schedules {
    _schedules = schedules;
    self.sectionTiltes = [self groupSchedulesTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.title = NSLocalizedString(@"预约时间", nil);
    self.navigationItem.hidesBackButton = YES;
    self.selectedSchedules = [NSMutableArray array];
    
    UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    
    UIBarButtonItem *confirmButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"确认", nil) action:@selector(confirmTime) target:self isLeft:NO];
    [self.navigationItem setRightBarButtonItem:confirmButton];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor =[UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHTimeSlotTableViewCell class] forCellReuseIdentifier:kTimeSlotCellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self autoLayoutSubviews];
}

- (void)confirmTime {
    if (self.selectedSchedules.count <= 0) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请先选中至少一个时间段！", nil) isError:YES];
        return;
    }
    
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSArray *)groupSchedulesTitle {
    NSMutableArray *array = [NSMutableArray array];
    HHCoachSchedule *firstSchedule = [self.schedules firstObject];
    NSDate *previousDate = firstSchedule.startDateTime;
    NSMutableArray *currentGroup = [NSMutableArray array];
    [currentGroup addObject:firstSchedule];
    for (int i = 1; i < self.schedules.count; i++) {
        HHCoachSchedule *schedule = self.schedules[i];
        if ([[[HHFormatUtility dateFormatter] stringFromDate:schedule.startDateTime] isEqualToString:[[HHFormatUtility dateFormatter] stringFromDate:previousDate]]) {
            [currentGroup addObject:schedule];
        } else {
            [array addObject:currentGroup];
            currentGroup = [NSMutableArray array];
            [currentGroup addObject:schedule];
        }
        if (i == self.schedules.count - 1) {
            [array addObject:currentGroup];
        }
    }
    self.groupedSchedules = array;
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.groupedSchedules.count; i++) {
        HHCoachSchedule *schedule = [self.groupedSchedules[i] firstObject];
        NSString *date = [[HHFormatUtility fullDateFormatter] stringFromDate:schedule.startDateTime];
        NSString *title = [NSString stringWithFormat:@"%@\n%@", date, [[HHFormatUtility weekDayFormatter] stringFromDate:schedule.startDateTime]];
        [titles addObject:title];
    }
    return titles;
}


#pragma -mark TableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedSchedules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHTimeSlotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTimeSlotCellIdentifier forIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *schedules = self.groupedSchedules[section];
    return schedules.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:self.sectionTiltes[section]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
