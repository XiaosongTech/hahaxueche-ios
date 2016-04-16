//
//  HHBookTrainingViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBookTrainingViewController.h"
#import "HHNavBarSegmentedControl.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHEmptyScheduleCell.h"
#import "HHStudentStore.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCoachService.h"
#import <UIImageView+WebCache.h>
#import "HHPopupUtility.h"
#import "HHNoCoachView.h"
#import "HHCoachScheduleCellTableViewCell.h"
#import "HHConfirmScheduleBookView.h"
#import "HHBookFailView.h"
#import "HHScheduleRateView.h"
#import "HHStudentService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "HHCoachSchedule.h"
#import <MJRefresh/MJRefresh.h>
#import "HHNotificationCell.h"
#import "HHConstantsStore.h"
#import "HHNotificationExplanationView.h"

typedef void (^HHRefreshScheduleCompletionBlock)();

static NSString *kEmptyCellId = @"emptyCellID";
static NSString *kScheduleCellId = @"scheduleCellId";
static NSString *kNotifCellId = @"notifCellId";

@interface HHBookTrainingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HHNavBarSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *notifTableView;
@property (nonatomic, strong) HHStudent *currentStudent;
@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic, strong) HHCoachSchedules *coachSchedulesObject;
@property (nonatomic, strong) HHCoachSchedules *mySchedulesObject;

@property (nonatomic, strong) NSMutableArray *myScheduleArray;
@property (nonatomic, strong) NSMutableArray *coachScheduleArray;

@property (nonatomic, strong) NSMutableArray *coachScheduleGroupedArray;
@property (nonatomic, strong) NSMutableArray *myScheduleGroupedArray;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;

@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, strong) NSMutableArray *showedNotifications;
@property (nonatomic, strong) NSMutableArray *backupNotifications;;


@property (nonatomic) BOOL hasCoach;

@end

@implementation HHBookTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预约学车";
    self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
    self.myScheduleArray = [NSMutableArray array];
    self.coachScheduleArray = [NSMutableArray array];
    self.myScheduleGroupedArray = [NSMutableArray array];
    self.coachScheduleGroupedArray = [NSMutableArray array];
    self.notifications = [[HHConstantsStore sharedInstance] getNotifications];
    self.showedNotifications = [NSMutableArray arrayWithArray:[self.notifications subarrayWithRange:NSMakeRange(0, 10)]];
    self.backupNotifications = [NSMutableArray arrayWithArray:[self.notifications subarrayWithRange:NSMakeRange(10, 10)]];
    
    NSArray *items = @[@"教练课程", @"我的课程"];
    self.segmentedControl = [[HHNavBarSegmentedControl alloc] initWithItems:items];
    self.segmentedControl.frame = CGRectMake(0, 0, ScheduleTypeCount * 70.0f, 30.0f);
    [self.segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];

    self.navigationItem.titleView = self.segmentedControl;
    if (self.currentStudent.currentCoachId) {
        self.hasCoach = YES;
        
    } else {
        self.hasCoach = NO;
    }
    
    
    if (self.hasCoach) {
        [self initSubviews];
        [self refreshCoachListWithType:ScheduleTypeCoachSchedule completion:nil];
        [self refreshCoachListWithType:ScheduleTypeMySchedule completion:nil];
    } else {
        [self buildNoCoachView];
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(addCell) userInfo:nil repeats:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:@"showedNotificationExpView"];
    if (!self.hasCoach && ![number boolValue]) {
        HHNotificationExplanationView *view = [[HHNotificationExplanationView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 240.f)];
        view.okBlock = ^() {
            [HHPopupUtility dismissPopup:self.popup];
        };
        self.popup = [HHPopupUtility createPopupWithContentView:view];
        [HHPopupUtility showPopup:self.popup];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(1) forKey:@"showedNotificationExpView"];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.notifTableView.bounds)-40.0f, CGRectGetWidth(self.notifTableView.bounds), 40.0f)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:view];
   
}

- (void)initSubviews {
    
    self.tableView = [self buildTableView];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    self.refreshHeader = [self buildHeader];
    self.loadMoreFooter = [self buildFooter];
    self.tableView.mj_footer = self.loadMoreFooter;
    self.tableView.mj_header = self.refreshHeader;
    
    [[HHCoachService sharedInstance] fetchCoachWithId:self.currentStudent.currentCoachId completion:^(HHCoach *coach, NSError *error) {
        if (!error) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
            UIBarButtonItem *imageButton = [[UIBarButtonItem alloc] initWithCustomView:imageView];
            self.navigationItem.rightBarButtonItem = imageButton;
        }
    }];

}

- (UITableView *)buildTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor HHBackgroundGary];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[HHEmptyScheduleCell class] forCellReuseIdentifier:kEmptyCellId];
    [tableView registerClass:[HHCoachScheduleCellTableViewCell class] forCellReuseIdentifier:kScheduleCellId];
    [tableView registerClass:[HHNotificationCell class] forCellReuseIdentifier:kNotifCellId];
    return tableView;
}

- (MJRefreshNormalHeader *)buildHeader {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [header setTitle:@"正在刷新课程列表" forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor HHLightTextGray];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    return header;
}

- (MJRefreshAutoNormalFooter *)buildFooter {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多课程" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多课程" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多课程" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    footer.stateLabel.textColor = [UIColor HHLightTextGray];
    return footer;
}


#pragma mark UITableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHBookTrainingViewController *weakSelf = self;
    
    if (!self.hasCoach) {
        HHNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:kNotifCellId forIndexPath:indexPath];
        [cell setupCellWithNotification:self.showedNotifications[indexPath.row]];
        return cell;
    }
    
    NSMutableArray *data = self.coachScheduleArray;
    NSMutableArray *groupedData = self.coachScheduleGroupedArray;
    
    if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeMySchedule) {
        data = self.myScheduleArray;
        groupedData = self.myScheduleGroupedArray;
    }
    
    if ([data count]) {
        NSDictionary *groupedSchedules = groupedData[indexPath.section];
        HHCoachSchedule *schedule = [[groupedSchedules allValues] firstObject][indexPath.row];
        HHCoachScheduleCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCellId forIndexPath:indexPath];
        cell.bookBlock = ^(HHCoachSchedule *schedule) {
            switch ([schedule.status integerValue]) {
                case 0: {
                    HHConfirmScheduleBookView *confirmView = [[HHConfirmScheduleBookView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds) - 20.0f, 350.0f) schedule:schedule isBooking:YES];
                    weakSelf.popup = [HHPopupUtility createPopupWithContentView:confirmView];
                    [HHPopupUtility showPopup:weakSelf.popup];
                    confirmView.confirmBlock = ^(HHCoachSchedule *schedule) {
                        [weakSelf bookScheduel:schedule];
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                    
                    confirmView.cancelBlock = ^() {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                } break;
                case 1: {
                    HHConfirmScheduleBookView *confirmView = [[HHConfirmScheduleBookView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds) - 20.0f, 350.0f) schedule:schedule isBooking:NO];
                    weakSelf.popup = [HHPopupUtility createPopupWithContentView:confirmView];
                    [HHPopupUtility showPopup:weakSelf.popup];
                    confirmView.confirmBlock = ^(HHCoachSchedule *schedule) {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                    
                    confirmView.cancelBlock = ^() {
                        [weakSelf cancelBookedScheduel:schedule];
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                } break;
                
                case 2: {
                    HHScheduleRateView *ratingView = [[HHScheduleRateView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds) - 20.0f, 220.0f)];
                    ratingView.cancelBlock = ^() {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                    ratingView.confirmBlock = ^(NSNumber *rating) {
                        [weakSelf reviewCoach:schedule.coach rating:rating];
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                    weakSelf.popup = [HHPopupUtility createPopupWithContentView:ratingView];
                    [HHPopupUtility showPopup:weakSelf.popup];

                } break;
                    
                default:
                    break;
            }
            
        };
        BOOL showLine = NO;
        if (indexPath.row == [groupedData[indexPath.section] count] - 1) {
            showLine = YES;
        }
        
        BOOL showDate = NO;
        if (indexPath.row == 0) {
            showDate = YES;
        }
        [cell setupCellWithSchedule:schedule showLine:showLine showDate:showDate];
        return cell;

    } else {
        NSString *text = @"教练目前还没有课程，请耐心等待哦～";
        if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeMySchedule) {
            text = @"您目前还没有预约的课程哦, 快去预约吧!";
        }
        HHEmptyScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellId];
        [cell setupCellWithTitle:text];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.hasCoach) {
        return self.showedNotifications.count;
    }
    if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeCoachSchedule) {
        if (![self.coachScheduleArray count]) {
            return 1;
        }
        return [self.coachScheduleGroupedArray[section] count];
    } else {
        if (![self.myScheduleArray count]) {
            return 1;
        }
        return [self.myScheduleGroupedArray[section] count];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.hasCoach) {
        return 1;
    }
    if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeCoachSchedule) {
        if (![self.coachScheduleArray count]) {
            return 1;
        }
        
        return [self.coachScheduleGroupedArray count];
        
    } else {
        if (![self.myScheduleArray count]) {
            return 1;
        }
        return [self.myScheduleGroupedArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.hasCoach) {
        return 80.0f;
    }
    if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeCoachSchedule) {
        if (![self.coachScheduleArray count]) {
            return CGRectGetHeight(self.tableView.bounds);
        } else {
            NSDictionary *groupedSchedules = self.coachScheduleGroupedArray[indexPath.section];
            HHCoachSchedule *schedule = [[groupedSchedules allValues] firstObject][indexPath.row];
            return  215.0f + (([schedule.maxStudentCount integerValue] - 1)/4) * (15.0f + kAvatarRadius * 2.0f);
        }
        
    } else {
        if (![self.myScheduleArray count]) {
            return CGRectGetHeight(self.tableView.bounds);
        } else {
            NSDictionary *groupedSchedules = self.myScheduleGroupedArray[indexPath.section];
            HHCoachSchedule *schedule = [[groupedSchedules allValues] firstObject][indexPath.row];
            return  215.0f + (([schedule.maxStudentCount integerValue] - 1)/4) * (15.0f + kAvatarRadius * 2.0f);
        }
    }
}

#pragma mark - Others

- (void)buildNoCoachView {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择教练" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    button.backgroundColor = [UIColor HHOrange];
    [button addTarget:self action:@selector(jumpToFindCoachVC) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    [self.view addSubview:button];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-(20.0f + CGRectGetHeight(self.tabBarController.tabBar.frame)));
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-40.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"快去寻找属于自己的好教练, 加入他们吧!";
    subLabel.textColor = [UIColor HHLightestTextGray];
    subLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:subLabel];
    
    [subLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.top).offset(-20.0f);
        make.centerX.equalTo(self.view.centerX);
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"您还没有选择教练哦~";
    titleLabel.textColor = [UIColor HHOrange];
    titleLabel.font = [UIFont systemFontOfSize:21.0f];
    [self.view addSubview:titleLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(subLabel.top).offset(-10.0f);
        make.centerX.equalTo(self.view.centerX);
    }];
    
    self.notifTableView = [self buildTableView];
    self.notifTableView.scrollEnabled = NO;
    [self.view addSubview:self.notifTableView];
    [self.notifTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(titleLabel.top).offset(-30.0f);
    }];

}

- (void)valueChanged:(UISegmentedControl *)segControl {
    if(!self.hasCoach) {
        segControl.selectedSegmentIndex = ScheduleTypeCoachSchedule;
        [self showNoCoachPopup];
        return;
    }
    [self.tableView reloadData];
    if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeCoachSchedule) {
        if (![self.coachScheduleArray count]) {
            self.loadMoreFooter.hidden = YES;
        } else {
            self.loadMoreFooter.hidden = NO;
        }
        if (!self.coachSchedulesObject.nextPage) {
            [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
        } else {
            [self.loadMoreFooter setState:MJRefreshStateIdle];
        }
    } else {
        if (![self.myScheduleArray count]) {
            self.loadMoreFooter.hidden = YES;
        } else {
            self.loadMoreFooter.hidden = NO;
        }
        if (!self.mySchedulesObject.nextPage) {
            [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
        } else {
            [self.loadMoreFooter setState:MJRefreshStateIdle];
        }
    }
}


- (void)showNoCoachPopup {
    HHNoCoachView *view = [[HHNoCoachView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, 180.0f)];
    [view.okButton addTarget:self action:@selector(dismissPopupView) forControlEvents:UIControlEventTouchUpInside];
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    
    [HHPopupUtility showPopup:self.popup];
    
}

- (void)dismissPopupView {
    [HHPopupUtility dismissPopup:self.popup];
}

- (void)jumpToFindCoachVC {
    self.tabBarController.selectedIndex = 1;
}

- (void)refreshCoachListWithType:(ScheduleType)type completion:(HHRefreshScheduleCompletionBlock)completion {
    if (!completion) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    [[HHStudentService sharedInstance] fetchScheduleWithId:[HHStudentStore sharedInstance].currentStudent.studentId scheduleType:@(type) completion:^(HHCoachSchedules *schedules, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (completion) {
            completion();
        }
        if(!error) {
            if (type == ScheduleTypeCoachSchedule) {
                self.coachSchedulesObject = schedules;
                self.coachScheduleArray = [NSMutableArray arrayWithArray:self.coachSchedulesObject.schedules];
                self.coachScheduleGroupedArray = [self groupedArray:self.coachScheduleArray];
            } else {
                self.mySchedulesObject = schedules;
                self.myScheduleArray = [NSMutableArray arrayWithArray:self.mySchedulesObject.schedules];;
                self.myScheduleGroupedArray = [self groupedArray:self.myScheduleArray];
            }
            [self.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"加载出错, 请重试!"];
        }
    }];
}

- (void)loadMoreCoachListWithCompletion:(HHRefreshScheduleCompletionBlock)completion {
    if (!completion) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    NSString *URL = self.coachSchedulesObject.nextPage;
    if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeMySchedule) {
        URL = self.mySchedulesObject.nextPage;
    }
    [[HHStudentService sharedInstance] fetchScheduleWithURL:URL completion:^(HHCoachSchedules *schedules, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (completion) {
            completion();
        }
        if(!error) {
            if (self.segmentedControl.selectedSegmentIndex == ScheduleTypeCoachSchedule) {
                self.coachSchedulesObject = schedules;
                [self.coachScheduleArray addObjectsFromArray:self.coachSchedulesObject.schedules];
                self.coachScheduleGroupedArray = [self groupedArray:self.coachScheduleArray];
            } else {
                self.mySchedulesObject = schedules;
                [self.myScheduleArray addObjectsFromArray:self.mySchedulesObject.schedules];
                self.myScheduleGroupedArray = [self groupedArray:self.myScheduleArray];
            }
            [self.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"加载出错, 请重试!"];
        }
    }];
}

- (NSMutableArray *)groupedArray:(NSArray *)originalArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableSet *groupSet = [NSMutableSet set];
    for (HHCoachSchedule *schedule in originalArray) {
        schedule.scheduleDate = [schedule getScheduleDate];
    }
    
    for (HHCoachSchedule *scheduel in originalArray) {
        if ([groupSet containsObject:scheduel.scheduleDate]) {
            continue;
        }
        NSArray *group = [originalArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"scheduleDate == %@", scheduel.scheduleDate]];
        NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
        groupDic[scheduel.scheduleDate] = group;
        [groupSet addObject:scheduel.scheduleDate];
        [resultArray addObject:groupDic];
    }
    return resultArray;
}

- (void)refreshData {
    __weak HHBookTrainingViewController *weakSelf = self;
    [self refreshCoachListWithType:self.segmentedControl.selectedSegmentIndex completion:^{
        [weakSelf.refreshHeader endRefreshing];
    }];
}


- (void)loadMoreData {
    __weak HHBookTrainingViewController *weakSelf = self;
    [self loadMoreCoachListWithCompletion:^{
        [weakSelf.loadMoreFooter endRefreshing];
    }];
}

- (void)setMySchedulesObject:(HHCoachSchedules *)mySchedulesObject {
    _mySchedulesObject = mySchedulesObject;
    if (!mySchedulesObject.nextPage) {
        [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
    } else {
        [self.loadMoreFooter setState:MJRefreshStateIdle];
    }
}

- (void)setCoachSchedulesObject:(HHCoachSchedules *)coachSchedulesObject {
    _coachSchedulesObject = coachSchedulesObject;
    if (!coachSchedulesObject.nextPage) {
        [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
    } else {
        [self.loadMoreFooter setState:MJRefreshStateIdle];
    }
    
}

- (void)addCell {
    NSIndexPath *insertPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *deletePath = [NSIndexPath indexPathForRow:9 inSection:0];
    [self.showedNotifications insertObject:[self.backupNotifications firstObject] atIndex:0
     ];
    [self.backupNotifications removeObjectAtIndex:0];
    [self.backupNotifications addObject:[self.showedNotifications lastObject]];
    [self.showedNotifications removeObjectAtIndex:self.showedNotifications.count-1];
    
    [self.notifTableView beginUpdates];
    [self.notifTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:insertPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.notifTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletePath] withRowAnimation:UITableViewRowAnimationNone];
    [self.notifTableView endUpdates];
    
}

- (void)bookScheduel:(HHCoachSchedule *)schedule {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] bookScheduleWithId:schedule.scheduleId completion:^(HHCoachSchedule *updatedSchedule, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            [self.coachScheduleArray removeObject:schedule];
            [self.coachScheduleGroupedArray removeObject:schedule];
            [self.myScheduleArray addObject:updatedSchedule];
            self.myScheduleGroupedArray = [self groupedArray:self.myScheduleArray];
            [[HHToastManager sharedManager] showSuccessToastWithText:@"预约成功!"];
            self.segmentedControl.selectedSegmentIndex = ScheduleTypeMySchedule;
            [self.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"预约失败, 请重试!"];
            HHBookFailView *failView = [[HHBookFailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 280.0f) type:ErrorTypeHasIncomplete];
            self.popup = [HHPopupUtility createPopupWithContentView:failView];
            [HHPopupUtility showPopup:self.popup];
            failView.cancelBlock = ^() {
                [HHPopupUtility dismissPopup:self.popup];
            };

        }
    }];
}

- (void)cancelBookedScheduel:(HHCoachSchedule *)schedule {
    
}

- (void)reviewCoach:(HHCoach *)coach rating:(NSNumber *)rating {
    
}

@end
