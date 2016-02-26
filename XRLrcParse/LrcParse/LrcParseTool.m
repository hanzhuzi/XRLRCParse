//
//  LrcParseTool.m
//  XRLrcParse
//
//  Created by xuran on 16/2/26.
//  Copyright © 2016年 X.R. All rights reserved.
//

/**
 *  歌词解析工具类
 *  by X.R
 */

#define LrcFilePath(name) [[NSBundle mainBundle] pathForResource:(name) ofType:nil]

#import "LrcParseTool.h"
#import "LrcModel.h"

@interface LrcParseTool()
{
    NSString * _fileName;
}

@end

@implementation LrcParseTool

- (instancetype)initWithLrcFileName:(NSString *)fileName {
    if (self = [super init]) {
        _fileName = fileName;
    }
    
    return self;
}

+ (instancetype)sharedToolWithLrcFileName:(NSString *)fileName
{
    static LrcParseTool * tool = nil;
    static dispatch_once_t once = 0l;
    
    dispatch_once(&once, ^{
        if (!tool) {
            tool = [[LrcParseTool alloc] initWithLrcFileName:fileName];
        }
    });
    
    return tool;
}

/**
 *  [00:00.00 格式时间字符串转换成对应的秒数字符串
 */
- (NSString *)timeStringToSeccondStr:(NSString *)timeStr
{
    if (timeStr && timeStr.length > 1) {
        NSString * timeString = [timeStr substringFromIndex:1];
        NSArray * timeArray = [timeString componentsSeparatedByString:@":"];
        NSString * minStr = timeArray[0];
        double minOfTwo = [[minStr substringWithRange:NSMakeRange(0, 1)] doubleValue];
        double minOfOne = [[minStr substringWithRange:NSMakeRange(1, 1)] doubleValue];
        double min = minOfOne + minOfTwo * 10.0;
        NSString * seccondStr = timeArray[1];
        double seccond = [seccondStr doubleValue];
        double totalSeccond = min * 60.0 + seccond;
        
        NSString * totalTimeStr = [NSString stringWithFormat:@"%lf", totalSeccond];
        return totalTimeStr;
    }
    
    return nil;
}

/**
 *  解析歌词（解析本地歌词文件，可根据需要进行扩展，解析从网络下载的歌词数据）
 */
- (NSMutableArray *)lrcInfoFromLrcFile
{
    NSString * lrcStr = [NSString stringWithContentsOfFile:LrcFilePath(_fileName) encoding:NSUnicodeStringEncoding error:nil];
    // 存放解析好的歌词
    NSMutableArray * lrcArr = [[NSMutableArray alloc] init];
    // 以'\n'解析歌词字符串
    NSArray * lrcArray = [lrcStr componentsSeparatedByString:@"\n"];
    for (NSInteger i = 0; i < lrcArray.count; i++) {
        NSString * lineLrcStr = lrcArray[i];
        // 以']'进行分割
        NSArray * lineArray = [lineLrcStr componentsSeparatedByString:@"]"];
        // [00:00.33]xxxx
        if ([lineArray[0] length] > 8) {
            NSString * tempStr1 = [lineArray[0] substringWithRange:NSMakeRange(3, 1)];
            NSString * tempStr2 = [lineArray[0] substringWithRange:NSMakeRange(6, 1)];
            NSString * lrcText = lineArray[lineArray.count - 1];
            if ([tempStr1 isEqualToString:@":"] && [tempStr2 isEqualToString:@"."]) {
                // 解析[00:00.00]xxx 类的歌词
                for (NSInteger i = 0; i < lineArray.count - 1; i++) {
                    NSString * timeStr = lineArray[i];
                    timeStr = [self timeStringToSeccondStr:timeStr];
                    LrcModel * model = [[LrcModel alloc] init];
                    model.timeStr = timeStr;
                    model.lrcStr  = lrcText;
                    [lrcArr addObject:model];
                }
            }
        }
    }
    
    lrcArr = [self lrcArraySortedByTimeWithArray:lrcArr];
    
    return lrcArr;
}

/**
 *  按时间顺序对歌词进行排序
 */
- (NSMutableArray *)lrcArraySortedByTimeWithArray:(NSMutableArray *)lrcArr
{
    NSMutableArray * modelArr = lrcArr;
    // 选择排序
    for (NSUInteger i = 0; i < modelArr.count; i++) {
        for (NSUInteger j = 0; j < modelArr.count; j++) {
            LrcModel * model1 = modelArr[i];
            LrcModel * model2 = modelArr[j];
            if ([model1.timeStr doubleValue] < [model2.timeStr doubleValue]) {
                [modelArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    return modelArr;
}

@end
