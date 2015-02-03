//
//  HVImageBank.h
//  Hive
//
//  Created by Yury Nechaev on 03.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HVImageBankOperation.h"

@interface HVImageBank : NSObject

- (void) loadImageWithURL:(NSURL *)url
               completion:(HVImageCompletionBlock)completion;

+ (instancetype)  sharedInstance;
@end
