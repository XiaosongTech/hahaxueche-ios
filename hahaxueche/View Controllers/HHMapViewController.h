//
//  HHMapViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/23/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHMapViewCompletion)();

@interface HHMapViewController : UIViewController

@property (nonatomic, strong) HHMapViewCompletion selectedCompletion;

@end
