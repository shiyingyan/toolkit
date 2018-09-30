//
//  ESDefine.h
//  ExtensionSDK
//
//  Created by YDJ on 13-3-22.
//  Copyright (c) 2013年 jingyoutimes. All rights reserved.
//

#ifndef ExtensionSDK_ESDefine_h
#define ExtensionSDK_ESDefine_h

#ifndef DocumentPath_Ext
#define DocumentPath_Ext [NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()]
#endif

#ifndef ESDocument_Ext
//主目录
#define ESDocument_Ext [NSString stringWithFormat:@"%@/ESDocument",DocumentPath_Ext]
#endif
//公开目录
#ifndef publicDoc_Ext
#define publicDoc_Ext [NSString stringWithFormat:@"%@/publicDoc",ESDocument_Ext]
#endif
//私有目录
#ifndef privateDoc_Ext
#define privateDoc_Ext [NSString stringWithFormat:@"%@/privateDoc",ESDocument_Ext]
#endif

//私有encodeData
#ifndef priEncodeDataPath_Ext
#define priEncodeDataPath_Ext [NSString stringWithFormat:@"%@/privateEncodeData",privateDoc_Ext]
#endif

//缓存崩溃信息
#ifndef CrashLogPath_Ext
#define CrashLogPath_Ext [NSString stringWithFormat:@"/%@/crash",publicDoc_Ext]
#endif

//encode的数据
#ifndef pubEncodeDataPath_Ext
#define pubEncodeDataPath_Ext [NSString stringWithFormat:@"%@/encoderDatas",publicDoc_Ext]
#endif

#endif
