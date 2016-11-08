//
//  HHPersonalCoachSortView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 19/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonalCoachSortOption) {
    PersonalCoachSortOptionPrice,
    PersonalCoachSortOptionPopularity,
    PersonalCoachSortOptionCount,
};

typedef void (^HHSelectedPersonalCoachSortOptionCompletion)(PersonalCoachSortOption sortOption);

@interface HHPersonalCoachSortView : UIView

@property (nonatomic) PersonalCoachSortOption currentSortOption;
@property (nonatomic, strong) NSMutableArray *sortOptions;
@property (nonatomic, strong) HHSelectedPersonalCoachSortOptionCompletion selectedOptionBlock;

- (instancetype)initWithDefaultSortOption:(PersonalCoachSortOption)sortOption;
- (NSString *)getSortNameWithSortOption:(PersonalCoachSortOption)option;

@end
