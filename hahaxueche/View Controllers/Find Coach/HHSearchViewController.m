//
//  HHSearchCoachViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/23/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSearchViewController.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "HHCoachService.h"
#import "HHCoachListViewCell.h"
#import "HHConstantsStore.h"
#import "HHCoachDetailViewController.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentStore.h"
#import "HHSearchHistoryListView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "HHWebViewController.h"
#import "PopoverView.h"
#import "HHHotSchoolsView.h"
#import "HHDrivingSchoolListViewCell.h"
#import "HHDrivingSchoolDetailViewController.h"
#import "HHEventTrackingManager.h"
#import "HHSupportUtility.h"

static NSString *const kCoachCellId = @"kCoachCellId";
static NSString *const kSchoolCellId = @"kSchoolCellId";

static CGFloat const kCellHeightNormal = 100.0f;

@interface HHSearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSMutableArray *coaches;
@property (nonatomic, strong) NSMutableArray *schools;
@property (nonatomic, strong) HHSearchHistoryListView *searchHistoryListView;
@property (nonatomic, strong) HHHotSchoolsView *hotSchoolsView;
@property (nonatomic) NSInteger currentType;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *leftView;

@end

@implementation HHSearchViewController

- (instancetype)initWithType:(NSInteger)type {
    self = [super init];
    if (self) {
        self.currentType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-70.0f, 30.0f)];
    self.searchTextField.backgroundColor = [UIColor colorWithRed:0.99 green:0.72 blue:0.30 alpha:1.00];
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.cornerRadius = 15.0f;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.font = [UIFont systemFontOfSize:14.0f];
    self.searchTextField.tintColor = [UIColor whiteColor];
    self.searchTextField.textColor = [UIColor whiteColor];
    if (self.currentType == 0) {
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索驾校" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.6f], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    } else {
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索教练" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.6f], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    }
    
    self.searchTextField.delegate = self;
    self.navigationItem.titleView = self.searchTextField;
    [self.searchTextField becomeFirstResponder];
    
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70.0f, 30.0f)];
    self.leftView.backgroundColor = [UIColor clearColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60.0f, 5.0f, 1.0f, 20.0f)];
    line.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [self.leftView addSubview:line];

    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.font = [UIFont systemFontOfSize:13.0f];
    if (self.currentType == 0) {
        self.typeLabel.text = @"驾校";
    } else {
        self.typeLabel.text = @"教练";
    }
    [self.leftView addSubview:self.typeLabel];
    [self.typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.left).offset(10.0f);
        make.centerY.equalTo(self.leftView.centerY);
    }];
    
    UIImageView *triangleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Triangle"]];
    [self.leftView addSubview:triangleView];
    [triangleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.right).offset(5.0f);
        make.centerY.equalTo(self.leftView.centerY);
    }];
    
    self.searchTextField.leftView = self.leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeTapped)];
    [self.leftView addGestureRecognizer:rec];

    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"取消" titleColor:[UIColor whiteColor] action:@selector(popupVC) target:self isLeft:NO];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[HHCoachListViewCell class] forCellReuseIdentifier:kCoachCellId];
    [self.tableView registerClass:[HHDrivingSchoolListViewCell class] forCellReuseIdentifier:kSchoolCellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    __weak HHSearchViewController *weakSelf = self;
    self.hotSchoolsView = [[HHHotSchoolsView alloc] init];
    self.hotSchoolsView.schoolBlock = ^(HHDrivingSchool *school) {
        HHDrivingSchoolDetailViewController *vc = [[HHDrivingSchoolDetailViewController alloc] initWithSchool:school];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:search_page_hot_school_tapped attributes:@{@"index":@([[[HHConstantsStore sharedInstance] getDrivingSchools] indexOfObject:school])}];
    };
    [self.view addSubview:self.hotSchoolsView];
    [self.hotSchoolsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(130.0f);
        
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"schoolSearchKeywords";
    if (self.currentType == 1) {
        key = @"coachSearchKeywords";
    }
    NSArray *keywords = [defaults objectForKey:key];
    
    [self buildKeywordHistoryViewWithKeywords:keywords];
    
    
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHSearchViewController *weakSelf = self;
    if (self.currentType == 0) {
        HHDrivingSchoolListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolCellId forIndexPath:indexPath];
        HHDrivingSchool *school = self.schools[indexPath.row];
        cell.callBlock = ^{
            [[HHSupportUtility sharedManager] callSupportWithNumber:school.consultPhone];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:search_page_call_school_tapped attributes:nil];
        };
        [cell setupCellWithSchool:school];
        return cell;
        
    } else {
        HHCoachListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachCellId forIndexPath:indexPath];
        
        HHCoach *coach = self.coaches[indexPath.row];
        [cell setupCellWithCoach:coach field:[[HHConstantsStore sharedInstance] getFieldWithId:coach.fieldId]];
        cell.callBlock = ^{
            [[HHSupportUtility sharedManager] callSupportWithNumber:coach.consultPhone];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:search_page_call_coach_tapped attributes:nil];
        };
        cell.drivingSchoolBlock = ^(HHDrivingSchool *school) {
            HHDrivingSchoolDetailViewController *vc =  [[HHDrivingSchoolDetailViewController alloc] initWithSchool:[coach getCoachDrivingSchool]];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        
        return cell;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentType == 0) {
         return self.schools.count;
    } else {
         return self.coaches.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightNormal + 40.0f;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentType == 0) {
        if ([self.schools count]) {
            HHDrivingSchool *school = self.schools[indexPath.row];
            HHDrivingSchoolDetailViewController *vc =  [[HHDrivingSchoolDetailViewController alloc] initWithSchool:school];
            [self.navigationController pushViewController:vc animated:YES];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:search_page_school_tapped attributes:@{@"school_id":school.schoolId}];
        }
    } else {
        if ([self.coaches count]) {
            HHCoach *coach = self.coaches[indexPath.row];
            HHCoachDetailViewController *coachDetailVC = [[HHCoachDetailViewController alloc] initWithCoach:coach];
            [self.navigationController pushViewController:coachDetailVC animated:YES];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:search_page_coach_tapped attributes:@{@"coach_id":coach.coachId}];
        }
    }
}

- (void)popupVC {
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.currentType == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *keywords = [defaults objectForKey:@"schoolSearchKeywords"];
        NSMutableArray *newKeywords = [NSMutableArray arrayWithArray:keywords];
        if ([newKeywords containsObject:textField.text]) {
            [newKeywords removeObject:textField.text];
        }
        [newKeywords insertObject:textField.text atIndex:0];
        [defaults setObject:newKeywords forKey:@"schoolSearchKeywords"];
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHCoachService sharedInstance] searchSchoolWithKeyword:textField.text completion:^(NSArray *schools, NSError *error) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (!error) {
                [self.searchTextField resignFirstResponder];
                self.schools = [NSMutableArray arrayWithArray:schools];
                [self.tableView reloadData];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
            }
        }];
        
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *keywords = [defaults objectForKey:@"coachSearchKeywords"];
        NSMutableArray *newKeywords = [NSMutableArray arrayWithArray:keywords];
        if ([newKeywords containsObject:textField.text]) {
            [newKeywords removeObject:textField.text];
        }
        [newKeywords insertObject:textField.text atIndex:0];
        [defaults setObject:newKeywords forKey:@"coachSearchKeywords"];
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHCoachService sharedInstance] searchCoachWithKeyword:textField.text completion:^(NSArray *coaches, NSError *error) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (!error) {
                [self.searchTextField resignFirstResponder];
                self.coaches = [NSMutableArray arrayWithArray:coaches];
                [self.tableView reloadData];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
            }
        }];
    }
    
    self.searchHistoryListView.hidden = YES;
    self.hotSchoolsView.hidden = YES;
    self.tableView.hidden = NO;
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"schoolSearchKeywords";
    if (self.currentType == 1) {
        key = @"coachSearchKeywords";
    }
    NSArray *keywords = [defaults objectForKey:key];
    
    [self buildKeywordHistoryViewWithKeywords:keywords];

    self.searchHistoryListView.hidden = NO;
    self.hotSchoolsView.hidden = NO;
    self.tableView.hidden = YES;
}


- (void)buildKeywordHistoryViewWithKeywords:(NSArray *)keywords {
    if(self.searchHistoryListView) {
        [self.searchHistoryListView removeFromSuperview];
        self.searchHistoryListView = nil;
    }
    
    __weak HHSearchViewController *weakSelf = self;
    self.searchHistoryListView = [[HHSearchHistoryListView alloc] initWithHistory:keywords];
    self.searchHistoryListView.keywordRemoveBlock = ^{
        NSString *key = @"schoolSearchKeywords";
        if (self.currentType == 1) {
            key = @"coachSearchKeywords";
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSMutableArray array] forKey:key];
        
    };
    self.searchHistoryListView.keywordBlock = ^(NSString *keyword) {
        weakSelf.searchTextField.text = keyword;
        [weakSelf textFieldShouldReturn:weakSelf.searchTextField];
    };
    [self.view addSubview:self.searchHistoryListView];
    
    CGFloat height = MIN(keywords.count * 40.0f + 80.0f, 200.0f);
    [self.searchHistoryListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotSchoolsView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(height);
    }];

}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.currentType == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"木有找到匹配的驾校, 换个关键词重新试试吧~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    } else {
        return [[NSMutableAttributedString alloc] initWithString:@"木有找到匹配的教练, 换个关键词重新试试吧~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    }
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

- (void)typeTapped {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"驾校" handler:^(PopoverAction *action) {
        self.typeLabel.text = @"驾校";
        self.currentType = 0;
    }];
    
    PopoverAction *action2 = [PopoverAction actionWithTitle:@"教练" handler:^(PopoverAction *action) {
        self.typeLabel.text = @"教练";
        self.currentType = 1;
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:self.leftView withActions:@[action1, action2]];
}

- (void)setCurrentType:(NSInteger)currentType {
    _currentType = currentType;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"schoolSearchKeywords";
    if (self.currentType == 1) {
        key = @"coachSearchKeywords";
    }
    NSArray *keywords = [defaults objectForKey:key];
    [self buildKeywordHistoryViewWithKeywords:keywords];
    self.searchHistoryListView.hidden = NO;
    self.hotSchoolsView.hidden = NO;
    self.tableView.hidden = YES;
    
    if (self.currentType == 0) {
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索驾校" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.6f], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    } else {
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索教练" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.6f], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    }
}


@end
