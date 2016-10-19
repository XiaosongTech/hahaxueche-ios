//
//  HHPersonalCoachSortView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 19/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPersonalCoachSortView.h"
#import "HHSortOptionView.h"

@implementation HHPersonalCoachSortView

- (instancetype)initWithDefaultSortOption:(PersonalCoachSortOption)sortOption {
    self = [super init];
    if (self) {
        self.currentSortOption = sortOption;
        self.backgroundColor = [UIColor whiteColor];
        self.sortOptions = [NSMutableArray array];
        
        for (int i = PersonalCoachSortOptionPrice; i < PersonalCoachSortOptionCount; i++) {
            HHSortOptionView *item = nil;
            switch (i) {
                case PersonalCoachSortOptionPrice: {
                    item = [[HHSortOptionView alloc] initWithTilte:@"价格最低" image:[UIImage imageNamed:@"ic_sort_price_normal_btn"] highlightImage:[UIImage imageNamed:@"ic_sort_price_hold_btn"]];
                    if (self.currentSortOption == PersonalCoachSortOptionPrice) {
                        [item setupView:YES];
                    } else {
                        [item setupView:NO];
                    }
                    
                } break;
                    
                case PersonalCoachSortOptionPopularity: {
                    item = [[HHSortOptionView alloc] initWithTilte:@"点赞最多" image:[UIImage imageNamed:@"ic_sort_zan_normal_btn"] highlightImage:[UIImage imageNamed:@"ic_sort_zan_hold_btn"]];
                    if (self.currentSortOption == PersonalCoachSortOptionPopularity) {
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
    for (int i = PersonalCoachSortOptionPrice; i < PersonalCoachSortOptionCount; i++) {
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
