//
//  CHOOperationQueueManager.h
//  ConcurrencyHandsOn
//
//  Created by 小屋敷 圭史 on 2015/03/16.
//  Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CHOOperationQueueType) {
    CHOOperationQueueTypeMainThread,
    CHOOperationQueueTypeMultiThread,
    CHOOperationQueueTypeMultiThreadUseMaxCount,
    CHOOperationQueueTypeMultiThreadUseDependency,
    CHOOperationQueueTypeMultiThreadUseQueuePriority
};

@interface CHOOperationQueueManager : NSObject

@property (nonatomic, strong) NSDictionary *operationDictionary;
@property (nonatomic, strong) NSArray *concurrentOperations;
@property (nonatomic, strong) NSArray *nonConcurrentOperations;

- (void)setupOperationQueueWithType:(CHOOperationQueueType)type;

@end
