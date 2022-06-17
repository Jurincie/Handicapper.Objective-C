//
//  ECTrackStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 5/3/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECMarathonRaceStats, ECSprintRaceStats, ECThreeTurnRaceStats, ECTracks, ECTwoTurnRaceStats;

@interface ECTrackStats : NSManagedObject

@property (nonatomic, retain) NSNumber * marathonRaceRecordTime;
@property (nonatomic, retain) NSNumber * sprintRaceRecordTime;
@property (nonatomic, retain) NSNumber * threeTurnRaceRecordTime;
@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSNumber * twoTurnRaceRecordTime;
@property (nonatomic, retain) NSString * validRaceClasses;
@property (nonatomic, retain) ECMarathonRaceStats *marathonRaceStats;
@property (nonatomic, retain) ECSprintRaceStats *sprintRaceStats;
@property (nonatomic, retain) ECThreeTurnRaceStats *threeTurnRaceStats;
@property (nonatomic, retain) ECTracks *tracks;
@property (nonatomic, retain) ECTwoTurnRaceStats *twoTurnRaceStats;

@end
