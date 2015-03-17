//
// CHOOperationQueueManager.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/16.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOOperationQueueManager.h"
#import "CHOConcurrentOperation.h"
#import "CHONonConcurrentOperation.h"

@implementation CHOOperationQueueManager
- (instancetype)init
{
    self = [super init];

    if(self) {
        [self loadOperationInfoPlist];
    }

    return self;
}

#pragma mark - public

- (void)setupOperationQueueWithType:(CHOOperationQueueType)type
{
    switch(type) {
            case CHOOperationQueueTypeMainThread:
        {
            [self setupMainThreadPattern];
            break;
        }
            case CHOOperationQueueTypeMultiThread:
        {
            [self setupMulitThreadPattern];
            break;
        }
            case CHOOperationQueueTypeMultiThreadUseMaxCount:
        {
            [self setupMulitThreadUseMaxCountPattern];
            break;
        }
            case CHOOperationQueueTypeMultiThreadUseDependency:
        {
            [self setupMulitThreadUseDependencyPattern];
        }
            case CHOOperationQueueTypeMultiThreadUseQueuePriority:
        {
            [self setupMulitThreadUseQueuePriorityPattern];
        }
            default:
        {
            break;
        }
    }
}

#pragma mark - private

/*
 * PlistからOperationの情報を取得し、NSOperationを生成
 */
- (void)loadOperationInfoPlist
{
    // PListからOperationデータ取得
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"OperationInfos" ofType:@"plist"];

    self.operationDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *concurrentOperationInfos = self.operationDictionary[@"Concurrent"];
    NSArray *nonConcurrentOperationInfos = self.operationDictionary[@"NonConcurrent"];

    // 非同期Operation生成
    NSMutableArray *conccurentOperations = [[NSMutableArray alloc] init];

    for(NSInteger i = 0; i < [concurrentOperationInfos count]; i++) {
        NSDictionary *operationInfo = concurrentOperationInfos[i];
        CHOConcurrentOperation *operation = [[CHOConcurrentOperation alloc] initWithInfo:operationInfo];

        [conccurentOperations addObject:operation];
    }

    self.concurrentOperations = [conccurentOperations copy];

    // 期Operation
    NSMutableArray *nonConccurentOperations = [[NSMutableArray alloc] init];

    for(NSInteger i = 0; i < [nonConcurrentOperationInfos count]; i++) {
        NSDictionary *operationInfo = nonConcurrentOperationInfos[i];
        CHONonConcurrentOperation *operation = [[CHONonConcurrentOperation alloc] initWithInfo:operationInfo];

        [nonConccurentOperations addObject:operation];
    }

    self.nonConcurrentOperations = [nonConccurentOperations copy];
}

/*
 * メインスレッドで実行
 */
- (void)setupMainThreadPattern
{
    // キュー登録
    NSOperationQueue *queue = [NSOperationQueue mainQueue];    // メインスレッド用キュー

    [self setupOperationQueue:queue];
}

/*
 * マルチスレッドで実行
 */
- (void)setupMulitThreadPattern
{
    // キュー登録
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // マルチスレッド用キュー

    [self setupOperationQueue:queue];
}

/*
 * マルチスレッドで実行
 * ただし、同時スレッド数を指定
 */
- (void)setupMulitThreadUseMaxCountPattern
{
    // キュー登録
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // マルチスレッド用キュー

    queue.maxConcurrentOperationCount = 2;                     // スレッドを1つに限定
    [self setupOperationQueue:queue];
}

/*
 * マルチスレッドで実行
 * タスク間に依存関係を持たせる
 */
- (void)setupMulitThreadUseDependencyPattern
{
    // キュー登録
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // マルチスレッド用キュー

    // 非同期Operationをキューに追加
    for(NSInteger i = 0; i < [self.concurrentOperations count]; i++) {
        CHOConcurrentOperation *operation = self.concurrentOperations[i];

        if(operation.isDependentBeforeTask && i > 0) {
            // 一つ前のOperationを依存に追加
            [operation addDependency:self.concurrentOperations[i - 1]];
        }

        [queue addOperation:operation];
    }

    // 期Operationキューに追加
    for(NSInteger i = 0; i < [self.nonConcurrentOperations count]; i++) {
        CHONonConcurrentOperation *operation = self.nonConcurrentOperations[i];

        if(operation.isDependentBeforeTask && i > 0) {
            // 一つ前のOperationを依存に追加
            [operation addDependency:self.nonConcurrentOperations[i - 1]];
        }

        [queue addOperation:operation];
    }
}

/*
 * マルチスレッドで実行
 * タスク間に優先度を持たせる
 */
- (void)setupMulitThreadUseQueuePriorityPattern
{
    // キュー登録
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // マルチスレッド用キュー

    // 非同期Operationをキューに追加
    for(CHOConcurrentOperation *operation in self.concurrentOperations) {
        if(operation.queuePriorityString) {
            operation.queuePriority = [self queuePriorityFromString:operation.queuePriorityString];
        }

        [queue addOperation:operation];
    }

    // 期Operationキューに追加
    for(CHONonConcurrentOperation *operation in self.nonConcurrentOperations) {
        if(operation.queuePriorityString) {
            operation.queuePriority = [self queuePriorityFromString:operation.queuePriorityString];
        }

        [queue addOperation:operation];
    }
}

- (void)setupOperationQueue:(NSOperationQueue *)queue
{
    // 非同期Operationをキューに追加
    for(CHOConcurrentOperation *operation in self.concurrentOperations) {
        [queue addOperation:operation];
    }

    // 期Operationキューに追加
    for(CHONonConcurrentOperation *operation in self.nonConcurrentOperations) {
        [queue addOperation:operation];
    }
}

- (NSOperationQueuePriority)queuePriorityFromString:(NSString *)string
{
    if([string isEqualToString:@"VeryLow"]) {
        return NSOperationQueuePriorityVeryLow;
    } else if([string isEqualToString:@"Low"]) {
        return NSOperationQueuePriorityLow;
    } else if([string isEqualToString:@"Normal"]) {
        return NSOperationQueuePriorityNormal;
    } else if([string isEqualToString:@"High"]) {
        return NSOperationQueuePriorityHigh;
    } else if([string isEqualToString:@"VeryHigh"]) {
        return NSOperationQueuePriorityVeryHigh;
    }

    return NSOperationQueuePriorityNormal;
}

@end