//
//  ContainerViewController.h
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACAccount;

@interface ContainerViewController : UIViewController
@property (nonatomic, strong) ACAccount *currentAccount;
@end
