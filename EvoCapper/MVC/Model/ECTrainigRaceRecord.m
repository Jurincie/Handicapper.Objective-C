//
//  ECTrainigRaceRecord.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/13/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECTrainigRaceRecord.h"

@implementation ECTrainigRaceRecord

@synthesize postEntries		= _postEntries;
@synthesize trackName		= _trackName;
@synthesize raceDate		= _raceDate;
@synthesize raceClass		= _raceClass;
@synthesize raceDistance	= _raceDistance;
@synthesize winningPost		= _winningPost;
@synthesize racePayout		= _racePayout;

- (ECTrainigRaceRecord*)initRecordAtTrack:(NSString*)trainingTrackName
							   onRaceDate:(NSDate*)trainingRaceDate
							forRaceNumber:(NSUInteger)trainingRaceNumber
							  inRaceClass:(NSString*)trainingRaceClass
						   atRaceDiatance:(NSUInteger)trainingRaceDistance
						  withWinningPost:(NSUInteger)trainingRaceWinningPost
				 andEntryNamesByPostArray:(NSArray*)entrieNamesArray
						resultingInPayout:(ECRacePayouts*)trainingRacePayout
{
	self = [super init];
	
	if(self)
	{
		self.postEntries	= entrieNamesArray;
		self.trackName		= trainingTrackName;
		self.raceDate		= trainingRaceDate;
		self.raceClass		= trainingRaceClass;
		self.raceDistance	= trainingRaceDistance;
		self.winningPost	= trainingRaceWinningPost;
		self.racePayout		= trainingRacePayout;
	}
	
	return self;
}

@end
