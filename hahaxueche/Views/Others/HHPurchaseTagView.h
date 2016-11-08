//
//  HHPurchaseTagView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 13/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHPurchaseTagBlock)(NSInteger selectedIndex);

@interface HHPurchaseTagView : UIView

- (instancetype)initWithTags:(NSArray *)tags title:(NSString *)title defaultTag:(NSString *)defaultTag;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) HHPurchaseTagBlock tagAction;


@end
