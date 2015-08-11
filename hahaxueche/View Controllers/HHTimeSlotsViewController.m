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

#define kTimeSlotCellIdentifier @"kTimeSlotCellIdentifier"

@interface HHTimeSlotsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groupedSchedules;
@property (nonatomic, strong) NSArray *sectionTiltes;
@property (nonatomic, strong) NSMutableArray *selectedSchedules;
@property (nonatomic, strong) NSMutableDictionary *studentsForSchedules;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic)         BOOL canSelectTime;
@property (nonatomic, strong) UISegmentedControl *filterSegmentedControl;
@property (nonatomic, strong) NSArray *schedules;

@end

@implementation HHTimeSlotsViewController

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)setSchedules:(NSArray *)schedules {
    _schedules = schedules;
    self.sectionTiltes = [self groupSchedulesTitleWithFilter:self.filterSegmentedControl.selectedSegmentIndex];
    [self.tableView reloadData];
}

- (void)setCanSelectTime:(BOOL)canSelectTime {
    _canSelectTime = canSelectTime;
    if (self.canSelectTime) {
        self.confirmButton.enabled = YES;
        [self.confirmButton setBackgroundColor:[UIColor HHOrange]];
        
    } else {
        self.confirmButton.enabled = NO;
        [self.confirmButton setBackgroundColor:[UIColor HHLightGrayBackgroundColor]];
    }
    
}
- (void)fetchSchedules {
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中...", nil)];
    [[HHScheduleService sharedInstance] fetchCoachSchedulesWithCoachId:self.coach.coachId skip:self.schedules.count completion:^(NSArray *objects, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            self.schedules = objects;
            for (HHCoachSchedule *schedule in self.schedules) {
                [[HHStudentService sharedInstance] fetchStudentsForScheduleWithIds:schedule.reservedStudents completion:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        self.studentsForSchedules[schedule.objectId] = objects;
                        [self.tableView reloadData];
                    }
                }];

            }

        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据是出错！", nil) isError:YES];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.title = NSLocalizedString(@"预约时间", nil);
    self.navigationItem.hidesBackButton = YES;
    self.selectedSchedules = [NSMutableArray array];
    self.studentsForSchedules = [NSMutableDictionary dictionary];
    
    UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor =[UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHTimeSlotTableViewCell class] forCellReuseIdentifier:kTimeSlotCellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.confirmButton = [self createButtonWithTitle:NSLocalizedString(@"确认时间(已选中0)", nil) backgroundColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f] action:@selector(confirmTime)];
    
    if ([self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        self.canSelectTime = YES;
    } else {
        self.canSelectTime = NO;
    }
    

    
    self.filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"全部", nil), NSLocalizedString(@"科目二", nil), NSLocalizedString(@"科目三", nil)]];
    [self.filterSegmentedControl setFrame:CGRectMake(0, 0, 180.0f, 25.0f)];
    [self.filterSegmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    self.filterSegmentedControl.selectedSegmentIndex = 0;
    self.filterSegmentedControl.tintColor = [UIColor whiteColor];
    [self.filterSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor HHLightGrayBackgroundColor], NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:12.0f]} forState:UIControlStateNormal];
    self.navigationItem.titleView = self.filterSegmentedControl;
    
    [self fetchSchedules];
    [self autoLayoutSubviews];
}

-(void)valueChanged:(UISegmentedControl *)control {
    [self groupSchedulesTitleWithFilter:control.selectedSegmentIndex];
    [self.selectedSchedules removeAllObjects];
    [self.tableView reloadData];
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
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.tableView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:-50.0f],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                       
                             [HHAutoLayoutUtility setCenterX:self.confirmButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.confirmButton constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.confirmButton multiplier:0 constant:50.0f],
                             [HHAutoLayoutUtility setViewWidth:self.confirmButton multiplier:1.0f constant:0],
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

    HHCoachSchedule *firstSchedule = [filteredArray firstObject];
    NSDate *previousDate = firstSchedule.startDateTime;
    NSMutableArray *currentGroup = [NSMutableArray array];
    [currentGroup addObject:firstSchedule];
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
    __weak HHTimeSlotTableViewCell *weakCell = cell;
    cell.block = ^(HHStudent *student) {
        HHFullScreenImageViewController *vc = [[HHFullScreenImageViewController alloc] initWithImageURL:[NSURL URLWithString:student.avatarURL] title:student.fullName];
        [weakSelf.tabBarController presentViewController:vc animated:YES completion:nil];
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
    [cell setupViews];
    cell.students = self.studentsForSchedules[schedule.objectId];
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
    return 118.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHTimeSlotTableViewCell *cell = (HHTimeSlotTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self handleCellSelection:cell indexPath:indexPath];
}

- (void)handleCellSelection:(HHTimeSlotTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (!self.canSelectTime) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"确认教练并付款后才能预约时间!", nil) isError:YES];
        return;
    }
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
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"确认时间(已选中%ld)", nil), self.selectedSchedules.count];
    if (self.selectedSchedules.count == 0) {
        self.confirmButton.enabled = NO;
    } else {
        self.confirmButton.enabled = YES;
    }
    [self.confirmButton setTitle:text forState:UIControlStateNormal];
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

#pragma mark Hide TabBar

- (BOOL)hidesBottomBarWhenPushed {
    return (self.navigationController.topViewController == self);
}

@end
