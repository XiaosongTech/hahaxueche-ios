//
//  HHPointAnnotation.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface HHPointAnnotation : MKPointAnnotation

@property (nonatomic) NSInteger tag;

- (instancetype)initWithTag:(NSInteger)tag;

@end
