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
@property (nonatomic, strong) NSString *rootPath;
@property (nonatomic, strong) NSArray *mappingStack;
@end

@implementation HVMappingRoute

- (id) initWithTargetClass:(Class)aClass rootPath:(NSString *)rootPath {
    self = [super init];
    if (self) {
        self.targetClass = aClass;
        self.rootPath = rootPath;
        self.mappingStack = [NSArray new];
    }
    return self;
}

+ (instancetype) routeForClass:(Class)aClass rootPath:(NSString *)rootPath {
    return [[HVMappingRoute alloc] initWithTargetClass:aClass rootPath:rootPath];
}

- (void) addObjectMapping:(HVObjectMapping *)objectMapping {
    NSMutableArray *mutableCopy = [self.mappingStack mutableCopy];
    [mutableCopy addObject:objectMapping];
    self.mappingStack = [NSArray arrayWithArray:mutableCopy];
}

@end
