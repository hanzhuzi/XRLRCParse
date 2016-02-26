//
//  LrcParseTool.h
//  XRLrcParse
//
//  Created by xuran on 16/2/26.
//  Copyright © 2016年 X.R. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcParseTool : NSObject

/**
 *  得到解析好的歌词
 */
+ (NSMutableArray *)lrcInfoFromLrcFileWithFileName:(NSString *)fileName;

@end
