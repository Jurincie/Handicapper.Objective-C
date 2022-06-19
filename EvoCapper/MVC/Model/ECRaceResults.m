//
//  ECRaceResults.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/9/21.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECRaceResults.h"

@implementation ECRaceResults

@synthesize winningTime					= _winningTime;
@synthesize winningPost					= _winningPost;
@synthesize postsFinalPositionArray	= _postsFinalPositionArray;
@synthesize postsFinalTimeArray		= _postsFinalTimeArray;

- (ECRaceResults*)initWithFinalPositionsArray:(NSArray*)finalPositionsByPost
{
	self = [super init];
	
	if(self)
	{
		self.winningPost				= 0;
		self.postsFinalPositionArray	= finalPositionsByPost;
		
		for(NSUInteger index = 0; index < finalPositionsByPost.count; index++)
		{
			if([[finalPositionsByPost objectAtIndex:index] unsignedIntegerValue] == 1)
			{
				self.winningPost = index+ 1;
				break;
			}
		}
	}
	
	return self;
}

@end
