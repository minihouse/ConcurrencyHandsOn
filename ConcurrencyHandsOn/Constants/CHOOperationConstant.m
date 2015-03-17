//
// CHOOperationConstant.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/15.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOOperationConstant.h"

@implementation CHOOperationConstant

NSString *const CHOOperationDidStartNotification = @"concurrency.handson.operation.start";
NSString *const CHOOperationExecTaskNotification = @"concurrency.handson.operation.exec";
NSString *const CHOOperationDidFinishNotification = @"concurrency.handson.operation.finish";

NSString *const CHOOperationTextNotificationKey = @"CHOOperationTextNotificationKey";

@end