//
//  HHFiltersView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 27/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHFilters.h"
#import "HHFilterItemView.h"

typedef void (^HHFilterItemBlock)(HHFilterItemView *itemView);

@interface HHFiltersView : UIView

- (instancetype)initWithFilter:(HHFilters *)filters;

@property (nonatomic, strong) HHFilters *filters;
@property (nonatomic, strong) HHFilterItemBlock itemBlock;


@property (nonatomic, strong) NSMutableArray *itemArray;

@end
