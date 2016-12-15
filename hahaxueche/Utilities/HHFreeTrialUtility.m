//
//  HHFreeTrialUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHFreeTrialUtility.h"
#import "HHStudentStore.h"

@implementation HHFreeTrialUtility

+ (HHFreeTrialUtility *)sharedManager {
    static HHFreeTrialUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHFreeTrialUtility alloc] init];
    });
    
    return manager;
}

- (NSString *)buildFreeTrialURLStringWithCoachId:(NSString *)coachId {
    NSString *urlBase;
    
#ifdef DEBUG
    urlBase = @"https://staging-m.hahaxueche.com/free_trial?promo_code=553353";
#else
    urlBase = @"https://m.hahaxueche.com/free_trial?promo_code=553353";
#endif
    
    HHStudent *student = [HHStudentStore sharedInstance].currentStudent;
    NSString *paramString;
    if(student.studentId && coachId) {
        paramString = [NSString stringWithFormat:@"&coach_id=%@&name=%@&phone=%@&city_id=%@", coachId, student.name, student.cellPhone, [student.cityId stringValue]];
    } else if (student.studentId) {
        paramString = [NSString stringWithFormat:@"&name=%@&phone=%@&city_id=%@", student.name, student.cellPhone, [student.cityId stringValue]];
    } else if (coachId) {
        paramString = [NSString stringWithFormat:@"&coach_id=%@&city_id=%@", coachId, [student.cityId stringValue]];
    } else {
        paramString = [NSString stringWithFormat:@"&city_id=%@", [student.cityId stringValue]];
    }
    
    return [NSString stringWithFormat:@"%@%@", urlBase, paramString];
}


@end
