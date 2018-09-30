//
//  Tool_FMDBGetDatabase.m
//  FMDB封装
//
//  Created by LM on 16/3/24.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "MJTool_FMDBGetDatabase.h"

@implementation MJTool_FMDBGetDatabase
@synthesize dbQueue = _dbQueue;
static MJTool_FMDBGetDatabase *tool_database = nil;
//单例
+ (instancetype)shareTool_FMDBGetDatabase
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        tool_database = [[self alloc] init] ;
    }) ;
    return tool_database;
}
- (id)copyWithZone:(struct _NSZone *)zone
{
    return [MJTool_FMDBGetDatabase shareTool_FMDBGetDatabase];
}
//创建数据库保存路径
+ (NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    docsdir = [docsdir stringByAppendingPathComponent:@"JKBD"];
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"jkdb.sqlite"];
    return dbpath;
}
//创建多线程安全的数据库
- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}
@end
