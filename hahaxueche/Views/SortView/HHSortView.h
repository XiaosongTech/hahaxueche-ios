//
//  HHSortView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/15/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHSortOptionView.h"

typedef NS_ENUM(NSInteger, SortOption) {
    SortOptionSmartSort,
    SortOptionDistance,
    SortOptionReview,
    SortOptionPrice,
    SortOptionPopularity,
    SortOptionCount,
};

typedef void (^HHSelectedSortOptionCompletion)(SortOption sortOption);

@interface HHSortView : UIView

@property (nonatomic) SortOption currentSortOption;
@property (nonatomic, strong) NSMutableArray *sortOptions;
@property (nonatomic, strong) HHSelectedSortOptionCompletion selectedOptionBlock;

- (instancetype)initWithDefaultSortOption:(SortOption)sortOption;
- (NSString *)getSortNameWithSortOption:(SortOption)option;

@end
