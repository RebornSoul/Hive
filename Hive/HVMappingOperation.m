//
//  HVMappingOperation.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "HVMappingOperation.h"
#import "HVRelationshipMapping.h"
#import "HVObjectMapping.h"

NSString * const HVMappingErrorDomain   = @"com.Hive.mapping";


NS_ENUM(NSUInteger, kHVMapperErrorCode) {
    kHVMapperErrorCodeDestinationEmpty = 1101
};

@interface HVMappingOperation ()
@property (nonatomic, strong) NSError *error;
@end

@implementation HVMappingOperation

- (void) start {
    // magic!
    if (!_destinationObject) {
        _destinationObject = [self destinationObjectForMapping:self.objectMapping relationshipMapping:nil];
    }
    if (!_destinationObject) {
        NSError *error = [[NSError alloc] initWithDomain:HVMappingErrorDomain code:kHVMapperErrorCodeDestinationEmpty userInfo:@{}];
        [self reportError:error];
    }
}

- (void) reportError:(NSError *)error {
    if ([self.mappingDelegate respondsToSelector:@selector(mappingOperationDidFailWithError:)]) {
        [self.mappingDelegate mappingOperationDidFailWithError:error];
    }
}

- (id) destinationObjectForMapping:(HVObjectMapping *)mapping relationshipMapping:(HVRelationshipMapping *)relationshipMapping {
    id destinationObject = [mapping.targetClass new];
    return destinationObject;
}

- (BOOL)performMappingWithError:(NSError **)error
{
    [self start];
    if (error) *error = self.error;
    return self.error == nil;
}

@end
