//
//  ECRaceResults.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/9/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECRaceResults.h"

@implementation ECRaceResults

@synthesize winningTime					= _winningTime;
@synthesize winningPost					= _winningPost;
@synthesize postsFinishPositionArray	= _postsFinishPositionArray;
@synthesize postsFinishTimeArray		= _postsFinishTimeArray;

- (ECRaceResults*)initWithFinishPositionsArray:(NSArray*)finishPositionsByPost
{
	self = [super init];
	
	if(self)
	{
		self.winningPost				= 0;
		self.postsFinishPositionArray	= finishPositionsByPost;
		
		for(NSUInteger index = 0; index < finishPositionsByPost.count; index++)
		{
			if([[finishPositionsByPost objectAtIndex:index] unsignedIntegerValue] == 1)
			{
				self.winningPost = index+ 1;
				break;
			}
		}
	}
	
	return self;
}

@end
