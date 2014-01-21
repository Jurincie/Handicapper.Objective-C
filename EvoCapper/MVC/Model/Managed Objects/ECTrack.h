//
//  ECTrack.h
//  EvoCapper
//
//  Created by Ron Jurincie on 1/21/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECClassStats, ECPopulation;

@interface ECTrack : NSManagedObject

@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) ECPopulation *population;
@property (nonatomic, retain) NSOrderedSet *raceDistanceStats;
@property (nonatomic, retain) NSOrderedSet *classStats;
@end

@interface ECTrack (CoreDataGeneratedAccessors)

- (void)insertObject:(ECClassStats *)value inRaceDistanceStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRaceDistanceStatsAtIndex:(NSUInteger)idx;
- (void)insertRaceDistanceStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRaceDistanceStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRaceDistanceStatsAtIndex:(NSUInteger)idx withObject:(ECClassStats *)value;
- (void)replaceRaceDistanceStatsAtIndexes:(NSIndexSet *)indexes withRaceDistanceStats:(NSArray *)values;
- (void)addRaceDistanceStatsObject:(ECClassStats *)value;
- (void)removeRaceDistanceStatsObject:(ECClassStats *)value;
- (void)addRaceDistanceStats:(NSOrderedSet *)values;
- (void)removeRaceDistanceStats:(NSOrderedSet *)values;
- (void)insertObject:(ECClassStats *)value inClassStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromClassStatsAtIndex:(NSUInteger)idx;
- (void)insertClassStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeClassStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInClassStatsAtIndex:(NSUInteger)idx withObject:(ECClassStats *)value;
- (void)replaceClassStatsAtIndexes:(NSIndexSet *)indexes withClassStats:(NSArray *)values;
- (void)addClassStatsObject:(ECClassStats *)value;
- (void)removeClassStatsObject:(ECClassStats *)value;
- (void)addClassStats:(NSOrderedSet *)values;
- (void)removeClassStats:(NSOrderedSet *)values;
@end
