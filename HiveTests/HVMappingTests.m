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

#define ASYNC_TIMEOUT_SEC 5

@interface HVMockObject : NSObject
@property (nonatomic, strong) NSString *idString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, strong) NSString *descriptionText;
@end

@implementation HVMockObject
@end

@interface HVMappingTests : XCTestCase
@property (nonatomic, strong) HVMapperManager *mapperManager;
@property (nonatomic, strong) id parsedJson;
@property (nonatomic, strong) HVMappingRoute *mappingRoute;
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
    
    // Create mapping mock
    HVObjectMapping *mapping = [[HVObjectMapping alloc] initWithTargetClass:[HVMockObject class]];
    [mapping addAttributedMappingFromDictionary:@{
                                                  @"id":@"idString",
                                                  @"first_name":@"name",
                                                  @"last_name":@"lastName",
                                                  @"email":@"email",
                                                  @"country":@"country",
                                                  @"created_date":@"createdDate",
                                                  @"verified":@"verified",
                                                  @"description":@"descriptionText"
                                                  }];
    HVMappingRoute *route = [HVMappingRoute routeForClass:[HVMockObject class] rootPath:nil];
    [route addObjectMapping:mapping];
    self.mappingRoute = route;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTestExpectation *expectation = [self expectationWithDescription:@"Mapping operation"];
    [self waitForExpectationsWithTimeout:ASYNC_TIMEOUT_SEC handler:^(NSError *error) {
        [self.mapperManager performMappingWithRoute:self.mappingRoute forData:self.parsedJson withCompletion:^(HVMappingResult *result) {
            [expectation fulfill];
        } failure:^(NSError *error) {
            XCTFail(@"Fail");
        }];
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
