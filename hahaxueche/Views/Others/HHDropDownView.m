//
//  HHDropDownView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 28/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHDropDownView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHFilterOptionView.h"

@implementation HHDropDownView

- (instancetype)initWithColumnCount:(NSInteger)count data:(NSArray *)data selectedIndexes:(NSArray *)selectedIndexes {
    self = [super init];
    if (self) {
        self.selectedIndexes = selectedIndexes;
        if (count == 1) {
            self.scrollViewOne = [[UIScrollView alloc] init];
            self.scrollViewOne.backgroundColor = [UIColor whiteColor];
            self.scrollViewOne.showsVerticalScrollIndicator = NO;
            [self addSubview:self.scrollViewOne];
            [self.scrollViewOne makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.equalTo(self.width);
                make.height.equalTo(self.height);
            }];
            
            for (int i = 0; i < data.count; i++) {
                NSString *title = data[i];
                BOOL selected = NO;
                NSNumber *selectedIndex = [self.selectedIndexes firstObject];
                if (i == [selectedIndex integerValue]) {
                    selected = YES;
                }
                HHFilterOptionView *view = [[HHFilterOptionView alloc] initWithTitle:title selected:selected];
                [self.scrollViewOne addSubview:view];
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scrollViewOne.left);
                    make.width.equalTo(self.scrollViewOne.width);
                    make.height.mas_equalTo(40.0f);
                    make.top.equalTo(self.scrollViewOne.top).offset(i * 40.0f);
                }];
            }
            self.scrollViewOne.contentSize = CGSizeMake(CGRectGetWidth(self.scrollViewOne.frame), data.count * 40.0f);
            
            self.scrollViewTwo = [[UIScrollView alloc] init];
            self.scrollViewTwo.backgroundColor = [UIColor whiteColor];
            self.scrollViewTwo.showsVerticalScrollIndicator = NO;
            [self addSubview:self.scrollViewTwo];
            [self.scrollViewTwo makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top);
                make.left.equalTo(self.scrollViewOne.right);
                make.width.equalTo(self.width).multipliedBy(0.5f);
                make.height.equalTo(self.height);
            }];
            
        } else {
            self.scrollViewOne = [[UIScrollView alloc] init];
            self.scrollViewOne.backgroundColor = [UIColor HHLightBackgroudGray];
            self.scrollViewOne.showsVerticalScrollIndicator = NO;
            [self addSubview:self.scrollViewOne];
            [self.scrollViewOne makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top);
                make.left.equalTo(self.left);
                make.width.equalTo(self.width).multipliedBy(0.5f);
                make.height.equalTo(self.height);
            }];
            
            
            for (int i = 0; i < data.count; i++) {
                NSString *title;
                if (i == 0) {
                    NSDictionary *dic = data[i];
                    title = [[dic allKeys] firstObject];
                } else {
                    title = data[i];
                }
                BOOL selected = NO;
                NSNumber *selectedIndex = [self.selectedIndexes firstObject];
                if (i == [selectedIndex integerValue]) {
                    selected = YES;
                }
                HHFilterOptionView *view = [[HHFilterOptionView alloc] initWithTitle:title selected:selected];
                [self.scrollViewOne addSubview:view];
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scrollViewOne.left);
                    make.width.equalTo(self.scrollViewOne.width);
                    make.height.mas_equalTo(40.0f);
                    make.top.equalTo(self.scrollViewOne.top).offset(i * 40.0f);
                }];
            }
            self.scrollViewOne.contentSize = CGSizeMake(CGRectGetWidth(self.scrollViewOne.frame), data.count * 40.0f);
            
            self.scrollViewTwo = [[UIScrollView alloc] init];
            self.scrollViewTwo.backgroundColor = [UIColor whiteColor];
            self.scrollViewTwo.showsVerticalScrollIndicator = NO;
            [self addSubview:self.scrollViewTwo];
            [self.scrollViewTwo makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top);
                make.left.equalTo(self.scrollViewOne.right);
                make.width.equalTo(self.width).multipliedBy(0.5f);
                make.height.equalTo(self.height);
            }];

            NSDictionary *dic = data[0];
            NSArray *distance = dic[@"附近"];
            for (int i = 0; i < distance.count; i++) {
                NSString *title = distance[i];
                BOOL selected = NO;
                NSNumber *selectedIndex = self.selectedIndexes[1];
                if (i == [selectedIndex integerValue]) {
                    selected = YES;
                }
                HHFilterOptionView *view = [[HHFilterOptionView alloc] initWithTitle:title selected:selected];
                [self.scrollViewTwo addSubview:view];
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scrollViewTwo.left);
                    make.width.equalTo(self.scrollViewTwo.width);
                    make.height.mas_equalTo(40.0f);
                    make.top.equalTo(self.scrollViewTwo.top).offset(i * 40.0f);
                }];
            }
            self.scrollViewTwo.contentSize = CGSizeMake(CGRectGetWidth(self.scrollViewTwo.frame), distance.count * 40.0f);
        }
    }
    return self;
}



@end
