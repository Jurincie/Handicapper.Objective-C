//
//  General.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/26/21.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#ifndef EvoCapper_General_h
#define EvoCapper_General_h

/////////////////
// Race Tracks //
/////////////////

/* IGNORE tracks below:

**
AD
CC	Corpus Christi		Corpus Christi, Texas
DP	Dairyland			Kenosha, Wisconsin
EG
HO	Hollywood?
IS
JC	Jefferson County	Monticello, Florida
MH	Mile High			Commerce City, Colorado		CLOSED
PE	Pensecola			Psnsecola, Florida
PH	Phoenix				Phoenix, Arizona			CLOSED
PU	Pueblo				Pueblo, Colorado
PN
SE
TP
VL
WO	Wonderland			Revevre, Massachusetts
WS	Woodlands			Kansas City, Kansas
WT

*/

/* Tracks modeled via pastLines

BR		Bluff's Run		Council Bluffs, Iowa
BM		Birmingham		Birmingham, Alabama
CA		Caliente		Mexico
DU		Dubuque			Dubuque, Iowa
LI		Lincoln			Lincoln, Rhode Island
MO		Mobile			Alabama
RT		Raynham-Taunton	Raynham, Massachusetts
SN
SP		St. Petersberg	Florida
TU		Tucson			Arizona
VG		Victory-Land	Alabama						CLOSED
 
*/

/* Tracks modeled via resultsFiles

DB		Daytona Beach		Daytona Beach, Florida
EB		Ebro				Ebro, Florida
FL		Flagler				Miami, Florida
GG		Gulf				Lamarque, Texas
MG		Mardi-Gras			Hallandale, Florida
NF		Naples-Fort Meyers	Bonita Springs, Florida
OP		Orange Park			Orange Park, Florida
PB		Palm Beach			West Palm Beach, Florica
SO		Sanford-Orlando		Longwood, Florida
SA		Sarasota			Sarasota, Florida
SL		Southland			West Memphis, Arkansas
TS		Tri-State			Cross Lanes, West-Virginia
WD		Wheeling			Wheeling, West Virginia

*/

/* SP	Derby Lane			St. Petersburg, Florida


/////////////////////////
// Class Strength Tree //
/////////////////////////

Tree 0: raceClassStrength
With Variables:
averageWinningTimeForDistance,
averageShowTimeForDistance,
bestTimeForDistance

///////////////////////////////
// Past Line Relevance Trees //
///////////////////////////////

Tree1: earlySpeedRelevance
With Variables:
daysSincePastRace,
postDiff, 0
classDiff,
sameTrack

Tree2: otherRelevance
With Variables:
daysSincePastRace,
classDiff,
sameTrack

/////////////////////////////
// Past Line Section Trees //
/////////////////////////////

Tree3: breakPositionStrength
 with Variables:
(breakPosition - postBreakPositionAverage),
(winningTime - recordTimeForDx),
classStrength

Tree4: earlySpeedStrength
 with Variables:
(1stTurnPosition - breakPosition - avgImprovementFromBreakPositionToFirstTurn),
(winningTime - recordTimeForDx),
classStrength

ree5: midtrackSpeedStrength
 with Variables:
(farTurnPosition - firstTurnPosition - avgImprovementFromFirstTurnPositionToFarTurn,
 (winningTime - recordTimeForDx),
 classStrength
 
Tree6: lateSpeedStrength
with Variables:
 (finalPosition - farTurnPosition - avgImprovementFromFarTurnPositionToFinal),
 (winningTime - recordTimeForDx),
 classStrength
 
Tree7: overallClassStrength
 with Variables:
 (finalPosition[post-1] - avgFinalPositionForPostAtDx),
 (finalTime - winningTime) + 1.0,
 winningTime,
 classStrength
 
 ///////////////////////////
 // Race Simulation Trees //
 ///////////////////////////
 
 Tree8: raceToFirstTurnStrength
 with Variables:
 breakDistance[post-1],
 breakSpeed[post-1],
 earlySpeedStrength[post-1],
 numberPathsCrossed + 1,
 numberDogsAhead [post-1] + 1,
 collisionPropensity[post-1] + 1
 
 Tree9: raceToFarTurnStrength
 with Variables:
 firstTurnDistance[post-1],
 midtrackSpeedStrength[post-1],
 numberDogsAhead [post-1] + 1,
 collisionPropensity[post-1] + 1
 
 Tree10: raceToFinalStrength
 with Variables:
 farTurnDistance[post-1],
 lateSpeedStrength[post-1],
 numberDogsAhead [post-1] + 1,
 collisionPropensity[post-1] + 1
 
 ///////////////////////
 // Bet Strength Tree //
 ///////////////////////
 
 Tree11: betStrength
 with Variables:
 finalDistance[post-1],
 classStrength[post-1],
 odds[post-1],
 daysSinceLastRace[post-1]
 (could track how each entry did against other dogs in this race, when they met before) previousMeetingStrength ??
*/

#endif
