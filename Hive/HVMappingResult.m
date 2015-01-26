//
//  HVMappingResult.m
//  Hive
//
//  Created by Yury Nechaev on 27.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVMappingResult.h"

@interface HVMappingResult ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation HVMappingResult

- (id) initWithCollection:(NSArray *)collection {
    self = [super init];
    if (self) {
        NSAssert(collection, @"Collection can not be nil!");
        self.data = collection;
    }
    return self;
}

- (id) firstObject {
    return [self.data firstObject];
}

- (id) anyObject {
    NSUInteger randomIndex = arc4random() % [self.data count];
    return [self.data objectAtIndex:randomIndex];
}

- (NSArray *)array {
    return [self.data copy];
}

- (NSInteger)count {
    return [self.data count];
}

@end
