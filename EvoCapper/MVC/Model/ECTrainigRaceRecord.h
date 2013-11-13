//
//  ECTrainigRaceRecord.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/13/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ECRacePayouts.h"

@interface ECTrainigRaceRecord : NSObject

@property (nonatomic, strong)	NSArray			*postEntries;
@property (nonatomic, strong)	NSString		*trackName;
@property (nonatomic, strong)	NSDate			*raceDate;
@property (nonatomic, strong)	NSString		*raceClass;
@property (assign)				NSUInteger		raceDistance;
@property (assign)				NSUInteger		winningPost;
@property (assign)				ECRacePayouts	*racePayout;

- (ECTrainigRaceRecord*)initRecordAtTrack:(NSString*)trainingTrackName
							   onRaceDate:(NSDate*)trainingRaceDate
							forRaceNumber:(NSUInteger)trainingRaceNumber
							  inRaceClass:(NSString*)trainingRaceClass
						   atRaceDiatance:(NSUInteger)trainingRaceDistance
						  withWinningPost:(NSUInteger)trainingRaceWinningPost
					   withEntriesAtPosts:(NSArray*)entrieNamesArray
						resultingInPayout:(ECRacePayouts*)trainingRaceWinningPayout;

@end
