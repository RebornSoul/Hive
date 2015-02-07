//
//  SendTweetVC.m
//  Hive
//
//  Created by Yury Nechaev on 06.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "SendTweetVC.h"
#import "HVImageBank.h"
#import "Tweet.h"
#import "User.h"
#import "DumpMapper.h"
#import "DataManager.h"

#define MAX_CHAR_COUNT 140

typedef void (^HVErrorBlock)(NSError *error);

@interface SendTweetVC () <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) IBOutlet UIImageView *avatarView;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *screennameLabel;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIToolbar *controlsPanel;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (nonatomic, copy) HVErrorBlock errorBlock;
@property (nonatomic, strong) User *currentUser;

- (IBAction)didPressCloseButton:(id)sender;
- (IBAction)didPressSendButton:(id)sender;
@end

@implementation SendTweetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    self.errorBlock = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        });
    };
    
    if (self.replyToTweet) {
        
        __weak __typeof(self) weakSelf = self;
        
        [DataManager getCurrentUserInAccount:self.currentAccount withCompletion:^(NSData *responseData, NSHTTPURLResponse *urlResponse) {
           [DumpMapper performUserMappingWithData:responseData withCompletion:^(User *result) {
               weakSelf.currentUser = result;
               [[HVImageBank sharedInstance] loadImageWithURL:[NSURL URLWithString:weakSelf.currentUser.profileImageUrl] completion:^(UIImage *image, NSError *error) {
                   weakSelf.avatarView.image = image;
               }];
               weakSelf.usernameLabel.text = weakSelf.currentUser.name;
               weakSelf.screennameLabel.text = [NSString stringWithFormat:@"@%@", weakSelf.currentUser.screenName];

           } failure:weakSelf.errorBlock];
        } failure:self.errorBlock];
        
    }
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendStatus:(NSString *)status inReplyTo:(NSString *)replyId {
    if (status.length > MAX_CHAR_COUNT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"It seems that your tweet is longer than 140 character." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else if (status.length) {
        [DataManager postStatusUpdate:status inAccount:self.currentAccount inReplyToTweetId:replyId withCompletion:^(NSData *responseData, NSHTTPURLResponse *urlResponse) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:self.errorBlock];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didPressCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressSendButton:(id)sender {
    [self sendStatus:self.textView.text inReplyTo:self.replyToTweet ? self.replyToTweet.idStr : nil];
}

#pragma mark - TextView delegate

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = MAX_CHAR_COUNT - textView.text.length;
    NSLog(@"%li", (long)count);
    self.counterLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    if (count < 0) {
        self.counterLabel.textColor = [UIColor redColor];
    } else {
        self.counterLabel.textColor = [UIColor lightGrayColor];
    }
    
    textView.typingAttributes = @{NSForegroundColorAttributeName : count <= 0 ? [UIColor redColor] : [UIColor blackColor]};
}

#pragma mark - keyboard observers

- (void) keyboardWillShowNotification:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGRect rect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    
    NSNumber *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    float animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration delay:0.0 options:animationCurve<<16 animations:^{
        self.bottomConstraint.constant = rect.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void) keyboardWillHideNotification:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    if ([[info valueForKey:@"UIKeyboardFrameChangedByUserInteraction"] intValue] == 1) {
    }
    
    NSNumber *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    float animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:animationCurve<<16 animations:^{
        self.bottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - cleanup

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
