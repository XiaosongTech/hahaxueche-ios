//
//  HHSortView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/15/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSortView.h"


@implementation HHSortView

- (instancetype)initWithDefaultSortOption:(SortOption)sortOption {
    self = [super init];
    if (self) {
        self.currentSortOption = sortOption;
        self.backgroundColor = [UIColor whiteColor];
        self.sortOptions = [NSMutableArray array];
        
        for (int i = SortOptionSmartSort; i < SortOptionCount; i++) {
            HHSortOptionView *item = nil;
            switch (i) {
                case SortOptionSmartSort: {
                    item = [[HHSortOptionView alloc] initWithTilte:@"智能排序" image:[UIImage imageNamed:@"ic_sort_auto_normal_btn"] highlightImage:[UIImage imageNamed:@"ic_sort_auto_hold_btn"]];
                    if (self.currentSortOption == SortOptionSmartSort) {
                        [item setupView:YES];
                    } else {
                        [item setupView:NO];
                    }
                } break;
                
                case SortOptionDistance: {
                    item = [[HHSortOptionView alloc] initWithTilte:@"距离最近" image:[UIImage imageNamed:@"ic_sort_local_normal_btn"] highlightImage:[UIImage imageNamed:@"ic_sort_local_hold_btn"]];
                    if (self.currentSortOption == SortOptionDistance) {
                        [item setupView:YES];
                    } else {
                        [item setupView:NO];
                    }
                } break;
                    
                case SortOptionReview: {
                    item = [[HHSortOptionView alloc] initWithTilte:@"评价最好" image:[UIImage imageNamed:@"ic_sort_nice_normal_btn"] highlightImage:[UIImage imageNamed:@"ic_sort_nice_hold_btn"]];
                    if (self.currentSortOption == SortOptionReview) {
                        [item setupView:YES];
                    } else {
                        [item setupView:NO];
                    }
                    
                } break;
                    
                case SortOptionPrice: {
                    item = [[HHSortOptionView alloc] initWithTilte:@"价格最低" image:[UIImage imageNamed:@"ic_sort_price_normal_btn"] highlightImage:[UIImage imageNamed:@"ic_sort_price_hold_btn"]];
                    if (self.currentSortOption == SortOptionPrice) {
                        [item setupView:YES];
                    } else {
                        [item setupView:NO];
                    }
                    
                } break;
                    
                case SortOptionPopularity: {
                    item = [[HHSortOptionView alloc] initWithTilte:@"人气最旺" image:[UIImage imageNamed:@"ic_sort_hot_normal_btn"] highlightImage:[UIImage imageNamed:@"ic_sort_hot_hold_btn"]];
                    if (self.currentSortOption == SortOptionPopularity) {
                        [item setupView:YES];
                    } else {
                        [item setupView:NO];
                    }
                    
                } break;
                    
                default:
                    break;
            }
            item.tag = i;
            item.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortSelected:)];
            [item addGestureRecognizer:tapRecognizer];
            [self addSubview:item];
            [self.sortOptions addObject:item];
        }
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints {
    for (int i = SortOptionSmartSort; i < SortOptionCount; i++) {
        HHSortOptionView *view  = self.sortOptions[i];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.mas_equalTo(i * 40.0f);
            make.height.mas_equalTo(40.0f);
            make.width.equalTo(self.width).offset(-30.0f);
        }];
    }
}

- (void)sortSelected:(UITapGestureRecognizer *)recognizer {
    HHSortOptionView *selectedView = (HHSortOptionView *)recognizer.view;
    for (HHSortOptionView *view in self.sortOptions) {
        if (view.tag == selectedView.tag) {
            [view setupView:YES];
        } else {
            [view setupView:NO];
        }
    }
    if (self.selectedOptionBlock) {
        self.selectedOptionBlock(selectedView.tag);
    }
}

@end
