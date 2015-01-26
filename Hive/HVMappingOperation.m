//
//  HVMappingOperation.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVMappingOperation.h"

@interface HVMappingOperation ()
@property (nonatomic, strong) NSError *error;
@end

@implementation HVMappingOperation

- (void) start {
    // magic!
}

- (BOOL)performMappingWithError:(NSError **)error
{
    [self start];
    if (error) *error = self.error;
    return self.error == nil;
}

@end
