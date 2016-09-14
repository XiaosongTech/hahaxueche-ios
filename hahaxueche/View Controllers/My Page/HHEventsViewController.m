//
//  HHEventsViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHEventsViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHEvent.h"
#import "HHEventCardCell.h"
#import "HHWebViewController.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentService.h"
#import "HHStudentStore.h"

static NSString *const kCellID = @"kEventCardCellId";

@interface HHEventsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *events;

@end


@implementation HHEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"限时活动";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_startscreen_bk"]];
    [self.view addSubview:self.bgImageView];
    
    [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];

    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.tableView registerClass:[HHEventCardCell class] forCellReuseIdentifier:kCellID];
    
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] getCityEventsWithId:[HHStudentStore sharedInstance].currentStudent.cityId completion:^(NSArray *events, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            self.events = events;
            [self.tableView reloadData];
        }
    }];

}

#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHEventCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    [cell setupCellWithEvent:self.events[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHWebViewController *vc = [[HHWebViewController alloc] initWithEvent:self.events[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
