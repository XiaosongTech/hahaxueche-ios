//
//  HHCoachPriceDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachPriceDetailViewController.h"
#import "HHCoach.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHClassDetailView.h"
#import "HHPriceItemCollectionViewCell.h"

static NSString *const kCellId = @"kCellId";
static CGFloat const kCellHeight = 50.0f;

@interface HHCoachPriceDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) HHCoach *coach;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *classTypeLabel;
@property (nonatomic, strong) UILabel *standardFeeLabel;
@property (nonatomic, strong) UILabel *otherFeeLabel;

@property (nonatomic, strong) HHClassDetailView *standardClassView;
@property (nonatomic, strong) HHClassDetailView *vipClassView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSInteger columnCount;

@end


@implementation HHCoachPriceDetailViewController

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拿证价格";
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.rowCount = 6;
    self.columnCount = 5;
    
    [self initSubviews];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    self.classTypeLabel = [self buildLabelWithText:@"1.班别介绍"];
    [self.scrollView addSubview:self.classTypeLabel];
    [self.classTypeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.top.equalTo(self.scrollView.top).offset(20.0f);
    }];
    
    NSArray *standardClassItems = @[@"四人一车", @"专属学车顾问", @"超高性价比", @"绝无隐性收费", @"考前深度复训", @"补考免培训费"];
    self.standardClassView = [[HHClassDetailView alloc] initWithTitle:@"超值班" items:standardClassItems];
    [self.scrollView addSubview:self.standardClassView];
    [self.standardClassView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-30.0f);
        make.top.equalTo(self.classTypeLabel.bottom).offset(15.0f);
        make.height.mas_equalTo(35.0f + ((standardClassItems.count + 3 - 1)/3) * 25.0f + (((standardClassItems.count + 3 - 1)/3) - 1) * 15.0f);
    }];
    
    NSArray *vipClassItems = @[@"一人一车", @"专属学车顾问", @"学车更高效", @"绝无隐性收费", @"考前深度复训", @"补考免培训费"];
    self.vipClassView = [[HHClassDetailView alloc] initWithTitle:@"VIP班" items:vipClassItems];
    [self.scrollView addSubview:self.vipClassView];
    [self.vipClassView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-30.0f);
        make.top.equalTo(self.standardClassView.bottom).offset(20.0f);
        make.height.mas_equalTo(35.0f + ((standardClassItems.count + 3 - 1)/3) * 25.0f + (((vipClassItems.count + 3 - 1)/3) - 1) * 15.0f);
    }];
    
    self.standardFeeLabel = [self buildLabelWithText:@"2.费用明细"];
    [self.scrollView addSubview:self.standardFeeLabel];
    [self.standardFeeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.top.equalTo(self.vipClassView.bottom).offset(25.0f);
    }];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 1.0f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.scrollView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor HHLightLineGray];
    [self.collectionView registerClass:[HHPriceItemCollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.top.equalTo(self.standardFeeLabel.bottom).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-30.0f);
        make.height.mas_equalTo(self.rowCount * kCellHeight + self.rowCount-1);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];

}

- (UILabel *)buildLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:20.0f];
    return label;
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rowCount * self.columnCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor HHOrange];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth(self.view.bounds)-30.0f-(self.columnCount-1))/self.columnCount, kCellHeight);
}

@end
