//
//  ECRaceClass.h
//  EvoCapper
//
//  Created by Ron Jurincie on 2/7/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECTrackStats;

@interface ECRaceClass : NSManagedObject

@property (nonatomic, retain) NSString * raceClassName;
@property (nonatomic, retain) ECTrackStats *trackStats;

@end
