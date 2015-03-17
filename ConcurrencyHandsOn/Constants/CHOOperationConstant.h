//
//  CHOOperationConstant.h
//  ConcurrencyHandsOn
//
//  Created by 小屋敷 圭史 on 2015/03/15.
//  Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHOOperationConstant : NSObject

// NSNotificationCenter
extern NSString * const CHOOperationDidStartNotification;
extern NSString * const CHOOperationExecTaskNotification;
extern NSString * const CHOOperationDidFinishNotification;

// NSNotificationKey
extern NSString * const CHOOperationTextNotificationKey;

@end
