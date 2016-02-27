//
//  LrcParseTool.h
//  XRLrcParse
//
//  Created by xuran on 16/2/26.
//  Copyright © 2016年 X.R. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LrcInfoModel;
@interface LrcParseTool : NSObject

/**
 *  @brief  歌词解析
 *  
 *  @param  本地歌词文件名
 *  @return 解析好的歌词 + 歌词头部信息
 */
+ (void)lrcInfoFromLrcFileWithFileName:(NSString *)fileName completion:(void(^)(NSMutableArray * lrcArray,
                                                                                LrcInfoModel *infoModel))completion;

@end
