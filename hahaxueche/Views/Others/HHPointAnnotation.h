//
//  HHPointAnnotation.h
//  hahaxueche
//
//  Created by Zixiao Wang on 17/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "HHField.h"

@interface HHPointAnnotation : MKPointAnnotation

@property(nonatomic, strong) HHField *field;

- (instancetype)initWithField:(HHField *)field;

@end
