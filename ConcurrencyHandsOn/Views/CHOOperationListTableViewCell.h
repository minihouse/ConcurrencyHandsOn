//
//  CHOOperationListTableViewCell.h
//  ConcurrencyHandsOn
//
//  Created by 小屋敷 圭史 on 2015/03/15.
//  Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHOOperationListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *sleep;
@property (nonatomic, weak) IBOutlet UILabel *dependent;
@property (nonatomic, weak) IBOutlet UILabel *queuePriority;

@end
