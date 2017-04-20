//
//  HHAnnotationView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 18/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HHCalloutView.h"
#import "HHField.h"
#import "HHGradientButton.h"
#import "DXAnnotationView.h"
#import "DXAnnotationSettings.h"

typedef void (^HHPinCompletion)(HHField *field);

@interface HHAnnotationView : DXAnnotationView

@property (nonatomic, strong) HHCalloutView *calloutView;
@property (nonatomic, strong) UIImageView *pinView;

@property (nonatomic, strong) HHPinCompletion pinCompletion;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier pinView:(UIView *)pinView calloutView:(UIView *)calloutView selected:(BOOL)selected;


@end
