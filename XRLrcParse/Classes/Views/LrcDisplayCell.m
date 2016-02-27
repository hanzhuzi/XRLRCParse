//
//  LrcDisplayCell.m
//  XRLrcParse
//
//  Created by xuran on 16/2/27.
//  Copyright © 2016年 X.R. All rights reserved.
//

#import "LrcDisplayCell.h"
#import "LrcModel.h"

@implementation LrcDisplayCell

- (void)awakeFromNib {
    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
    self.lrcLabel.textColor = [UIColor whiteColor];
    self.lrcLabel.font = [UIFont systemFontOfSize:14.0];
}

- (void)configCellWithLrcModel:(LrcModel *)model
{
    if (model) {
        self.lrcLabel.text = model.lrcStr;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // 处理选中后的效果
    if (selected) {
        self.lrcLabel.textColor = [UIColor redColor];
        self.lrcLabel.font = [UIFont systemFontOfSize:16.0];
    }else {
        self.lrcLabel.textColor = [UIColor whiteColor];
        self.lrcLabel.font = [UIFont systemFontOfSize:14.0];
    }
}

@end
