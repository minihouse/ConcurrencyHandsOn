//
//  CHOHandsOnCollectionViewCell.h
//  ConcurrencyHandsOn
//
//  Created by 小屋敷 圭史 on 2015/03/18.
//  Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHOHandsOnCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

- (void)startLoading;
- (void)stopLoading;

@end
