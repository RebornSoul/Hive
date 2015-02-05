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
#import <QuartzCore/QuartzCore.h>

#define USE_SIZE_CACHE 1
#define USE_ATTRIBUTED_TEXT_CACHE 1
#define USE_CELL_ANIMATION 1

#define LOADER_CELL_HEIGHT 44.0f

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
@property (nonatomic, assign) BOOL isLoading;

#if USE_SIZE_CACHE
@property (nonatomic, strong) NSMutableDictionary *sizeCache;
#endif

#if USE_ATTRIBUTED_TEXT_CACHE
@property (nonatomic, strong) NSMutableDictionary *usernameCache;
@property (nonatomic, strong) NSMutableDictionary *tweetTextCache;
#endif

#if USE_CELL_ANIMATION
@property (nonatomic, strong) NSMutableSet *popupAnimationSet;
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
    
#if USE_CELL_ANIMATION
    self.popupAnimationSet = [NSMutableSet new];
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
    [DataManager retrieveAccountFeed:self.currentAccount withCompletion:^(NSData *responseData, NSHTTPURLResponse *urlResponse) {
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
                
                [tweetCell.repostButton setTitle:[NSString stringWithFormat:@"%li", (long)node.tweet.retweetCount]
                                        forState:UIControlStateNormal];
                [tweetCell.favButton setTitle:[NSString stringWithFormat:@"%li", (long)node.tweet.favoriteCount]
                                        forState:UIControlStateNormal];
                
                NSString *imagePath = node.tweet.user.profileImageUrl;
                [[HVImageBank sharedInstance]
                 loadImageWithURL:[NSURL URLWithString:[imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
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
            [weakSelf addAndRefreshDataWithNodeArray:[weakSelf nodeArrayFromParsedData:result]];
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

- (void) addAndRefreshDataWithNodeArray:(NSArray *)nodeArray {
    if (self.isLoading) { // Waiting for a page
        
        NSInteger addedCount = [nodeArray count];
        NSInteger insertIndex = [self.dataArray indexOfObject:[self lastTweetNodeFromArray:self.dataArray]];
        
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (NSInteger i = insertIndex; i < insertIndex + addedCount; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        NSMutableArray *mutableData = [self.dataArray mutableCopy];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(insertIndex, addedCount)];
        [mutableData insertObjects:nodeArray atIndexes:indexSet];
        
        self.dataArray = [NSArray arrayWithArray:mutableData];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        self.isLoading = NO;
        
    } else { // First data is loading
        
        HVDataNode *loaderNode = [[HVDataNode alloc] init];
        loaderNode.nodeType = kTweetTableCellTypeLoader;
        
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:nodeArray];
        [temp addObject:loaderNode];
        
        self.dataArray = [NSArray arrayWithArray:temp];
        [self.tableView reloadData];
        
    }
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
    if (node.nodeType == kTweetTableCellTypeNormal) {
        NSNumber *cachedHeight = self.sizeCache[node.tweet.idStr];
        
        if (cachedHeight != nil) {
            return [cachedHeight floatValue];
        }
    }
#endif
    
    CGFloat calculatedHeight = 0.0f;
    
    switch (node.nodeType) {
        case kTweetTableCellTypeNormal:
            calculatedHeight = [TweetCell heightForTweet:node.tweet constrainedToWidth:CGRectGetWidth(tableView.bounds)];
            break;
        case kTweetTableCellTypeLoader:
            calculatedHeight = LOADER_CELL_HEIGHT;
            break;
        default:
            break;
    }
    
    
#if USE_SIZE_CACHE
    if (node.nodeType == kTweetTableCellTypeNormal) {
        self.sizeCache[node.tweet.idStr] = @(calculatedHeight);
    }
#endif
    
    return calculatedHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HVDataNode *node = self.dataArray[indexPath.row];
    
#if USE_CELL_ANIMATION
    if (node.nodeType == kTweetTableCellTypeNormal) {
        if (![self.popupAnimationSet containsObject:node.tweet.idStr]) {
            cell.layer.transform = [TweetCell initialTransform];
            cell.layer.opacity = .1f;
            [UIView animateWithDuration:0.4 animations:^{
                cell.layer.transform = CATransform3DIdentity;
                cell.layer.opacity = 1;
            }];
            [self.popupAnimationSet addObject:node.tweet.idStr];
        }
    }
#endif
    
    if (node.nodeType == kTweetTableCellTypeLoader && !self.isLoading) {
        HVDataNode *lastNode = [self lastTweetNodeFromArray:self.dataArray];
        [self loadTweetsMaxId:lastNode.tweet.idStr];
    }
}

- (HVDataNode *) lastTweetNodeFromArray:(NSArray *) array {
    if (array.count) {
        for (NSUInteger i = array.count-1; i > 0; i --) {
            HVDataNode *node = self.dataArray[i];
            if (node.nodeType == kTweetTableCellTypeNormal) return node;
        }

    }
    return nil;
}

- (void) loadTweetsMaxId:(NSString *)maxId {
    self.isLoading = YES;
    [DataManager retrieveAccountFeed:self.currentAccount maxId:maxId withCompletion:^(NSData *responseData, NSHTTPURLResponse *urlResponse) {
        self.newDataReceivedBlock (responseData);
    } failure:^(NSError *error) {
        self.errorBlock (error);
    }];

}

- (void) loadTweetsSinceId:(NSString *)sinceId {
    self.isLoading = YES;
    [DataManager retrieveAccountFeed:self.currentAccount sinceId:sinceId withCompletion:^(NSData *responseData, NSHTTPURLResponse *urlResponse) {
        self.newDataReceivedBlock (responseData);
    } failure:^(NSError *error) {
        self.errorBlock (error);
    }];
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
