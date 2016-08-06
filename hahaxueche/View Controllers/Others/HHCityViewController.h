//
//  HHCityViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCityVCBlock)(NSString *city);

@interface HHCityViewController : UIViewController

- (instancetype)initWithPopularCities:(NSArray *)popularCities allCities:(NSArray *)allCities selectedCity:(NSString *)selectedCity;

@property (nonatomic, strong) HHCityVCBlock block;

@end
