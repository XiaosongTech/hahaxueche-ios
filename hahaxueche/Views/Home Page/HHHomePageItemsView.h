//
//  HHHomePageItemsView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 12/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TopItemCompletion)(NSInteger index);

@interface HHHomePageItemsView : UIView

@property (nonatomic, strong)TopItemCompletion itemAction;

@end
