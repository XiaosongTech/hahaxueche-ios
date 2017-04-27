//
//  HHFiltersView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 27/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHFiltersView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHFiltersView

- (instancetype)initWithFilter:(HHFilters *)filters {
    self = [super init];
    if (self) {
        self.filters = filters;
        self.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < 4; i++) {
            HHFilterItemView *item;
            if (i == 0) {
                item = [[HHFilterItemView alloc] initWithTitle:@"区域" rightLine:YES];
            } else if (i == 1) {
                item = [[HHFilterItemView alloc] initWithTitle:@"价格" rightLine:YES];
            } else if (i == 2) {
                item = [[HHFilterItemView alloc] initWithTitle:@"类别" rightLine:YES];
            } else {
                item = [[HHFilterItemView alloc] initWithTitle:@"排序" rightLine:NO];
            }
            item.tag = i;
            [self addSubview:item];
            [item makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.centerX).multipliedBy((i*2 + 1)/4.0f);
                make.width.equalTo(self.width).multipliedBy(1.0f/4.0f);
                make.height.equalTo(self.height);
                make.top.equalTo(self.top);
            }];
        }
    }
    return self;
}

@end
