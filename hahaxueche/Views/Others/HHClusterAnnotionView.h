//
//  HHClusterAnnotionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 17/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef void (^HHClusterViewTapBlock)();

@interface HHClusterAnnotionView : MKAnnotationView

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *zoneLabel;
@property (nonatomic, strong) HHClusterViewTapBlock tapBlock;

@end
