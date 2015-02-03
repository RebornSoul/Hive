//
//  HVImageBank.m
//  Hive
//
//  Created by Yury Nechaev on 03.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//
#import "HVImageBank.h"

static HVImageBank *instanceImageBank = nil;

@interface HVImageBank ()
@property (nonatomic, strong) NSOperationQueue *loadOperationQueue;
@property (nonatomic, strong) NSOperationQueue *saveOperationQueue;
@end

@implementation HVImageBank

+ (instancetype)  sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceImageBank = [[HVImageBank alloc] init];
    });
    return instanceImageBank;
}

- (id) init {
    self = [super init];
    if (self) {
        _loadOperationQueue = [[NSOperationQueue alloc] init];
        _saveOperationQueue = [NSOperationQueue new];
        _saveOperationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void) loadImageWithURL:(NSURL *)url
               completion:(HVImageCompletionBlock)completion {
    HVImageBankOperation *operation = [HVImageBankOperation operationWithImageURL:url];
    [operation setImageCompletionBlock:completion];
    [self.loadOperationQueue addOperation:operation];
    [operation start];
}

- (void)saveImageToDiskForKey:(UIImage *)image key:(NSString *)key {
    [self.saveOperationQueue addOperationWithBlock:^{
        NSString *filePath = [self filePathForKey:key];
        NSData *imageData = UIImagePNGRepresentation(image);
        if(imageData.length < [self freeDiskSpace]) {
            [[self sharedFileManager] createFileAtPath:filePath contents:imageData attributes:nil];
        }
    }];
}

- (NSString *)filePathForKey:(NSString *)key {
    return [[self cacheDirectoryPath] stringByAppendingPathComponent:key];
}

- (NSString *)cacheDirectoryPath {
    static NSString *cacheDirectoryPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cacheDirectoryPath = [[[caches objectAtIndex:0] stringByAppendingPathComponent:@"HVImageBankCache"] copy];
        NSFileManager *fileManager = [self sharedFileManager];
        if([fileManager fileExistsAtPath:cacheDirectoryPath isDirectory:NULL] == NO) {
            [fileManager createDirectoryAtPath:cacheDirectoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
    return cacheDirectoryPath;
}

- (NSFileManager *)sharedFileManager {
    static id sharedFileManagerID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFileManagerID = [[NSFileManager alloc] init];
    });
    return sharedFileManagerID;
}

- (unsigned long long)freeDiskSpace {
    unsigned long long totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[[self class] sharedFileManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
    }
    return totalFreeSpace;
}


@end
