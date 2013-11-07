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
@synthesize postNames					= _postNames;
@synthesize postWinOdds					= _postWinOdds;
@synthesize entrysStrengthsFieldsArray	= _entrysStrengthsFieldsArray;
//@synthesize results						= _results;

- (id)initFromResultsFileSubstring:(NSString*)resultsFileSubstring
{
	ECRaceRecord *raceRecord = [super init];
	
	if(raceRecord)
	{
	
	}
	
	return raceRecord;
}

@end
