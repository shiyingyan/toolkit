//
//  NSData+Extension.m
//  ExtensionSDK
//
//  Created by YDJ on 13-3-11.
//  Copyright (c) 2013年 jingyoutimes. All rights reserved.
//

#import "NSData+Extension.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Availability.h>

@implementation NSData (Extension)


-(NSData *)MD5D32HexDigest_Ext
{
    if (self==nil) {
        return nil;
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (unsigned int)self.length, result);
    
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *) SHA1Hash_Ext
{
	unsigned char hash[CC_SHA1_DIGEST_LENGTH];
	(void) CC_SHA1( self.bytes, (CC_LONG)self.length, hash );
	return ( [NSData dataWithBytes: hash length: CC_SHA1_DIGEST_LENGTH] );
}


- (NSData *) SHA224Hash_Ext
{
	unsigned char hash[CC_SHA224_DIGEST_LENGTH];
	(void) CC_SHA224( self.bytes, (CC_LONG)self.length, hash );
	return ( [NSData dataWithBytes: hash length: CC_SHA224_DIGEST_LENGTH] );
}

- (NSData *) SHA256Hash_Ext
{
	unsigned char hash[CC_SHA256_DIGEST_LENGTH];
	(void) CC_SHA256( self.bytes, (CC_LONG)self.length, hash );
	return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}

- (NSData *) SHA384Hash_Ext
{
	unsigned char hash[CC_SHA384_DIGEST_LENGTH];
	(void) CC_SHA384( self.bytes, (CC_LONG)self.length, hash );
	return ( [NSData dataWithBytes: hash length: CC_SHA384_DIGEST_LENGTH] );
}

- (NSData *) SHA512Hash_Ext
{
	unsigned char hash[CC_SHA512_DIGEST_LENGTH];
	(void) CC_SHA512( self.bytes, (CC_LONG)self.length, hash );
	return ( [NSData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}

/**
 *	@brief	使用Key进行HMAC-SHA1加密
 *
 *	@param 	key 	密钥
 *
 *	@return	加密后数据
 */
- (NSData *)dataByUsingHMacSHA1WithKey_Ext:(NSData *)key
{
    if (self==nil) {
        return nil;
    }
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, key.bytes, strlen(key.bytes), self.bytes, strlen(self.bytes), cHMAC);
    
    NSData * data=[NSData dataWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    return data;
}


- (NSData *)base64Encoded_Ext
{
    NSInteger wrapWidth = 0;
    wrapWidth=(wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    unsigned long inputLength = self.length;
    const unsigned char *inputBytes = self.bytes;
    
    unsigned long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long i;
    unsigned long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    
    NSData * data_result=nil;
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, outputLength);
        
        data_result=[NSData dataWithBytes:outputBytes length:outputLength];
        /*return [[NSString alloc] initWithBytesNoCopy:outputBytes
         length:outputLength
         encoding:NSASCIIStringEncoding
         freeWhenDone:YES];*/
    }
   // else if (outputBytes)
   // {
        free(outputBytes);
  //  }
    return data_result;
    
}
- (NSData *)base64Decoded_Ext
{
    
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    //NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    unsigned long inputLength = self.length;
    const unsigned char *inputBytes = self.bytes;
    
    unsigned long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)outputData.mutableBytes;
    
    int accumulator = 0;
    unsigned long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
        
    return outputLength? outputData: nil;
}



+ (NSData *)dataFromBase64String_Ext:(NSString *)aString encoding:(NSStringEncoding)encode
{
	NSData *data = [aString dataUsingEncoding:encode];
	
    NSData * result=[data base64Decoded_Ext];
	return result;
}


- (NSString *)base64EncodedStringEncoding_Ext:(NSStringEncoding)encoding
{

    NSData * data=[self base64Encoded_Ext];
    NSString * result=[[NSString alloc] initWithData:data encoding:encoding];
	return result;
}

- (NSString *)base64DecodedStringEncoding_Ext:(NSStringEncoding)encoding
{

    NSData * data=[self base64Decoded_Ext];
    NSString * result=[[NSString alloc] initWithData:data encoding:encoding];
    return result;
}




//- (NSData *)doCipher:(NSData *)plainText context:(CCOperation)encryptOrDecrypt keyData:(NSData *)keyData keySize:(uint8_t)keySizeAES
//{
//    
//    
//    const void * vplainText;
//    size_t plainTextBufferSize;
//    
//    plainTextBufferSize = [plainText length];
//    vplainText = [plainText bytes];
//    
//    
//    CCCryptorStatus ccStatus;
//    uint8_t * bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128)
//    & ~(kCCBlockSizeAES128 - 1);
//    
//    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    NSData * data=keyData;
//    
//    const void * vkey = (const void *)[data bytes];//[key UTF8String];
//    //  const void * vinitVec = (const void *)[initVec UTF8String];
//    
//    uint8_t iv[kCCBlockSizeAES128];
//    memset((void *) iv, 0x0, (size_t) sizeof(iv));
//    
//    ccStatus = CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithmAES128,
//                       kCCOptionPKCS7Padding,
//                       vkey, //"123456789012345678901234", //key
//                       keySizeAES,
//                       NULL,//vinitVec, //"init Vec", //iv,
//                       vplainText, //plainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    
//    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
//    if (ccStatus == kCCParamError){ return nil;}//@"PARAM ERROR";
//    else if (ccStatus == kCCBufferTooSmall) return nil;//@"BUFFER TOO SMALL";
//    else if (ccStatus == kCCMemoryFailure) return nil;//@"MEMORY FAILURE";
//    else if (ccStatus == kCCAlignmentError) return nil;//@"ALIGNMENT";
//    else if (ccStatus == kCCDecodeError) return nil;//@"DECODE ERROR";
//    else if (ccStatus == kCCUnimplemented) return nil;//@"UNIMPLEMENTED";
//    
//    
//    NSData * result;
//    
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        result = [NSData
//                  dataWithBytes:(const void *)bufferPtr
//                  length:(NSUInteger)movedBytes];
//    }
//    else
//    {
//        result= [NSData dataWithBytes:(const void *)bufferPtr
//                               length:(NSUInteger)movedBytes];
//    }
//    
//    return result;
//
//    
//    
//    
//    
//    //////////////////////////////////////////////////////////
////    
////    CCCryptorStatus cryptStatus = CCCrypt(encryptOrDecrypt,
////                                          keySizeAES,
////                                          kCCOptionPKCS7Padding,
////										  [keyData bytes],
////                                          FBENCRYPT_KEY_SIZE,
////                                          cIv,
////                                          [data bytes],
////                                          [data length],
////                                          buffer,
////                                          bufferSize,
////                                          &decryptedSize);
////    
////    CCCryptorStatus ccStatus = kCCSuccess;
////    // Symmetric crypto reference.
////    CCCryptorRef thisEncipher = NULL;
////    // Cipher Text container.
////    NSData * cipherOrPlainText = nil;
////    // Pointer to output buffer.
////    uint8_t * bufferPtr = NULL;
////    // Total size of the buffer.
////    size_t bufferPtrSize = 0;
////    // Remaining bytes to be performed on.
////    size_t remainingBytes = 0;
////    // Number of bytes moved to buffer.
////    size_t movedBytes = 0;
////    // Length of plainText buffer.
////    size_t plainTextBufferSize = 0;
////    // Placeholder for total written.
////    size_t totalBytesWritten = 0;
////    // A friendly helper pointer.
////    uint8_t * ptr;
////    CCOptions *pkcs7;
////    
////    CCOptions _padding = kCCOptionPKCS7Padding;
////
////    
////    pkcs7 = &_padding;
////    NSData *aSymmetricKey=keyData;
////    /*[NSMutableData data];
////    [aSymmetricKey appendData:[keyData MD5D32HexDigest_Ext]];
////    if (keySizeAES==kCCKeySizeAES256) {
////        [aSymmetricKey appendData:[keyData MD5D32HexDigest_Ext]];
////    }*/
////    
////    // Initialization vector; dummy in this case 0's.
////    uint8_t iv[kCCBlockSizeAES128];
////    memset((void *) iv, 0x0, (size_t) sizeof(iv));
////	
////    plainTextBufferSize = [plainText length];
////	
////    // We don't want to toss padding on if we don't need to
////    if(encryptOrDecrypt == kCCEncrypt) {
////        if(*pkcs7 != kCCOptionECBMode) {
////            *pkcs7 = kCCOptionPKCS7Padding;
////        }
////    } else if(encryptOrDecrypt != kCCDecrypt) {
////        NSLog(@"Invalid CCOperation parameter [%d] for cipher context.", *pkcs7 );
////    }
////	
////    // Create and Initialize the crypto reference.
////    ccStatus = CCCryptorCreate(encryptOrDecrypt,
////                               kCCAlgorithmAES128,
////                               *pkcs7,
////                               (const void *)[aSymmetricKey bytes],
////                               keySizeAES,/*AES128加密--128位的*//*kCCKeySizeAES128*/
////                               (const void *)iv,
////                               &thisEncipher
////                               );
////	
////    // Calculate byte block alignment for all calls through to and including final.
////    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
////	
////    // Allocate buffer.
////    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
////	
////    // Zero out buffer.
////    memset((void *)bufferPtr, 0x0, bufferPtrSize);
////	
////    // Initialize some necessary book keeping.
////    ptr = bufferPtr;
////	
////    // Set up initial size.
////    remainingBytes = bufferPtrSize;
////	
////    // Actually perform the encryption or decryption.
////    ccStatus = CCCryptorUpdate(thisEncipher,
////                               (const void *) [plainText bytes],
////                               plainTextBufferSize,
////                               ptr,
////                               remainingBytes,
////                               &movedBytes
////                               );
////	
////    // Handle book keeping.
////    ptr += movedBytes;
////    remainingBytes -= movedBytes;
////    totalBytesWritten += movedBytes;
////	
////    // Finalize everything to the output buffer.
////    ccStatus = CCCryptorFinal(thisEncipher,
////                              ptr,
////                              remainingBytes,
////                              &movedBytes
////                              );
////	
////    totalBytesWritten += movedBytes;
////	
////    if(thisEncipher) {
////        (void) CCCryptorRelease(thisEncipher);
////        thisEncipher = NULL;
////    }
////	
////    if (ccStatus == kCCSuccess)
////        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
////    else
////        cipherOrPlainText = nil;
////	
////    if(bufferPtr) free(bufferPtr);
////	
////    return cipherOrPlainText;
//}

- (NSData *)dataUsingAES128EncryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{
    if (self==nil) {
        return nil;
    }
   
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCEncrypt Algorithm:kCCAlgorithmAES128 keySize:kCCKeySizeAES128];
    
}
- (NSData *)dataUsingAES128DecryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{
    if (self==nil) {
        return nil;
    }
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCDecrypt Algorithm:kCCAlgorithmAES128 keySize:kCCKeySizeAES128];

}
- (NSData *)dataUsingAES256EncryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{

    if (self==nil) {
        return nil;
    }
    
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCEncrypt Algorithm:kCCAlgorithmAES128 keySize:kCCKeySizeAES256];


}

- (NSData *)dataUsingAES256DecryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{
    if (self==nil) {
        return nil;
    }
    
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCDecrypt Algorithm:kCCAlgorithmAES128 keySize:kCCKeySizeAES256];

    
}




- (NSData *)dataUsing3DESEncryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{

    if (self==nil) {
        return nil;
    }
    
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCEncrypt Algorithm:kCCAlgorithm3DES keySize:kCCKeySize3DES];
    
}
- (NSData *)dataUsing3DESDecryptWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{

    if (self==nil) {
        return nil;
    }
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCDecrypt Algorithm:kCCAlgorithm3DES keySize:kCCKeySize3DES];

}

- (NSData *)dataUsingDESEncryWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{

    if (self==nil) {
        return nil;
    }
    
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCEncrypt Algorithm:kCCAlgorithmDES keySize:kCCKeySizeDES];
    
}

- (NSData *)dataUsingDESDencryWithkey_Ext:(NSData *)keyData withIV:(void *)iv_
{
    if (self==nil) {
        return nil;
    }
    return [self cipherData:self withkey:keyData withIV:iv_ Operation:kCCDecrypt Algorithm:kCCAlgorithmDES keySize:kCCKeySizeDES];
}


-(NSData *)cipherData:(NSData *)edata withkey:(NSData *)kData withIV:(void *)iv_byte  Operation:(CCOperation)operation Algorithm:(CCAlgorithm)algorithm keySize:(uint8_t)keySize
{
    
    const void *textBytes = edata.bytes;//需要加密的bytes
    NSUInteger dataLength = edata.length;//
    
    const void * vkey = (const void *)kData.bytes;
    
    size_t numBytesEncrypted = 0;
    
    
    int blockSize=8;//设置blockSize的大小如:kCCBlockSizeDES
    if (algorithm==kCCAlgorithmAES128) {//如果是AES的时候 kCCBlockSizeAES128=16
        blockSize=16;
    }
    
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    bufferPtrSize = (dataLength +blockSize ) & ~(blockSize - 1);//
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    CCCryptorStatus cryptStatus = CCCrypt(operation, algorithm,
                                          kCCOptionPKCS7Padding,
                                          vkey, keySize,
                                          iv_byte,
                                          textBytes, dataLength,
                                          (void *)bufferPtr,
                                          bufferPtrSize,
                                          &numBytesEncrypted);
    
    NSData *data=nil;
    if (cryptStatus == kCCSuccess) {
        data= [NSData dataWithBytes:bufferPtr length:(NSUInteger)numBytesEncrypted];
    }
    free(bufferPtr);
    
    return data;    
}


- (id)objectFromJSONData_Ext
{

    if (self==nil) {
        return nil;
    }
    
    id obj=nil;
    NSError * error=nil;
    NSException * excp=nil;
    @try {
        obj=[NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    }
    @catch (NSException *exception) {
        excp=exception;
    }
    @finally {
        
    }
    
    if (error||excp) {
        NSLog(@"%@",excp.description);
        return nil;
    }
    
    return obj;
    
}



@end
