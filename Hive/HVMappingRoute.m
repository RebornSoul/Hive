//
//  HVMappingRoute.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVMappingRoute.h"

@interface HVMappingRoute ()


@end

@implementation HVMappingRoute

- (id) initWithTargetClass:(Class)aClass rootPath:(NSString *)rootPath {
    self = [super init];
    if (self) {
        _targetClass = aClass;
        _rootPath = rootPath;
        _mappingStack = [NSArray new];
    }
    return self;
}

+ (instancetype) routeForClass:(Class)aClass rootPath:(NSString *)rootPath {
    return [[HVMappingRoute alloc] initWithTargetClass:aClass rootPath:rootPath];
}

- (void) addObjectMapping:(HVObjectMapping *)objectMapping {
    NSMutableArray *mutableCopy = [self.mappingStack mutableCopy];
    [mutableCopy addObject:objectMapping];
    _mappingStack = [NSArray arrayWithArray:mutableCopy];
}

@end
