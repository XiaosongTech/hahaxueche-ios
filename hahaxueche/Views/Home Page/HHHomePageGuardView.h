//
//  HHHomePageGuardView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 15/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GuardItemCompletion)(NSInteger index);

@interface HHHomePageGuardView : UIView

@property (nonatomic, strong) GuardItemCompletion itemAction;


@end
