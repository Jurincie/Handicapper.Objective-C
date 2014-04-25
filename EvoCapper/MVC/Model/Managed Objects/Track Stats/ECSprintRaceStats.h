//
//  ECSprintRaceStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECPostStats, ECSprintTurnStats, ECTrackStats;

@interface ECSprintRaceStats : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *postStats;
@property (nonatomic, retain) NSOrderedSet *sprintTurnStats;
@property (nonatomic, retain) ECTrackStats *trackStats;
@end

@interface ECSprintRaceStats (CoreDataGeneratedAccessors)

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
- (void)insertObject:(ECSprintTurnStats *)value inSprintTurnStatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSprintTurnStatsAtIndex:(NSUInteger)idx;
- (void)insertSprintTurnStats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSprintTurnStatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSprintTurnStatsAtIndex:(NSUInteger)idx withObject:(ECSprintTurnStats *)value;
- (void)replaceSprintTurnStatsAtIndexes:(NSIndexSet *)indexes withSprintTurnStats:(NSArray *)values;
- (void)addSprintTurnStatsObject:(ECSprintTurnStats *)value;
- (void)removeSprintTurnStatsObject:(ECSprintTurnStats *)value;
- (void)addSprintTurnStats:(NSOrderedSet *)values;
- (void)removeSprintTurnStats:(NSOrderedSet *)values;
@end
