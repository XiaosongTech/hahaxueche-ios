//
//  HHSelectVoucherViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 14/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSelectVoucherViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHVoucherSelectTableViewCell.h"

static NSString *const kCellId = @"kCellId";

@interface HHSelectVoucherViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *vouchers;
@property (nonatomic) NSInteger selectedIndex;

@end

@implementation HHSelectVoucherViewController

- (instancetype)initWithVouchers:(NSArray *)vouchers selectedIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        self.vouchers = vouchers;
        self.selectedIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择代金券";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor HHBackgroundGary];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHVoucherSelectTableViewCell class] forCellReuseIdentifier:kCellId];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vouchers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHVoucherSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    BOOL selected = NO;
    if (indexPath.row == self.selectedIndex) {
        selected = YES;
    }
    [cell setupCellWithVoucher:self.vouchers[indexPath.row] selected:selected];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    if (self.selectedBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        self.selectedBlock(self.selectedIndex);
    }
}


-(void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
