//
//  LrcModel.h
//  XRLrcParse
//
//  Created by xuran on 16/2/26.
//  Copyright © 2016年 X.R. All rights reserved.
//

/**
 *  歌词数据模型
 */

#import <Foundation/Foundation.h>

@interface LrcModel : NSObject

@property (nonatomic, copy) NSString * timeStr;
@property (nonatomic, copy) NSString * lrcStr;

@end
