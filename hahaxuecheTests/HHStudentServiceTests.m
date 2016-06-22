//
//  HHStudentServiceTests.m
//  hahaxueche
//
//  Created by Zixiao Wang on 6/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HHUserAuthService.h"
#import "HHStudentService.h"

@interface HHStudentServiceTests : XCTestCase

@property (nonatomic, strong) HHStudent *student;

@end

@implementation HHStudentServiceTests

- (void)setUp {
    [super setUp];
    
    // Get test account
    [HHStudentService sharedInstance];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing get test account works"];
    [[HHUserAuthService sharedInstance] loginWithCellphone:@"18506830113" password:@"111111" completion:^(HHStudent *student, NSError *error) {
        if (!error) {
            if (student) {
                self.student = student;
                [expectation fulfill];
            } else {
                XCTFail(@"Return data incorrect");
            }
        } else {
            XCTFail(@"Expectation Failed with error: %@", error);
        }

    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testFetchStudent {
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing fetch student works"];
    [[HHStudentService sharedInstance] fetchStudentWithId:self.student.studentId completion:^(HHStudent *student, NSError *error) {
        if (!error) {
            if (student) {
                [expectation fulfill];
            } else {
                XCTFail(@"Return data incorrect");
            }
        } else {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

- (void)testFetchSchedules {
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing fetch schedule works"];
    [[HHStudentService sharedInstance] fetchScheduleWithId:self.student.studentId scheduleType:@(0) completion:^(HHCoachSchedules *schedules, NSError *error) {
        if (!error) {
            if (schedules.schedules) {
                [expectation fulfill];
            } else {
                XCTFail(@"Return data incorrect");
            }
        } else {
            XCTFail(@"Expectation Failed with error: %@", error);
        }

    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

- (void)testFetchBonusSummary {
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing fetch bonnus summary works"];
    [[HHStudentService sharedInstance] fetchBonusSummaryWithCompletion:^(HHBonusSummary *bonusSummary, NSError *error) {
        if (!error) {
            if (bonusSummary) {
                [expectation fulfill];
            }
        } else {
             XCTFail(@"Return data incorrect");
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

- (void)testFetchReferrals {
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing fetch referrals works"];
    [[HHStudentService sharedInstance] fetchReferralsWithCompletion:^(HHReferrals *referralsObject, NSError *error) {
        if (!error) {
            if (referralsObject) {
                [expectation fulfill];
            }
        } else {
            XCTFail(@"Return data incorrect");
        }

    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

- (void)testFetchWithdraws {
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing fetch withdraw works"];
    [[HHStudentService sharedInstance] fetchWithdrawTransactionWithCompletion:^(HHWithdraws *withdrawsObject, NSError *error) {
        if (!error) {
            if (withdrawsObject) {
                [expectation fulfill];
            }
        } else {
            XCTFail(@"Return data incorrect");
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

@end
