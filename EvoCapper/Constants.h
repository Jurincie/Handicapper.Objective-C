//
//  Constants.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/25/13.
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
// post->time
// break->1st Turn
// 1stTurn->farTurn     ==> sprint races do NOT use this field
// farTurn->finsh       ==> sprint races use this field for 1stTurn => final

enum trackStatFields
{
    kBreakPositionFromPostStatField = 0,
    kFirstTurnPositionFromPostStatField,
    kFarTurnPositionFromFirstTurnPositionStatField,
    kFinalPositionFromPostStatField,
    kFinalTimeFromPostStatField,
    kFirstTurnPositionFromBreakPositionStatField,
    kFarTurnhPositionFromFirstTurnStatField,
    kFinalPositionFromFarTurnStatField
};

#define kNumberStatFields 8

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
    kClassDnaStrand = 0,
    kBreakPositionDnaStrand,
    kFirstTurnPositionDnaStrand,
    kFarTurnPositionDnaStrand,
    kFinalPositionDnaStrand,
    kBettingDnaStrand,
    kEarlySpeedRelevanceDnaStrand,
    kOtherRelevanceDnaStrand
};

#define kNumberDnaStrands 8

#define kNoIndex 999
#define kNoConstant 999.999
#define kMaximumPopulationSize 1024
#define kMaximumTreeDepth 16
#define kTopMinimumTreeDepth 10
#define kMaximumMutationRate .0099

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
#define kRandomGranularity 8
#define kLowestTolerableValue 1.0 / pow(10,kRandomGranularity)

#define kTreeRoot 0

// tree helpers
#define kFunctionNode   0
#define kVariableNode   1
#define kConstantNode   2
#define kBooleanNode    3
#define kUndefinedNode  999

// Relevance Tree vals
#define kMinLevelForRelevanceTrees 3
#define kMaxLevelForRelevanceTrees 5


#endif
