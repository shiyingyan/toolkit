//
//  Tool_FMDBGetDatabase.h
//  FMDB封装
//
//  Created by LM on 16/3/24.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface MJTool_FMDBGetDatabase : NSObject
@property(nonatomic,strong,readonly)FMDatabaseQueue *dbQueue;
+ (instancetype)shareTool_FMDBGetDatabase;
//创建文件夹，拼接数据库路径（此时数据库还没创建）
+ (NSString *)dbPath;
@end
