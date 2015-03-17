//
//  CHOOperationListViewController.h
//  ConcurrencyHandsOn
//
//  Created by 小屋敷 圭史 on 2015/03/15.
//  Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHOOperationQueueManager.h"

typedef NS_ENUM(NSInteger, CHOOperationListTableSection) {
    CHOOperationListTableSectionConcurrent,
    CHOOperationListTableSectionNonConcurrent
};

@interface CHOOperationListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) CHOOperationQueueType operationQueueType;

@end
