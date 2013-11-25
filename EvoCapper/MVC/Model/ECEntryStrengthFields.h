//
//  ECEntryStrengthFields.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/15/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECEntryStrengthFields : NSObject

@property (assign) double		breakPositionStrength;
@property (assign) double		breakSpeedStrength;
@property (assign) double		earlySpeedStrength;
@property (assign) double		topSpeedStrength;
@property (assign) double		lateSpeedStrength;
@property (assign) double		recentClassStrength;
@property (assign) double		earlySpeedRelevanceFactor;
@property (assign) double		otherRelevanceFactor;
@property (assign) NSUInteger	numberPastLinesUsed;
@property (assign) double		numberInsideComments;
@property (assign) double		numberOutsideComments;
@property (assign) NSUInteger	numberCollisionComments;

@end
