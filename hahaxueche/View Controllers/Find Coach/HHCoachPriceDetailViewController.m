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
#import "HHOtherFeeItemView.h"
#import "HHConstantsStore.h"
#import "HHCityFixedFee.h"
#import "HHCityOtherFee.h"
#import "NSNumber+HHNumber.h"
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"

static NSString *const kCellId = @"kCellId";
static CGFloat const kCellHeight = 50.0f;

@interface HHCoachPriceDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, TTTAttributedLabelDelegate>

@property (nonatomic, strong) HHCoach *coach;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *classTypeLabel;
@property (nonatomic, strong) UILabel *standardFeeLabel;
@property (nonatomic, strong) UILabel *otherFeeLabel;
@property (nonatomic, strong) TTTAttributedLabel *supportLabel;

@property (nonatomic, strong) HHClassDetailView *standardClassView;
@property (nonatomic, strong) HHClassDetailView *vipClassView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSNumber *columnCount;
@property (nonatomic) NSInteger fixedFeesCount;
@property (nonatomic) NSInteger totalFixedFeesAmount;

@property (nonatomic, strong) NSArray *classTypes;
@property (nonatomic, strong) NSArray *fixedFees;
@property (nonatomic, strong) NSArray *otherFees;
@property (nonatomic, strong) NSMutableArray *otherFeeItems;

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
    self.fixedFeesCount = [[HHConstantsStore sharedInstance] getCityWithId:self.coach.cityId].cityFixedFees.count;
    self.rowCount = self.fixedFeesCount + 3;
    self.columnCount = @(5);
    self.classTypes = @[@"C1超值班", @"C1VIP班", @"C2超值班", @"C2VIP班"];
    self.fixedFees = [[HHConstantsStore sharedInstance] getCityWithId:self.coach.cityId].cityFixedFees;
    self.otherFees = [[HHConstantsStore sharedInstance] getCityWithId:self.coach.cityId].cityOtherFees;
    self.otherFeeItems = [NSMutableArray array];
    
    self.totalFixedFeesAmount = 0;
    for (HHCityFixedFee *fee in self.fixedFees) {
        self.totalFixedFeesAmount = self.totalFixedFeesAmount + [fee.feeAmount integerValue];
    }
    
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
        make.height.mas_equalTo(30.0f + ((standardClassItems.count + 3 - 1)/3) * 25.0f + (((standardClassItems.count + 3 - 1)/3) - 1) * 15.0f);
    }];
    
    NSArray *vipClassItems = @[@"一人一车", @"专属学车顾问", @"学车更高效", @"绝无隐性收费", @"考前深度复训", @"补考免培训费"];
    self.vipClassView = [[HHClassDetailView alloc] initWithTitle:@"VIP班" items:vipClassItems];
    [self.scrollView addSubview:self.vipClassView];
    [self.vipClassView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-30.0f);
        make.top.equalTo(self.standardClassView.bottom).offset(20.0f);
        make.height.mas_equalTo(30.0f + ((standardClassItems.count + 3 - 1)/3) * 25.0f + (((vipClassItems.count + 3 - 1)/3) - 1) * 15.0f);
    }];
    
    self.standardFeeLabel = [self buildLabelWithText:@"2.费用明细"];
    [self.scrollView addSubview:self.standardFeeLabel];
    [self.standardFeeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.top.equalTo(self.vipClassView.bottom).offset(25.0f);
    }];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.scrollView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[HHPriceItemCollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.top.equalTo(self.standardFeeLabel.bottom).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-30.0f);
        make.height.mas_equalTo(self.rowCount * kCellHeight);
    }];
    
    
    self.otherFeeLabel = [self buildLabelWithText:@"3.额外可能产生的费用"];
    [self.scrollView addSubview:self.otherFeeLabel];
    [self.otherFeeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.top.equalTo(self.collectionView.bottom).offset(25.0f);
    }];
    
    int i = 0;
    for (HHCityOtherFee *otherFee in self.otherFees) {
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.lineSpacing = 3.0f;
        para.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[otherFee.feeDes stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:para}];
        HHOtherFeeItemView *item = [[HHOtherFeeItemView alloc] initWithTitle:otherFee.feeName text:text];
        [self.scrollView addSubview:item];
        [self.otherFeeItems addObject:item];
        if (i == 0) {
            [item makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left).offset(15.0f);
                make.width.equalTo(self.scrollView.width).offset(-30.0f);
                make.top.equalTo(self.otherFeeLabel.bottom).offset(15.0f);
                make.height.mas_equalTo(30.0f + CGRectGetHeight([self getDescriptionTextSizeWithText:text]));
            }];
        } else {
            HHOtherFeeItemView *preItem = self.otherFeeItems[i-1];
            [item makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left).offset(15.0f);
                make.width.equalTo(self.scrollView.width).offset(-30.0f);
                make.top.equalTo(preItem.bottom).offset(15.0f);
                make.height.mas_equalTo(30.0f + CGRectGetHeight([self getDescriptionTextSizeWithText:text]));
            }];
        }
        
        i++;
    }
    
    self.supportLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.supportLabel.attributedText = [self buildAttributeString];
    self.supportLabel.delegate = self;
    self.supportLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.supportLabel];
    [self.supportLabel makeConstraints:^(MASConstraintMaker *make) {
        HHOtherFeeItemView *lastItem = [self.otherFeeItems lastObject];
        make.top.equalTo(lastItem.bottom).offset(30.0f);
        make.left.equalTo(self.scrollView.left).offset(15.0f);
        make.width.equalTo(self.scrollView.width).offset(-30.0f);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.supportLabel
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
    label.font = [UIFont systemFontOfSize:18.0f];
    return label;
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HHPriceItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    if (indexPath.row <= 4) {
        cell.label.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor HHOrange];
        if (indexPath.row == 0) {
           cell.label.text = @"费用/班别";
        } else {
            cell.label.text = self.classTypes[indexPath.row - 1];
        }
    } else if (indexPath.row <= 4 + self.fixedFeesCount * 2) {
        cell.label.textColor = [UIColor HHOrange];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        HHCityFixedFee *fee = self.fixedFees[(indexPath.row - [self.columnCount integerValue])/2];
        if (indexPath.row % 2 == 1) {
            cell.label.text = fee.feeName;
        } else {
            cell.label.text = [fee.feeAmount generateMoneyString];
        }
    } else {
        cell.label.textColor = [UIColor HHOrange];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (indexPath.row < [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 && indexPath.row >= [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 10) {
            if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 1) {
                NSString *moneyString = @"无";
                if ([self.coach.c2VIPPrice floatValue] > 0) {
                    moneyString = [self.coach.c2VIPPrice generateMoneyString];
                }
                cell.label.text = moneyString;
            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 2) {
                NSString *moneyString = @"无";
                if ([self.coach.c2Price floatValue] > 0) {
                    moneyString = [self.coach.c2Price generateMoneyString];
                }
                cell.label.text = moneyString;
            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 3) {
                NSString *moneyString = @"无";
                if ([self.coach.VIPPrice floatValue] > 0) {
                    moneyString = [self.coach.VIPPrice generateMoneyString];
                }
                cell.label.text = moneyString;
            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 4) {
                NSString *moneyString = @"无";
                if ([self.coach.price floatValue] > 0) {
                    moneyString = [self.coach.price generateMoneyString];
                }
                cell.label.text = moneyString;
            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 5) {
                cell.label.text = @"总费用";
                
            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 6) {
                NSString *moneyString = @"无";
                if ([self.coach.c2VIPPrice floatValue] > 0) {
                    moneyString = [@([self.coach.c2VIPPrice integerValue] - self.totalFixedFeesAmount) generateMoneyString];
                }
                cell.label.text = moneyString;
                
                
            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 7) {
                NSString *moneyString = @"无";
                if ([self.coach.c2Price floatValue] > 0) {
                    moneyString = [@([self.coach.c2Price integerValue] - self.totalFixedFeesAmount) generateMoneyString];
                }
                cell.label.text = moneyString;
                
                
            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 8) {
                NSString *moneyString = @"无";
                if ([self.coach.VIPPrice floatValue] > 0) {
                    moneyString = [@([self.coach.VIPPrice integerValue] - self.totalFixedFeesAmount) generateMoneyString];
                }
                cell.label.text = moneyString;
                

            } else if (indexPath.row ==  [self.columnCount integerValue] * 3 + self.fixedFeesCount * 2 - 9) {
                NSString *moneyString = @"无";
                if ([self.coach.price floatValue] > 0) {
                    moneyString = [@([self.coach.price integerValue] - self.totalFixedFeesAmount) generateMoneyString];
                }
                cell.label.text = moneyString;
                
                
            } else {
                cell.label.text = @"培训费";
            }
            
        } else {
            
        }
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 4 && indexPath.row <= 4 + self.fixedFeesCount * 2) {
        if (indexPath.row % 2 == 1) {
            return CGSizeMake((CGRectGetWidth(self.view.bounds)-30.1f)/[self.columnCount floatValue], kCellHeight);
        } else {
            return CGSizeMake((CGRectGetWidth(self.view.bounds)-30.1f) * 4/[self.columnCount floatValue], kCellHeight);
        }
        
    } else {
        return CGSizeMake((CGRectGetWidth(self.view.bounds)-30.1f)/[self.columnCount floatValue], kCellHeight);
    }
}
- (CGRect)getDescriptionTextSizeWithText:(NSAttributedString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-30.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                     context:nil];
    return rect;
}

- (NSMutableAttributedString *)buildAttributeString {
    NSString *baseString = @"对订单有任何疑问可致电客服热线400-001-6006 或 点击联系:在线客服";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[baseString rangeOfString:@"400-001-6006"]];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[baseString rangeOfString:@"在线客服"]];
    
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[baseString rangeOfString:@"400-001-6006"]];
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[baseString rangeOfString:@"在线客服"]];
    
    return attrString;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
    } else {
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}

@end
