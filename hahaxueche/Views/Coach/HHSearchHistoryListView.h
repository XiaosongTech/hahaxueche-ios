//
//  HHSearchHistoryListView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHKeywordTappedBlock)(NSString *keyword);

@interface HHSearchHistoryListView : UIView

@property (nonatomic, strong) NSArray *searchHistory;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) HHKeywordTappedBlock keywordBlock;
@property (nonatomic, strong) UIButton *clearButton;

- (instancetype)initWithHistory:(NSArray *)searchHistory;

@end
