//
//  NSString+ECStringValidizer.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "NSString+ECStringValidizer.h"

@implementation NSString (ECStringValidizer)

+ (BOOL)isThisALongLineOfUnderscores:(NSString*)inString
{
	BOOL answer = NO;
	
	if([inString characterAtIndex:5] == '_' &&
	   [inString characterAtIndex:11] == '_' &&
	   [inString characterAtIndex:22] == '_' &&
	   [inString characterAtIndex:33] == '_' &&
	   [inString characterAtIndex:45] == '_')
	{
		answer = YES;
	}
	
	return answer;
}

+ (BOOL)isThisWinPayoutString:(NSString*)word
{
	BOOL isValid = NO;
	
	// win payout is first word with decimal place two characters from end of string
	char testChar = [word characterAtIndex:word.length - 3];
	
	if(testChar == '.')
	{
		isValid = TRUE;
	}
	
	return isValid;
}

+ (BOOL)isThisAValidTimeString:(NSString*)word
{
	BOOL answer			= NO;
	double minTimeValue = 27.00;
	double maxTimeValue	= 40.00;
	
	double value = [word doubleValue];
	
	if(value > minTimeValue && value < maxTimeValue)
	{
		answer = YES;
	}
	
	return answer;
}

+ (BOOL)isThisAValidWeightString:(NSString*)word
{

	BOOL isValidWeight = NO;
	
	if(word.length >= 2)
	{
		double minWeight	= 45.00;
		double maxWeight	= 105.00;
		double weightValue	= [word doubleValue];
	
		if(weightValue > minWeight &&  weightValue < maxWeight)
		{
			isValidWeight = YES;
		}
	}
	
	return isValidWeight;
}

+ (BOOL)isThisADateString:(NSString*)word
{
	BOOL isDateString = NO;
	
	if(word.length == 8)
	{
		if ([word characterAtIndex:1] == '/' &&		// check for form m/d/yyyy
			[word characterAtIndex:3] == '/' &&
			[word characterAtIndex:2] != '/')
		{
			isDateString = YES;
		}
	}
	else if(word.length == 9)
	{
		if([word characterAtIndex:2] == '/' &&		// check for form mm/d/yyyy
		   [word characterAtIndex:4] == '/' &&
		   [word characterAtIndex:3] != '/')
		{
			isDateString = YES;
		}
		else if([word characterAtIndex:1] == '/' &&	// check for form m/dd/yyyy
				[word characterAtIndex:4] == '/' &&
				[word characterAtIndex:2] != '/' &&
				[word characterAtIndex:3] != '/')
		{
			isDateString = YES;
		}
	}
	else if(word.length == 10)
	{
		if([word characterAtIndex:2] == '/' &&		// check for form mm/dd/yyyy
		   [word characterAtIndex:5] == '/' &&
		   [word characterAtIndex:3] != '/' &&
		   [word characterAtIndex:4] != '/')
		{
			isDateString = YES;
		}
	}
	
	return isDateString;
}

+ (BOOL)isThisWinningKennelLine:(NSString*)modifiedFileLine
{
	BOOL isWinningKennelLine	= NO;
	NSArray *tokens				= [modifiedFileLine componentsSeparatedByString:@" "];
	
	for(NSUInteger index = 0; index < tokens.count; index++)
	{
		NSString *word = [tokens objectAtIndex:index];
		
		if([self isThisADateString:word])
		{
			isWinningKennelLine = YES;
		}
	}
	
	return isWinningKennelLine;
}


+ (BOOL)doesThisLineContainDateString:(NSString*)line
{
	BOOL answer = NO;
	
	NSArray *tokens = [line componentsSeparatedByString:@" "];
	
	for(NSString *word in tokens)
	{
		if([self isThisADateString:word])
		{
			answer = YES;
			break;
		}
	}
	
	return  answer;
}



@end
