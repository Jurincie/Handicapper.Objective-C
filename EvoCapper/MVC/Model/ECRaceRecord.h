//
//  RaceRecord.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/2/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECRaceResults.h"	
#import "ECRacePayouts.h"

@interface ECRaceRecord : NSObject

@property (nonatomic, strong)	NSArray			*entrysStrengthsFieldsArray;
@property (nonatomic, strong)	NSString		*trackName;
@property (nonatomic, strong)	NSDate			*raceDate;
@property (nonatomic, strong)	NSString		*raceClass;
@property (nonatomic, strong)	NSArray			*postEntries;
@property (nonatomic, strong)	NSArray			*postWinOdds;
@property (assign)				NSUInteger		raceDistance;
@property (nonatomic, strong)	ECRaceResults	*results;
@property (nonatomic, strong)	ECRacePayouts	*payouts;


- (id)initRaceRecordAtTrack:(NSString*)trackName
					 onDate:(NSDate*)trainingRaceDate
					 withWinningTime:(double)winningTime
			  forRaceNumber:(NSUInteger)raceNumber
			   forRaceClass:(NSString*)raceClass
			 atRaceDiatance:(NSUInteger)raceDistance
		  andEntriesAtPosts:(NSArray*)entrieNamesArray
		   usingOddsAtPosts:(NSArray*)postOddsArray;

@end
