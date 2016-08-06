//
//  HHCityViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCityViewController.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHCityCell.h"
#import "NSString+PinYin.h"

static NSString *const kCellId = @"kCellId";

@interface HHCityViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) NSMutableArray *popularCityViewArray;
@property (nonatomic, strong) UILabel *popularCityLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSArray *popularCities;
@property (nonatomic, strong) NSArray *allCities;
@property (nonatomic, strong) NSArray *groupedCities;
@property (nonatomic, strong) NSMutableArray *searchResultCities;
@property (nonatomic, strong) NSString *selectedCity;

@end

@implementation HHCityViewController

- (instancetype)initWithPopularCities:(NSArray *)popularCities allCities:(NSArray *)allCities selectedCity:(NSString *)selectedCity {
    self = [super init];
    if (self) {
        self.popularCities = popularCities;
        self.allCities = allCities;
        self.selectedCity = selectedCity;
        self.groupedCities = [self.allCities sortAndGroupStringByFirstLetter];
        self.popularCityViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.title = @"选择开户城市";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.backgroundColor = [UIColor HHBackgroundGary];
    self.searchBar.tintColor = [UIColor HHOrange];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索城市";
    [self.view addSubview:self.searchBar];
    
    self.popularCityLabel = [[UILabel alloc] init];
    self.popularCityLabel.text = @"热门城市";
    self.popularCityLabel.textColor = [UIColor HHLightestTextGray];
    self.popularCityLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:self.popularCityLabel];
    
    [self buildPopularCitiesView];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor HHLightLineGray];
    [self.view addSubview:self.line];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.searchResultTableView = [[UITableView alloc] init];
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
    
    [self.popularCityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.bottom).offset(10.0f);
        make.left.equalTo(self.view.left).offset(20.0f);
    }];
    
    UIButton *lastButton = [self.popularCityViewArray lastObject];
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
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildPopularCitiesView {
    for (NSString *popularCity in self.popularCities) {
        UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cityButton setTitle:popularCity forState:UIControlStateNormal];
        cityButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [cityButton addTarget:self action:@selector(cityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cityButton];
        [self.popularCityViewArray addObject:cityButton];
        
        if ([popularCity isEqualToString:self.selectedCity]) {
            cityButton.backgroundColor = [UIColor HHOrange];
            [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            cityButton.backgroundColor = [UIColor whiteColor];
            [cityButton setTitleColor:[UIColor HHTextDarkGray] forState:UIControlStateNormal];
        }
    }
    
    int i = 0;
    for (UIButton *button in self.popularCityViewArray) {
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(20.0f + (i%3) * ((CGRectGetWidth(self.view.bounds)-60.0f)/3.0f + 10.0f));
            make.top.equalTo(self.popularCityLabel.bottom).offset(15.0f + (i/3) * 50.0f);
            make.width.mas_equalTo ((CGRectGetWidth(self.view.bounds)-60.0f)/3.0f);
            make.height.mas_equalTo(40.0f);
        }];
        i++;
    }
    
}

- (void)cityButtonTapped:(UIButton *)button {
    for (UIButton *cityButton in self.popularCityViewArray) {
        cityButton.backgroundColor = [UIColor whiteColor];
        [cityButton setTitleColor:[UIColor HHTextDarkGray] forState:UIControlStateNormal];
    }
    button.backgroundColor = [UIColor HHOrange];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectedCity = button.titleLabel.text;
    [self citySelected];
}

- (void)citySelected {
    if (self.block) {
        self.block(self.selectedCity);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCityCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    if ([tableView isEqual:self.tableView]) {
        cell.label.text = self.groupedCities[indexPath.section][indexPath.row];
    } else {
        cell.label.text = self.searchResultCities[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableView]) {
        return 4;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return 2;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return 30.0f;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
         self.selectedCity = self.groupedCities[indexPath.section][indexPath.row];
    } else {
        
    }
    [self citySelected];
}

@end
