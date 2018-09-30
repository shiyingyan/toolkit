//
//  NSData+Extension.h
//  ExtensionSDK
//
//  Created by YDJ on 13-3-11.
//  Copyright (c) 2013年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

//加密使用的初始化向量
static const Byte  iv_data[] = {1,2,3,4,5,6,7,8};


@interface NSData (Extension)


/**
 * @brief 数据进行MD5(32位)签名验证
 *
 * @return 签名后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *MD5D32HexDigest_Ext;

/**
 * @brief sha1签名验证
 *
 * @return 签名后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *SHA1Hash_Ext;

/**
 * @brief SHA224签名验证
 *
 * @return 签名后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *SHA224Hash_Ext;

/**
 * @brief SHA256签名验证
 *
 * @return 签名后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *SHA256Hash_Ext;

/**
 * @brief SHA384签名验证
 *
 * @return 签名后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *SHA384Hash_Ext;

/**
 * @brief SHA512签名验证
 *
 * @return 签名后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *SHA512Hash_Ext;

/**
 *	@brief	使用Key进行HMAC-SHA1加密
 *
 *	@param 	key 	密钥
 *
 *	@return	加密后数据
 */
- (NSData *)dataByUsingHMacSHA1WithKey_Ext:(NSData *)key;


/**
 * @brief 数据base64编码
 *
 * @return 编码后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *base64Encoded_Ext;

/**
 * @brief 数据base64解码
 *
 * @return 解码后的数据
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *base64Decoded_Ext;


/**
 * @brief 类方法，base64解码，从base64的字符串中得到data
 *
 * @param aString 经过base编码的字符串
 *
 * @param encode 字符串aString的编码格式
 *
 * @return 解码后的数据
 */
+ (NSData *)dataFromBase64String_Ext:(NSString *)aString encoding:(NSStringEncoding)encode;

/**
 * @brief 数据base64编码
 *
 * @param encoding 经过base64编码的后，返回字符串的格式编码(UTF-8,GB2313)
 *
 * @return 编码后的字符串
 */
- (NSString *)base64EncodedStringEncoding_Ext:(NSStringEncoding)encoding;

/**
 * @brief 数据base64解码
 *
 * @param encoding 经过base64解码的后，返回字符串的格式编码(UTF-8,GB2313)
 *
 * @return 解码后的字符串
 */
- (NSString *)base64DecodedStringEncoding_Ext:(NSStringEncoding)encoding;

/**
 * @brief 数据AES128位加密
 *
 * @param keyData 加密的key值数据(32位)可以进行md5
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 加密后的数据
 */
- (NSData *)dataUsingAES128EncryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;

/**
 * @brief 数据AES128为解码
 *
 * @param keyData 解密的key值数据(32位) 可以进行md5
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 解密后的数据
 */
- (NSData *)dataUsingAES128DecryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;


/**
 * @brief 数据AES256位加密
 *
 * @param keyData 加密的key值数据(64位) 
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 加密后的数据
 */
- (NSData *)dataUsingAES256EncryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;

/**
 * @brief 数据AES256为解码
 *
 * @param keyData 解密的key值数据(64位) 
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 解密后的数据
 */
- (NSData *)dataUsingAES256DecryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;


/**
 * @brief 数据进行3DES加密
 *
 * @param keyData 解密的key值,(40位),可以先进行SHA1Hash_Ext
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 加密后的数据
 */
- (NSData *)dataUsing3DESEncryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;

/**
 * @brief 数据进行3DES解密
 *
 * @param keyData 解密的key值，(40位)可以先进行SHA1Hash_Ext
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 解密后的数据
 */
- (NSData *)dataUsing3DESDecryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;

/**
 * @brief 数据进行DES加密
 *
 * @param keyData 界面的key值
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 加密后的数据
 */
- (NSData *)dataUsingDESEncryWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;

/**
 * @brief 数据进行DES解密
 *
 * @param keyData 界面的key值
 *
 * @param iv_ 初始化向量值，可以为空
 *
 * @return 解密后的数据
 */
- (NSData *)dataUsingDESDencryWithkey_Ext:(NSData *)keyData withIV:(void *)iv_;

/**
 * @brief json数据解析成对象，
 *
 * @return 数组或者字典
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id objectFromJSONData_Ext NS_AVAILABLE(10_7, 5_0);


@end
