//
//  TweetCell.h
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet, User;

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *subbgView;

@property (nonatomic, weak) IBOutlet UIImageView *userpicImageView;
@property (nonatomic, weak) IBOutlet UITextView *tweetTextView;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timestampLabel;
@property (nonatomic, weak) IBOutlet UIImageView *dateRibbonImage;
@property (nonatomic, weak) IBOutlet UIImageView *tweetImageView;

@property (nonatomic, weak) IBOutlet UIButton *answerButton;
@property (nonatomic, weak) IBOutlet UIButton *favButton;
@property (nonatomic, weak) IBOutlet UIButton *repostButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageContainerHeightConstraint;

+ (CGFloat) heightForTweet:(Tweet *)tweet constrainedToWidth:(CGFloat)width;
+ (CGFloat) defaultImageHeight;
+ (CGFloat) defaultMinimumImagecontainerHeight;

+ (NSAttributedString *) usernameStringFromUser:(User *)user;
+ (NSAttributedString *) tweetTextFromTweet:(Tweet *)tweet;

+ (CATransform3D) initialTransform;
@end
