//
//  LrcParseTool.h
//  XRLrcParse
//
//  Created by xuran on 16/2/26.
//  Copyright © 2016年 X.R. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcParseTool : NSObject

+ (instancetype)sharedToolWithLrcFileName:(NSString *)fileName;

/**
 *  得到解析好的歌词
 */
- (NSMutableArray *)lrcInfoFromLrcFile;

@end
