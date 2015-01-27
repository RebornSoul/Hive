//
//  TwitterTableViewController.m
//  Hive
//
//  Created by Yury Nechaev on 25.01.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "TwitterTableViewController.h"
#import "DataManager.h"
#import "DumpMapper.h"
#import "Tweet.h"
#import "User.h"
#import "TweetCell.h"

typedef NS_ENUM(NSUInteger, kTweetTableCellType) {
    kTweetTableCellTypeNormal = 1,
    kTweetTableCellTypeLoader = 2,
    kTweetTableCellTypeSurvey = 3,
    kTweetTableCellTypeMore   = 4
};

NSString * const HVTweetCellIdentifier  = @"TweetCell";
NSString * const HVMoreCellIdentifier   = @"MoreCell";
NSString * const HVLoaderCellIdentifier = @"LoaderCell";
NSString * const HVSurveyCellIdentifier = @"SurveyCell";

@interface HVDataNode : NSObject
@property (nonatomic, strong) NSDictionary *metaData;
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) kTweetTableCellType nodeType;
@end

@implementation HVDataNode
@end

typedef void (^HVConfigureCellBlock)(UITableViewCell *cell, HVDataNode *dataNode, NSIndexPath *indexPath);
typedef void (^HVNewDataBlock)(NSData *responseData);
typedef void (^HVErrorBlock)(NSError *error);

@interface TwitterTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) HVConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) HVNewDataBlock newDataReceivedBlock;
@property (nonatomic, copy) HVErrorBlock errorBlock;

@end

@implementation TwitterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void) loadData {
    [self setupDataProvider];
    [self restorePreviousState];
    [self fetchRemoteData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In this method we try to restore previous data set and scroll position
- (void)restorePreviousState {
    
}

// In this method we construct data request and wait for response
- (void)fetchRemoteData {
    [DataManager retrieveAccountFeed:self.currentAccount withCompletion:^(NSData *responseData) {
        self.newDataReceivedBlock (responseData);
    } failure:^(NSError *error) {
        self.errorBlock (error);
    }];
}

- (void) setupDataProvider {
    self.dataArray = [NSArray new];
    self.configureCellBlock = ^(UITableViewCell *cell, HVDataNode *node, NSIndexPath *indexPath) {
        switch (node.nodeType) {
            case kTweetTableCellTypeNormal:
            {
                TweetCell *tweetCell = (TweetCell *)cell;
                [tweetCell.tweetTextView setText:node.tweet.text];
                [tweetCell.usernameLabel setText:[NSString stringWithFormat:@"%@ %@", node.tweet.user.name, node.tweet.user.screenName]];
            }
                break;
            
            default:
                break;
        }
    };
    __weak __typeof(self) weakSelf = self;
    
    self.newDataReceivedBlock = ^(NSData *responseData) {
        
        [DumpMapper performFeedMappingWithData:responseData withCompletion:^(NSArray *result) {
            weakSelf.dataArray = [weakSelf nodeArrayFromParsedData:result];
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            weakSelf.errorBlock (error);
        }];
    };
    self.errorBlock = ^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
    };
}

- (NSArray *) nodeArrayFromParsedData:(NSArray *)parsedData {
    NSMutableArray *returnedArray = [NSMutableArray new];
    for (Tweet *tw in parsedData) {
        HVDataNode *node = [HVDataNode new];
        node.tweet = tw;
        node.nodeType = kTweetTableCellTypeNormal;
        [returnedArray addObject:node];
    }
    return [NSArray arrayWithArray:returnedArray];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HVDataNode *node = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForCellType:node.nodeType]];
    self.configureCellBlock (cell, node, indexPath);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

#pragma mark - custom methods

- (NSString *)cellIdentifierForCellType:(kTweetTableCellType)cellType {
    switch (cellType) {
        case kTweetTableCellTypeMore:
            return HVMoreCellIdentifier;
            break;
        case kTweetTableCellTypeLoader:
            return HVLoaderCellIdentifier;
            break;
        case kTweetTableCellTypeNormal:
            return HVTweetCellIdentifier;
            break;
        case kTweetTableCellTypeSurvey:
            return HVSurveyCellIdentifier;
            break;
        default:
            break;
    }
}

@end
