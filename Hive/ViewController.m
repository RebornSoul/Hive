//
//  ViewController.m
//  Hive
//
//  Created by Yury Nechaev on 20.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import "AccountManager.h"
#import "AccountCell.h"

#define kCellId @"AccountCell"
#define kDefCellHeight 44.0f

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UIView *progressView;
@property (nonatomic, weak) IBOutlet UIView *logoView;
@property (nonatomic, strong) NSArray *fetchedAccounts;
@property (nonatomic, weak) IBOutlet UITableView *accountsTable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAccounts];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) requestAccounts {
    
    [AccountManager getListOfAccountsWithCompletion:^(NSArray *accounts) {
        if (accounts.count) {
            self.fetchedAccounts = accounts;
            [self.accountsTable reloadData];
        }
    } failure:^(NSError *error) {
        [self presentError:error];
    }];
}

- (void) presentError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accounts table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedAccounts count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountCell *cell = (AccountCell *)[self.accountsTable dequeueReusableCellWithIdentifier:kCellId];
    ACAccount *account = [self.fetchedAccounts objectAtIndex:indexPath.row];
    cell.accountNameLabel.text = account.username;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefCellHeight;
}

@end
