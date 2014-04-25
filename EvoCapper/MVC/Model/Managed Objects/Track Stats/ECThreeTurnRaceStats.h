//
//  ECThreeTurnRaceStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECFarTurnStats, ECFirstTurnStats, ECPostStats, ECTrackStats;

@interface ECThreeTurnRaceStats : NSManagedObject

@property (nonatomic, retain) ECTrackStats *trackStats;
@property (nonatomic, retain) NSOrderedSet *postStats;
@property (nonatomic, retain) NSOrderedSet *firstTurnStats;
@property (nonatomic, retain) NSOrderedSet *farTurnStats;
@end

@interface ECThreeTurnRaceStats (CoreDataGeneratedAccessors)

- (void)insertObject:(ECPostStats *)value inPostStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPostStatsAtIndex:(NSUInteger)idx;
- (void)insertPostStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePostStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPostStatsAtIndex:(NSUInteger)idx withObject:(ECPostStats *)value;
- (void)replacePostStatsAtIndexes:(NSIndexSet *)indexes withPostStats:(NSArray *)values;
- (void)addPostStatsObject:(ECPostStats *)value;
- (void)removePostStatsObject:(ECPostStats *)value;
- (void)addPostStats:(NSOrderedSet *)values;
- (void)removePostStats:(NSOrderedSet *)values;
- (void)insertObject:(ECFirstTurnStats *)value inFirstTurnStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFirstTurnStatsAtIndex:(NSUInteger)idx;
- (void)insertFirstTurnStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFirstTurnStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFirstTurnStatsAtIndex:(NSUInteger)idx withObject:(ECFirstTurnStats *)value;
- (void)replaceFirstTurnStatsAtIndexes:(NSIndexSet *)indexes withFirstTurnStats:(NSArray *)values;
- (void)addFirstTurnStatsObject:(ECFirstTurnStats *)value;
- (void)removeFirstTurnStatsObject:(ECFirstTurnStats *)value;
- (void)addFirstTurnStats:(NSOrderedSet *)values;
- (void)removeFirstTurnStats:(NSOrderedSet *)values;
- (void)insertObject:(ECFarTurnStats *)value inFarTurnStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFarTurnStatsAtIndex:(NSUInteger)idx;
- (void)insertFarTurnStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFarTurnStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFarTurnStatsAtIndex:(NSUInteger)idx withObject:(ECFarTurnStats *)value;
- (void)replaceFarTurnStatsAtIndexes:(NSIndexSet *)indexes withFarTurnStats:(NSArray *)values;
- (void)addFarTurnStatsObject:(ECFarTurnStats *)value;
- (void)removeFarTurnStatsObject:(ECFarTurnStats *)value;
- (void)addFarTurnStats:(NSOrderedSet *)values;
- (void)removeFarTurnStats:(NSOrderedSet *)values;
@end
