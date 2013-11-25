//
//  ECTopOfStretchStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/25/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECTrackStats;

@interface ECTopOfStretchStats : NSManagedObject

@property (nonatomic, retain) NSNumber		*averagePositionFinish;
@property (nonatomic, retain) NSNumber		*topOfStretchPosition;
@property (nonatomic, retain) ECTrackStats	*trackRaceDistanceStats;

@end
