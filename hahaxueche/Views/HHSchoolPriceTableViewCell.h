//
//  HHSchoolPriceTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 05/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDrivingSchool.h"


typedef void (^HHSchoolPriceBlock)(NSInteger index);
typedef void (^HHSchoolGenericBlock)();

@interface HHSchoolPriceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) NSMutableArray *viewArray;

@property (nonatomic, strong) HHSchoolPriceBlock priceBlock;
@property (nonatomic, strong) HHSchoolGenericBlock callBlock;
@property (nonatomic, strong) HHSchoolGenericBlock notifPriceBlock;

- (void)setupCellWithSchool:(HHDrivingSchool *)school;

@end
