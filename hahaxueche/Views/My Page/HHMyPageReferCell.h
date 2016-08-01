//
//  HHMyPageReferCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHReferCellBlock)();

@interface HHMyPageReferCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end
