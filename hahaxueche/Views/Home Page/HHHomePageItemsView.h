//
//  HHHomePageItemsView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 28/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ItemType) {
    ItemTypeGroupPurchase,
    ItemTypeOnlineTest,
    ItemTypeCourseOne,
    ItemTypePlatformGuard,
    ItemTypeProcess,
    ItemTypeReferFriends,
    ItemTypeOnlineSupport,
    ItemTypeCallSupport,
    ItemTypeCount
};

typedef void (^HHHomePageItemsViewBlock)(ItemType index);

@interface HHHomePageItemsView : UIView

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) HHHomePageItemsViewBlock itemBlock;

@end
