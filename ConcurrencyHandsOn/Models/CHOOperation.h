//
//  CHOOperation.h
//  ConcurrencyHandsOn
//
//  Created by 小屋敷 圭史 on 2015/03/15.
//  Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHOOperation : NSOperation

@property (nonatomic) double sleepTimeInterval;
@property (nonatomic) BOOL isDependentBeforeTask;
@property (nonatomic) NSString *queuePriorityString;

- (instancetype)initWithInfo:(NSDictionary *)info;

/*
 * タスク開始処理
 */
- (void)didStartTask;
/*
 * タスク処理
 */
- (void)execTask;
/*
 * タスク完了処理
 */
- (void)didFinishTask;

@end
