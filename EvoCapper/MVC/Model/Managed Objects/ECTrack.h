//
//  ECTrack.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/25/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECPopulation, ECTrackStats;

@interface ECTrack : NSManagedObject

@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) ECPopulation *population;
@property (nonatomic, retain) NSOrderedSet *trackRaceDistanceStats;
@end

@interface ECTrack (CoreDataGeneratedAccessors)

- (void)insertObject:(ECTrackStats *)value inTrackRaceDistanceStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTrackRaceDistanceStatsAtIndex:(NSUInteger)idx;
- (void)insertTrackRaceDistanceStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTrackRaceDistanceStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTrackRaceDistanceStatsAtIndex:(NSUInteger)idx withObject:(ECTrackStats *)value;
- (void)replaceTrackRaceDistanceStatsAtIndexes:(NSIndexSet *)indexes withTrackRaceDistanceStats:(NSArray *)values;
- (void)addTrackRaceDistanceStatsObject:(ECTrackStats *)value;
- (void)removeTrackRaceDistanceStatsObject:(ECTrackStats *)value;
- (void)addTrackRaceDistanceStats:(NSOrderedSet *)values;
- (void)removeTrackRaceDistanceStats:(NSOrderedSet *)values;
@end
