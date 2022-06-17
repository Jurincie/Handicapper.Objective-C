//
//  ECTracks.h
//  EvoCapper
//
//  Created by Ron Jurincie on 5/3/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECTrackStats;

@interface ECTracks : NSManagedObject

@property (nonatomic, retain) NSSet *trackStats;
@end

@interface ECTracks (CoreDataGeneratedAccessors)

- (void)addTrackStatsObject:(ECTrackStats *)value;
- (void)removeTrackStatsObject:(ECTrackStats *)value;
- (void)addTrackStats:(NSSet *)values;
- (void)removeTrackStats:(NSSet *)values;

@end
