//
//  NSString+ECStringValidator.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/22/21.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ECStringValidator)

+ (BOOL)isThisALongLineOfUnderscores:(NSString*)inString;
+ (BOOL)isThisADateString:(NSString*)word;
+ (BOOL)isThisAValidWeightString:(NSString*)word;
+ (BOOL)isThisAValidTimeString:(NSString*)word;
+ (BOOL)isThisWinPayoutString:(NSString*)word;
+ (BOOL)isThisWinningKennelLine:(NSString*)word;
+ (BOOL)doesThisLineContainDateString:(NSString*)line;
+ (BOOL)isThisFallWord:(NSString*)testWord;

@end
