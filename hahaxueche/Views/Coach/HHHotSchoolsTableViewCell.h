//
//  HHHotSchoolsTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 03/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHSchoolTappeBlock)(NSInteger index);

@interface HHHotSchoolsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *titleContainerView;
@property (nonatomic, strong) UIView *botContainerView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *hotView;;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) HHSchoolTappeBlock schoolBlock;

@end
