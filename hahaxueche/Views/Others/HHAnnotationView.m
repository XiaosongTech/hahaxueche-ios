//
//  HHAnnotationView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 18/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHAnnotationView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHPointAnnotation.h"

@implementation HHAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier pinView:(UIView *)pinView calloutView:(UIView *)calloutView selected:(BOOL)selected {
    DXAnnotationSettings *setting = [DXAnnotationSettings defaultSettings];
    setting.calloutBorderColor = [UIColor HHOrange];
    setting.calloutBorderWidth = 1.0f;
    
    
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier pinView:pinView calloutView:calloutView settings:setting];
    if (self) {
        self.pinView = (UIImageView *)pinView;
        self.pinView.userInteractionEnabled = YES;
        
        self.calloutView = (HHCalloutView *)calloutView;
        self.calloutView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinTapped)];
        [self.pinView addGestureRecognizer:rec];
        
        UITapGestureRecognizer *rec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutTapped)];
        [self.calloutView addGestureRecognizer:rec2];
        
        if (selected) {
            [self pinTapped];
        }
    }
    return self;
}

- (void)pinTapped {
    HHPointAnnotation *annotation = (HHPointAnnotation *)self.annotation;
    self.pinView.image = [UIImage imageNamed:@"ic_map_local_choseon"];
    [self showCalloutView];
    if (self.pinCompletion) {
        self.pinCompletion(annotation.field);
    }
    
}

- (void)calloutTapped {
    [self hideCalloutView];
}




@end
