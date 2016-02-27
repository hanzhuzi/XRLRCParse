//
//  LrcDisplayCell.h
//  XRLrcParse
//
//  Created by xuran on 16/2/27.
//  Copyright © 2016年 X.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LrcModel;
@interface LrcDisplayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lrcLabel;

- (void)configCellWithLrcModel:(LrcModel *)model;

@end
