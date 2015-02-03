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
#import "HVImageBank.h"

#define USE_SIZE_CACHE 1
#define USE_ATTRIBUTED_TEXT_CACHE 1

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

#if USE_SIZE_CACHE
@property (nonatomic, strong) NSMutableDictionary *sizeCache;
#endif

#if USE_ATTRIBUTED_TEXT_CACHE
@property (nonatomic, strong) NSMutableDictionary *usernameCache;
@property (nonatomic, strong) NSMutableDictionary *tweetTextCache;
#endif

@end

@implementation TwitterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if USE_SIZE_CACHE
    self.sizeCache = [NSMutableDictionary new];
#endif
    
#if USE_ATTRIBUTED_TEXT_CACHE
    self.usernameCache = [NSMutableDictionary new];
    self.tweetTextCache = [NSMutableDictionary new];
#endif
    
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

- (NSAttributedString *)userNameStringFromNode:(HVDataNode *)node {
#if USE_ATTRIBUTED_TEXT_CACHE
    NSAttributedString *cachedName = self.usernameCache[node.tweet.user.idStr];
    if (cachedName) {
        return cachedName;
    }
#endif
    NSAttributedString *calculatedString = [TweetCell usernameStringFromUser:node.tweet.user];
#if USE_ATTRIBUTED_TEXT_CACHE
    self.usernameCache[node.tweet.user.idStr] = calculatedString;
#endif
    return calculatedString;
}

- (NSAttributedString *)tweetStringFromNode:(HVDataNode *)node {
#if USE_ATTRIBUTED_TEXT_CACHE
    NSAttributedString *cachedTweet = self.tweetTextCache[node.tweet.idStr];
    if (cachedTweet) {
        return cachedTweet;
    }
#endif
    NSAttributedString *calculatedString = [TweetCell tweetTextFromTweet:node.tweet];
#if USE_ATTRIBUTED_TEXT_CACHE
    self.tweetTextCache[node.tweet.idStr] = calculatedString;
#endif
    return calculatedString;
}

- (void) setupDataProvider {
    self.dataArray = [NSArray new];
    
    __weak __typeof(self) weakSelf = self;
    
    self.configureCellBlock = ^(UITableViewCell *cell, HVDataNode *node, NSIndexPath *indexPath) {
        switch (node.nodeType) {
            case kTweetTableCellTypeNormal:
            {
                TweetCell *tweetCell = (TweetCell *)cell;
                tweetCell.tweetTextView.attributedText = [weakSelf tweetStringFromNode:node];
                tweetCell.usernameLabel.attributedText = [weakSelf userNameStringFromNode:node];
                [[HVImageBank sharedInstance]
                                      loadImageWithURL:[NSURL URLWithString:node.tweet.user.profileImageUrl]
                                      completion:^(UIImage *image, NSError *error) {
                                          tweetCell.userpicImageView.image = image;
                }];
            }
                break;
            
            default:
                break;
        }
    };
    
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
    HVDataNode *node = self.dataArray[indexPath.row];

#if USE_SIZE_CACHE
    NSNumber *cachedHeight = self.sizeCache[node.tweet.idStr];
    
    if (cachedHeight != nil) {
        return [cachedHeight floatValue];
    }
#endif
    
    CGFloat calculatedHeight = [TweetCell heightForTweet:node.tweet constrainedToWidth:CGRectGetWidth(tableView.bounds)];
    
#if USE_SIZE_CACHE
    self.sizeCache[node.tweet.idStr] = @(calculatedHeight);
#endif
    
    return calculatedHeight;
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
