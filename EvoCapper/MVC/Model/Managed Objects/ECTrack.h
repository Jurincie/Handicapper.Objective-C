//
//  ECTrack.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/21/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECDistanceClassStats, ECPopulation;

@interface ECTrack : NSManagedObject

@property (nonatomic, retain) NSString		*trackName;
@property (nonatomic, retain) NSSet			*trackStatistics;
@property (nonatomic, retain) ECPopulation	*population;
@end

@interface ECTrack (CoreDataGeneratedAccessors)

- (void)addTrackStatisticsObject:(ECDistanceClassStats *)value;
- (void)removeTrackStatisticsObject:(ECDistanceClassStats *)value;
- (void)addTrackStatistics:(NSSet *)values;
- (void)removeTrackStatistics:(NSSet *)values;

@end
