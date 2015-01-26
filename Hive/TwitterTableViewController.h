//
//  TwitterTableViewController.h
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACAccount;

@interface TwitterTableViewController : UIViewController
@property (nonatomic, strong) ACAccount *currentAccount;
- (void) loadData;
@end
