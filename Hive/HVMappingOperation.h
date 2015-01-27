//
//  HVMappingOperation.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HVObjectMapping;
@protocol HVMappingOperationDelegate;

@interface HVMappingOperation : NSOperation

@property (nonatomic, strong) HVObjectMapping *objectMapping;
@property (nonatomic, strong, readonly) id destinationObject;
@property (nonatomic, weak) id<HVMappingOperationDelegate> mappingDelegate;
@end

@protocol HVMappingOperationDelegate <NSObject>
@optional
- (HVMappingOperation *)mappingOperationDidFailWithError:(NSError *)error;
- (HVMappingOperation *)mappingOperationDidStart;
- (HVMappingOperation *)mappingOperationDidFinish;

@end