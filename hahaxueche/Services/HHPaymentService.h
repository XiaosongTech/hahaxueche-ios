//
//  HHPaymentService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pingpp/Pingpp.h>

typedef void (^HHPaymentResultCompletion)(BOOL succeed);

@interface HHPaymentService : NSObject

+ (instancetype)sharedInstance;


- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion;

@end
