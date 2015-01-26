//
//  HVMapperManager.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVMapperManager.h"

static HVMapperManager *instanceMapperManager = nil;

@interface HVMapperManager ()
@property (nonatomic, strong) NSArray *mappingRoutes;
@property (nonatomic, strong) NSOperationQueue *mappingOperationQueue;
@end

@implementation HVMapperManager

+ (HVMapperManager *)  sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceMapperManager = [[HVMapperManager alloc] init];
    });
    return instanceMapperManager;
}

@end
