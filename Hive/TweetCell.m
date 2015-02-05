//
//  TweetCell.m
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"

const CGFloat HVTweetCellTweetFontSize = 14.0f;
const CGFloat HVTweetCellUsernameFontSize = 14.0f;
const CGFloat HVTweetCellTimestampFontSize = 12.0f;
const CGFloat HVTweetCellPadding = 10.0f;
const CGFloat HVTweetCellAvatarWidth = 40.0f;
const CGFloat HVTweetCellAvatarHeight = 40.0f;
const CGFloat HVTweetCellControlPanelHeight = 30.0f;

@implementation TweetCell

+ (CGFloat) heightForTweet:(Tweet *)tweet constrainedToWidth:(CGFloat)width {
    CGFloat textViewWidth = width - HVTweetCellPadding - HVTweetCellAvatarWidth - HVTweetCellPadding;
    
    CGFloat calculatedHeight = HVTweetCellPadding +
    [[self class] heightForUsernameFromTweet:tweet constrainedToWidth:textViewWidth] +
    [[self class] heightForTextFromTweet:tweet constrainedToWidth:textViewWidth] +
    [[self class] heightForControlPanel] +
    HVTweetCellPadding;
    
    return MAX([[self class] minimumHeightShowingImage:tweet.imageUrl], calculatedHeight);
}

+ (CGFloat) heightForTextFromTweet:(Tweet *)tweet constrainedToWidth:(CGFloat)width {
    return [[self class] heightForAttributedText:[[self class] tweetTextFromTweet:tweet]
                              constrainedToWidth: width];
}

+ (CGFloat) heightForUsernameFromTweet:(Tweet *)tweet constrainedToWidth:(CGFloat)width {
    return [[self class] heightForAttributedText:[[self class] usernameStringFromUser:tweet.user]
                              constrainedToWidth: width];
}

+ (CGFloat) heightForControlPanel {
    return HVTweetCellControlPanelHeight;
}



+ (CGFloat) minimumHeightShowingImage:(BOOL)hasImage {
    if (hasImage) {
        return 120.0f;
    } else {
        return HVTweetCellPadding + HVTweetCellControlPanelHeight + HVTweetCellPadding;
    }
}

+ (CGFloat) heightForAttributedText:(NSAttributedString *)attributedText constrainedToWidth:(CGFloat)width {
    CGRect boundingRect = [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return ceil(boundingRect.size.height);
}

+ (CGFloat) heightForText:(NSString *)text withFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:font ,NSFontAttributeName, nil] context:nil];
    return ceil(boundingRect.size.height);
}

- (void)awakeFromNib {
    self.tweetTextView.textContainerInset = UIEdgeInsetsZero;
    self.tweetTextView.textContainer.lineFragmentPadding = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - fonts

+ (UIFont *)usernameFont {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size: HVTweetCellUsernameFontSize];
}

+ (UIFont *)screenNameFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size: HVTweetCellUsernameFontSize];
}

+ (UIFont *)tweetFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size: HVTweetCellTweetFontSize];
}

#pragma mark - fabrics

+ (NSAttributedString *) usernameStringFromUser:(User *)user {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:user.name attributes:@{NSFontAttributeName:[[self class] usernameFont]}];
    NSString *screenName = [NSString stringWithFormat:@" @%@", user.screenName];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:screenName attributes:@{NSFontAttributeName:[[self class] screenNameFont]}]];
    return attrString;
}

+ (NSAttributedString *) tweetTextFromTweet:(Tweet *)tweet {
    return [[NSAttributedString alloc] initWithString:tweet.text
                                           attributes:@{NSFontAttributeName:[[self class] tweetFont]}];
}

#pragma mark - animation choreographics

+ (CATransform3D) initialTransform {
    CGFloat rotationAngleDegrees = 15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-30, 50);
    CATransform3D transform = CATransform3DIdentity;

    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    return transform;
}

@end
