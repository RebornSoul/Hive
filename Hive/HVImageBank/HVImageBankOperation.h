//
//  HVImageBankOperation.h
//  Hive
//
//  Created by Yury Nechaev on 03.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HVImageCompletionBlock)(UIImage *image, NSError *error);
typedef void (^HVImageProgressBlock)(double progress);

@interface HVImageBankOperation : NSOperation

@property (nonatomic, copy) HVImageCompletionBlock imageCompletionBlock;
@property (nonatomic, copy) HVImageProgressBlock imageProgressBlock;
@property (nonatomic, strong) NSURL *imageUrl;

+ (instancetype) operationWithImageURL:(NSURL *)url;

@end
