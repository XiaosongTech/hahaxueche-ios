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

- (void)testUploadAvatarImage {
    
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing upload user avatar works"];
    [[HHStudentService sharedInstance] uploadStudentAvatarWithImage:[UIImage imageNamed:@"ic_coach_ava"] completion:^(HHStudent *student, NSError *error) {
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

@end
