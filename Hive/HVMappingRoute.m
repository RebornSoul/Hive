//
//  HVMappingRoute.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVMappingRoute.h"

@interface HVMappingRoute ()

@property (nonatomic, assign) Class targetClass;
@property (nonatomic, strong) NSDictionary *routeMap;

@end

@implementation HVMappingRoute

- (id) initWithTargetClass:(Class)class routeMap:(NSDictionary *)routeMap {
    self = [super init];
    if (self) {
        self.targetClass = class;
        self.routeMap = routeMap;
    }
    return self;
}

+ (instancetype) routeForClass:(Class)class withMap:(NSDictionary *)routeMap {
    return [[HVMappingRoute alloc] initWithTargetClass:class routeMap:routeMap];
}

@end
