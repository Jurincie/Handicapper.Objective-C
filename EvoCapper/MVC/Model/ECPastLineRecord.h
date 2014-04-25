//
//  ECPastLineRecord.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/14/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPastLineRecord : NSObject

@property (nonatomic, strong)	NSDate		*raceDate;
@property (nonatomic, strong)	NSString	*trackName;
@property (nonatomic, strong)	NSString	*raceClass;
@property (nonatomic, strong)	NSString	*trackConditions;

@property (assign)				NSUInteger	numberEntries;
@property (assign)				double		raceDistance;
@property (assign)				double		weight;
@property (assign)				double		winOdds;

@property (assign)				BOOL		foundTrouble;
@property (assign)				BOOL		isMatinee;
@property (assign)				BOOL		didNotFinal;
@property (assign)				BOOL		ranInside;
@property (assign)				BOOL		ranMidtrack;
@property (assign)				BOOL		ranOutside;
@property (assign)				BOOL		wasScratched;

@property (assign)				double		trapPosition;
@property (assign)				double		breakPosition;
@property (assign)				double		firstTurnPosition;
@property (assign)				double		farTurnPosition;
@property (assign)				double		finalPosition;

@property (assign)				double		deltaPosition1;
@property (assign)				double		deltaPosition2;
@property (assign)				double		deltaPosition3;
@property (assign)				double		deltaLengths1;
@property (assign)				double		deltaLengths2;

@property (assign)				double		lengthsLeadFirstTurn;
@property (assign)				double		lengthsLeadFarTurn;
@property (assign)				double		lengthsLeadFinal;

@property (assign)				double		entryTime;
@property (assign)				double		winningTime;
@property (nonatomic, strong)	NSString	*comments;

@end
