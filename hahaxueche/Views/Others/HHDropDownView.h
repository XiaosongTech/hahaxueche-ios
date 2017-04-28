//
//  HHDropDownView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 28/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHDropDownView : UIView

- (instancetype)initWithColumnCount:(NSInteger)count data:(NSArray *)data selectedIndexes:(NSArray *)selectedIndexes;

@property (nonatomic, strong) UIScrollView *scrollViewOne;
@property (nonatomic, strong) UIScrollView *scrollViewTwo;

@property (nonatomic, strong) NSArray *selectedIndexes;

@end
