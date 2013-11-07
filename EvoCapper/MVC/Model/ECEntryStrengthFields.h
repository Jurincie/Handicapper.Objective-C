//
//  ECEntryStrengthFields.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/7/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//
// this class allows us to build up the strength fields for each entry
// as we iterate through their pastLines

#import <Foundation/Foundation.h>

@interface ECEntryStrengthFields : NSObject

@property (assign) double breakPositionStrength;
@property (assign) double breakSpeedStrength;
@property (assign) double earlySpeedStrength;
@property (assign) double topSpeedStrength;
@property (assign) double lateSpeedStrength;
@property (assign) double recentlassStrength;
@property (assign) double insideOutsidePreference;
@property (assign) double collisionPropensity;

@end
