//
//  HHCityViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBankSelectionViewController.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHCityCell.h"
#import "NSString+PinYin.h"

static NSString *const kCellId = @"kCellId";

@interface HHBankSelectionViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) NSMutableArray *popularBankViewArray;
@property (nonatomic, strong) UILabel *popularBankLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSArray *popularBanks;
@property (nonatomic, strong) NSArray *allBanks;
@property (nonatomic, strong) NSMutableArray *searchResultBanks;
@property (nonatomic, strong) HHBank *selectedBank;

@end

@implementation HHBankSelectionViewController

- (instancetype)initWithPopularbanks:(NSArray *)popularBanks allBanks:(NSArray *)allBanks selectedBank:(HHBank *)selectedBank {
    self = [super init];
    if (self) {
        self.popularBanks = popularBanks;
        self.allBanks = allBanks;
        self.selectedBank = selectedBank;
        self.popularBankViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.title = @"选择银行";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.backgroundColor = [UIColor HHBackgroundGary];
    self.searchBar.tintColor = [UIColor HHOrange];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索银行";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    self.popularBankLabel = [[UILabel alloc] init];
    self.popularBankLabel.text = @"常用银行";
    self.popularBankLabel.textColor = [UIColor HHLightestTextGray];
    self.popularBankLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:self.popularBankLabel];
    
    [self buildPopularBanksView];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor HHLightLineGray];
    [self.view addSubview:self.line];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.searchResultTableView = [[UITableView alloc] init];
    self.searchResultTableView.hidden = YES;
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchResultTableView];
    
    [self.tableView registerClass:[HHCityCell class] forCellReuseIdentifier:kCellId];
    [self.searchResultTableView registerClass:[HHCityCell class] forCellReuseIdentifier:kCellId];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(10.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-30.0f);
    }];
    
    [self.popularBankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.bottom).offset(10.0f);
        make.left.equalTo(self.view.left).offset(20.0f);
    }];
    
    UIButton *lastButton = [self.popularBankViewArray lastObject];
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastButton.bottom).offset(20.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [self.searchResultTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popularBankLabel.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildPopularBanksView {
    int j = 0;
    for (HHBank *bank in self.popularBanks) {
        UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cityButton.tag = j;
        [cityButton setTitle:bank.bankName forState:UIControlStateNormal];
        cityButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [cityButton addTarget:self action:@selector(cityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cityButton];
        [self.popularBankViewArray addObject:cityButton];
        
        if ([bank.bankCode isEqualToString:self.selectedBank.bankCode]) {
            cityButton.backgroundColor = [UIColor HHOrange];
            [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            cityButton.backgroundColor = [UIColor whiteColor];
            [cityButton setTitleColor:[UIColor HHTextDarkGray] forState:UIControlStateNormal];
        }
        j++;
    }
    
    int i = 0;
    for (UIButton *button in self.popularBankViewArray) {
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(20.0f + (i%3) * ((CGRectGetWidth(self.view.bounds)-60.0f)/3.0f + 10.0f));
            make.top.equalTo(self.popularBankLabel.bottom).offset(15.0f + (i/3) * 50.0f);
            make.width.mas_equalTo ((CGRectGetWidth(self.view.bounds)-60.0f)/3.0f);
            make.height.mas_equalTo(40.0f);
        }];
        i++;
    }
    
}

- (void)cityButtonTapped:(UIButton *)button {
    for (UIButton *cityButton in self.popularBankViewArray) {
        cityButton.backgroundColor = [UIColor whiteColor];
        [cityButton setTitleColor:[UIColor HHTextDarkGray] forState:UIControlStateNormal];
    }
    button.backgroundColor = [UIColor HHOrange];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectedBank = self.popularBanks[button.tag];
    [self bakSelected];
}

- (void)bakSelected {
    if (self.block) {
        self.block(self.selectedBank);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCityCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHBank *bank;
    if ([tableView isEqual:self.tableView]) {
        bank = self.allBanks[indexPath.row];
    } else {
        bank = self.searchResultBanks[indexPath.row];
    }
    cell.label.text = bank.bankName;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.allBanks.count;
    } else {
        return self.searchResultBanks.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
         self.selectedBank = self.allBanks[indexPath.row];
    } else {
        self.selectedBank = self.searchResultBanks[indexPath.row];
    }
    [self bakSelected];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""] || !searchText) {
        [self.tableView reloadData];
        self.searchResultTableView.hidden = YES;
    } else {
        self.searchResultTableView.hidden = NO;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bankName CONTAINS[cd] %@",searchText];
        self.searchResultBanks = [NSMutableArray arrayWithArray:[self.allBanks filteredArrayUsingPredicate:predicate]];
        [self.searchResultTableView reloadData];
    }
}
@end
