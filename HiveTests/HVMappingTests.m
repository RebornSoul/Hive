//
//  HVMappingTests.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HVMapperManager.h"

@interface HVMappingTests : XCTestCase
@property (nonatomic, strong) HVMapperManager *mapperManager;
@property (nonatomic, strong) id parsedJson;
@end

@implementation HVMappingTests

- (void)setUp {
    [super setUp];
    
    // Loading json from file in a bundle
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"MOCK_DATA" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.parsedJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    // Create mapper manager instance
    self.mapperManager = [HVMapperManager sharedInstance];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
