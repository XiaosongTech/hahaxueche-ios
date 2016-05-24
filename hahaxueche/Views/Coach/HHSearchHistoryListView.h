//
//  HHSearchHistoryListView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSearchHistoryListView : UIView

@property (nonatomic, strong) NSArray *searchHistory;
@property (nonatomic, strong) NSMutableArray *views;

- (instancetype)initWithHistory:(NSArray *)searchHistory;

@end
