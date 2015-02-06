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

typedef void (^HVErrorBlock)(NSError *error);

@interface SendTweetVC ()
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

@end
