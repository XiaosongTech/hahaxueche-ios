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


@interface HHAnnotationView : MKAnnotationView

@property (nonatomic, strong) HHCalloutView *calloutView;
@end
