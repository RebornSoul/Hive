//
//  Media.h
//  Hive
//
//  Created by Yury Nechaev on 06.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *mediaUrl;
@property (nonatomic, strong) NSString *displayUrl;
@end
