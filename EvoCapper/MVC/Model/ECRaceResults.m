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
@synthesize postsFinishPositionArray	= _postsFinishPositionArray;
@synthesize postsFinishTimeArray		= _postsFinishTimeArray;

- (ECRaceResults*)initWithFinishPositionsArray:(NSArray*)finishPositionsByPost
							andFinishTimeArray:(NSArray*)finishTimesByPost
{
	self = [super init];
	
	if(self)
	{
		self.postsFinishPositionArray	= finishPositionsByPost;
		self.postsFinishTimeArray		= finishTimesByPost;
		
		NSUInteger winningPost = 0;
		
		for(NSUInteger index = 0; index < finishTimesByPost.count; index++)
		{
			if([[finishPositionsByPost objectAtIndex:index] integerValue] == 1)
			{
				winningPost = index+1;
				break;
			}
		}
		
		self.winningTime = [[self.postsFinishTimeArray objectAtIndex:winningPost] doubleValue];
	}
	
	return self;
}

@end
