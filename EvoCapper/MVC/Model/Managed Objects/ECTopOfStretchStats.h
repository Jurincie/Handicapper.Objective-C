//
//  ECTopOfStretchStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/21/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECDistanceClassStats;

@interface ECTopOfStretchStats : NSManagedObject

@property (nonatomic, retain) NSNumber * averagePositionFinish;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) ECDistanceClassStats *distanceClassStats;

@end
