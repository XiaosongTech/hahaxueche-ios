//
//  HHHomePageGuideView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 15/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CardItemCompletion)(NSInteger index);

@interface HHHomePageGuideView : UIView

@property (nonatomic, strong) CardItemCompletion itemAction;

@end
