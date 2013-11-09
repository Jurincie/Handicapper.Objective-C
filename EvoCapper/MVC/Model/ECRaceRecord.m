//
//  RaceRecord.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/2/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECRaceRecord.h"

@implementation ECRaceRecord

@synthesize trackName					= _trackName;
@synthesize raceDate					= _raceDate;
@synthesize raceClass					= _raceClass;
@synthesize raceDistance				= _raceDistance;
@synthesize postEntries					= _postEntries;
@synthesize postWinOdds					= _postWinOdds;
@synthesize entrysStrengthsFieldsArray	= _entrysStrengthsFieldsArray;
@synthesize results						= _results;
@synthesize payouts						= _payouts;

- (id)initRaceRecordAtTrack:(NSString*)trackName
					 onDate:(NSDate*)trainingRaceDate
			  forRaceNumber:(NSUInteger)raceNumber
			   forRaceClass:(NSString*)raceClass
			 atRaceDiatance:(NSUInteger)raceDistance
		  andEntriesAtPosts:(NSArray*)postEntriesArray
		   usingOddsAtPosts:(NSArray*)postOddsArray
{
	ECRaceRecord *newRaceRecord = [super init];
	
	if(newRaceRecord)
	{
		newRaceRecord.trackName		= trackName;
		newRaceRecord.raceDate		= trainingRaceDate;
		newRaceRecord.raceClass		= raceClass;
		newRaceRecord.raceDistance	= raceDistance;
		newRaceRecord.postEntries	= postEntriesArray;
		newRaceRecord.postWinOdds	= postOddsArray;
	}
	
	return newRaceRecord;
}

@end
