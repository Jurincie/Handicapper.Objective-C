//
//  General.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/26/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#ifndef EvoCapper_General_h
#define EvoCapper_General_h

/////////////////
// Race Tracks //
/////////////////

*  Downloaded Results
^  Downloaded Partial Results (top 3 or 4 finishers)
+  Built dog past performances database
~  Built Track Stats

1.  Birmingham            Alabama			^
2.  Bluffs Run            Iowa				^
3.  Caliente              Mexico
4.  Daytona Beach         Florida			* + ~
5.  Derby Lane            Florida			*
6.  Dubuque               Iowa				*
7.  Ebro                  Florida			* + ~
8.  Flagler               FLorida			* + ~
9.  Gulf                  Texas				* + ~
10. Jefferson County      Florida
11. Mardi Gras            Florida			* + ~
12. Melbourne             Florida
13. Mobile                Alabama
14. Naples-Fort Myers	  Florida			* + ~
15. Orange Park           Florida			* + ~
16. Palm Beach            Florida			* + ~
17. Pensacola             Florida
18. Sanford-Orlando       Florida			* + ~
19. Sarasota              Florida			* + ~
20. Southland             Arkansas			* + ~
21. Tri-State             West Virginia		* + ~
22. Victroryland          Alabama
23. Wheeling              West Virginia		* + ~
 
===> Tracks below cannot be bet at ??.com <===
24. Tucson					Arizona			*



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
With Variables:
(breakPosition - postBreakPositionAverage),
(winningTime - recordTimeForDx),
classStrength

Tree4: earlySpeedStrength
With Variables:
(1stTurnPosition - breakPosition - avgImprovementFromBreakPositionToFirstTurn),
(winningTime - recordTimeForDx),
classStrength

Tree5: midtrackSpeedStrength
With Variables:
(topOfStretchPosition - firstTurnPosition - avgImprovementFromFirstTurnPositionToTopOfStretch,
 (winningTime - recordTimeForDx),
 classStrength
 
 Tree6: lateSpeedStrength
 With Variables:
 (finalPosition - topOfStretchPosition - avgImprovementFromTopOfStretchPositionToFinish),
 (winningTime - recordTimeForDx),
 classStrength
 
 Tree7: overallClassStrength
 With Variables:
 (finalPosition[post-1] - avgFinalPositionForPostAtDx),
 (finalTime - winningTime) + 1.0,
 winningTime,
 classStrength
 
 ///////////////////////////
 // Race Simulation Trees //
 ///////////////////////////
 
 Tree8: raceToFirstTurnStrength
 With Variables:
 breakDistance[post-1],
 breakSpeed[post-1],
 earlySpeedStrength[post-1],
 numberPathsCrossed + 1,
 numberDogsAhead [post-1] + 1,
 collisionPropensity[post-1] + 1
 
 Tree9: raceToTopOfStretchStrength
 With Variables:
 firstTurnDistance[post-1],
 midtrackSpeedStrength[post-1],
 numberDogsAhead [post-1] + 1,
 collisionPropensity[post-1] + 1
 
 Tree10: raceToFinishStrength
 With Variables:
 topOfStretchDistance[post-1],
 lateSpeedStrength[post-1],
 numberDogsAhead [post-1] + 1,
 collisionPropensity[post-1] + 1
 
 ///////////////////////
 // Bet Strength Tree //
 ///////////////////////
 
 Tree11: betStrength
 With Variables:
 finalDistance[post-1],
 classStrength[post-1],
 odds[post-1],
 daysSinceLastRace[post-1]


#endif
