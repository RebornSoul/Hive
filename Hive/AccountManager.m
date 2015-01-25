//
//  AccountManager.m
//  Hive
//
//  Created by Yury Nechaev on 20.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "AccountManager.h"
#import <Accounts/Accounts.h>

@implementation AccountManager

+ (void) getListOfAccountsWithCompletion:(void(^)(NSArray *accounts))completion failure:(void(^)(NSError *error))failure
{
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error)
     {
         if (granted) {
             if (completion) completion ([accountStore accountsWithAccountType:accountType]);
         } else {
             if (failure) failure (error);
         }
     }];
}

@end
