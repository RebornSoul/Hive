//
//  SendTweetVC.h
//  Hive
//
//  Created by Yury Nechaev on 06.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet, ACAccount;

@interface SendTweetVC : UIViewController
@property (nonatomic, strong) ACAccount *currentAccount;
@property (nonatomic, strong) Tweet *replyToTweet;
@end
