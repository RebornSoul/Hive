//
//  AccountManager.h
//  Hive
//
//  Created by Yury Nechaev on 20.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

+ (void) getListOfAccountsWithCompletion:(void(^)(NSArray *accounts))completion
                                 failure:(void(^)(NSError *error))failure;

@end
