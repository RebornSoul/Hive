//
//  ContainerViewController.m
//  Hive
//
//  Created by Yury Nechaev on 26.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "ContainerViewController.h"
#import "TwitterTableViewController.h"

@interface ContainerViewController ()
@property (nonatomic, weak) IBOutlet UIView *containerView;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"container_table"]) {
        TwitterTableViewController *twitterTableVC = [segue destinationViewController];
        twitterTableVC.currentAccount = self.currentAccount;
        [twitterTableVC loadData];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
