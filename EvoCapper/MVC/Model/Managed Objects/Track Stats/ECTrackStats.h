//
//  ECTrackStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 1/30/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECClassStats, ECPopulation, ECRaceClass, ECRaceDistanceStats;

@interface ECTrackStats : NSManagedObject

@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSOrderedSet *classStats;
@property (nonatomic, retain) ECPopulation *population;
@property (nonatomic, retain) NSOrderedSet *raceClasses;
@property (nonatomic, retain) NSOrderedSet *raceDistanceStats;
@end

@interface ECTrackStats (CoreDataGeneratedAccessors)

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
- (void)insertObject:(ECRaceClass *)value inRaceClassesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRaceClassesAtIndex:(NSUInteger)idx;
- (void)insertRaceClasses:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRaceClassesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRaceClassesAtIndex:(NSUInteger)idx withObject:(ECRaceClass *)value;
- (void)replaceRaceClassesAtIndexes:(NSIndexSet *)indexes withRaceClasses:(NSArray *)values;
- (void)addRaceClassesObject:(ECRaceClass *)value;
- (void)removeRaceClassesObject:(ECRaceClass *)value;
- (void)addRaceClasses:(NSOrderedSet *)values;
- (void)removeRaceClasses:(NSOrderedSet *)values;
- (void)insertObject:(ECRaceDistanceStats *)value inRaceDistanceStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRaceDistanceStatsAtIndex:(NSUInteger)idx;
- (void)insertRaceDistanceStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRaceDistanceStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRaceDistanceStatsAtIndex:(NSUInteger)idx withObject:(ECRaceDistanceStats *)value;
- (void)replaceRaceDistanceStatsAtIndexes:(NSIndexSet *)indexes withRaceDistanceStats:(NSArray *)values;
- (void)addRaceDistanceStatsObject:(ECRaceDistanceStats *)value;
- (void)removeRaceDistanceStatsObject:(ECRaceDistanceStats *)value;
- (void)addRaceDistanceStats:(NSOrderedSet *)values;
- (void)removeRaceDistanceStats:(NSOrderedSet *)values;
@end
