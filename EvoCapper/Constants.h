//
//  Constants.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/25/21.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.

#ifndef EvoCapper_Constants_h
#define EvoCapper_Constants_h

enum trackRaceTypes
{
    kSprintRace = 0,
    kTwoTurnRace,
    kThreeTurnRace,
    kMarathonRace
};

#define kNumberRaceDistances 4

// post->break
// post->1stTurn
// post->final
// break->1st Turn
// 1stTurn->farTurn     ==> sprint races do NOT use this field (except BM and DQ)
// farTurn->finsh       ==> sprint races use this field for sprintTurn => final

#define kFinalPositionFromSprintTurn 5

enum trackStatFields
{
    kBreakPositionFromTrapPositionStatField = 0,
    kFirstTurnPositionFromTrapPositionStatField,
    kFinalPositionFromTrapPositionStatField,
    kFirstTurnPositionFromBreakStatField,
    kFarTurnPositionFromFirstTurnStatField,
    kFinalPositionFromFarTurnStatField
};

#define kNumberStatFields 6

enum cFunctions
{
    kAdditionIndex = 0,
    kSubtractionIndex,
    kMultiplicationIndex,
    kDivisionIndex,
    kSquareRootIndex,
    kSquareIndex,
    kNaturalLogIndex,
    kReciprocalIndex
};

#define kNumberFunctions 8
#define kNumberTwoArgFuncs 4

enum dnaStrands
{
    // 0 - 1 are relevance trees
    kEarlySpeedRelevanceDnaStrand,      // used for breakSpeed and speedToFirstTurn relevance (NO post diff)
    kOtherRelevanceDnaStrand,           // used for (uses post diff)
    
    // 2 - 6 accumulated values * relevance
    kBreakStrengthDnaStrand,
    kSpeedToFirstTurnDnaStrand,
    kMidtrackSpeedDnaStrand,        // NOT for sprint races
    kLateSpeedDnaStrand,
    kRecentClasshDnaStrand,         // accumulates values via past lines

    // 7 - 9 are race simulation trees, using previously generated values above
    
    // Break Positions are derived directly from kBreakStrengthDnaStrand then normalized
    kRaceToFirstTurnStrengthDnaStrand,  // each entry has dx <= firstTurnDx
    kRaceToFarTurnStrengthDnaStrand,    // NOT for sprint races (each entry has dx <= farTurnDx)
    kRaceToFinishStrengthDnaStrand,     // ==> final distance (each entry has finalDx <= raceDx)
    
    // 10 uses final distance from above, along with other variables
    //  to generate a bettingStrengthValue, used in all betting formulas
    kBettingStrengthDnaStrand
};

#define kNumberDnaStrands 11

#define kNoIndex 9999999
#define kNoConstant .9999999
#define kMaximumPopulationSize 1024
#define kMaximumTreeDepth 16
#define kTopMinimumTreeDepth 10
#define kMaximumMutationRate .00999

// define reprocuction type AND fitness selection method
#define kLinearFitnessSelection 0
#define kSuaredFitnessSelection 1

enum reproductionMethod
{
    kMonogomousPairsMethod = 0,
    kAlphasDominateMethod,
    kOrgyMethod
};

#define kSelectionMethod kSuaredFitnessSelection
#define kReproductionType kMonogomousPairsMethod

#define kMaximumNumberEntries 9
#define kRandomRange 2.0
#define kRandomGranularity 6
#define kLowestTolerableValue 1.0 / pow(10,kRandomGranularity)

#define kTreeRoot 0

// tree helpers
#define kFunctionNode   0
#define kVariableNode   1
#define kConstantNode   2
#define kBooleanNode    3
#define kUndefinedNode  9999999

// Relevance Tree vals
#define kMinLevelForRelevanceTrees 3
#define kMaxLevelForRelevanceTrees 5


#endif
