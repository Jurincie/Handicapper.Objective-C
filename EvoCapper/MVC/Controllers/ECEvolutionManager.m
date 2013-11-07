//
//  ECEvolutionManager.m
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

// Since we only want (1) EvolutionManager Ever to be created
// We have made this class a singleton

#import "ECEvolutionManager.h"
#import "ECPopulation.h"

#define MOC [[NSApp delegate]managedObjectContext]

@implementation ECEvolutionManager

@synthesize currentPopSize					= _currentPopSize;
@synthesize population                      = _population;
@synthesize generationsEvolved				= _generationsEvolved;
@synthesize trainingGenerationsThisCycle	= _trainingGenerationsThisCycle;
@synthesize workingPopulationDna			= _workingPopulationDna;
@synthesize rankedPopulation				= _rankedPopulation;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static ECEvolutionManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{sharedManager = [[self alloc] init];});
    
    return sharedManager;
}

- (id)init
{
    NSLog(@"ECEVolutionManager.init called");
    
    if (self = [super init])
    {
        // seed random number generator here ONLY
        time_t seed = time(NULL);
        srand((unsigned) time(&seed));
        
        self.population = nil;
    }
    
    return self;
}

#pragma custom class methods

- (void)createNewPopoulationWithName:(NSString*)name
						 initialSize:(NSUInteger)initialSize
						maxTreeDepth:(NSUInteger)maxTreeDepth
						minTreeDepth:(NSUInteger)mintreeDepth
                        mutationRate:(float)mutationRate
                            comments:(NSString*)comments

{
    NSLog(@"createNewPopulation called in ECEvolutionManager");
	
	self.generationsEvolved = [self.population.generationNumber integerValue];
    self.population			= [NSEntityDescription insertNewObjectForEntityForName:@"HandicapperPopulation"
															inManagedObjectContext:MOC];
	self.currentPopSize		= [self.population.initialSize integerValue];
	
    if(self.population)
    {
		self.population.populationName  = @"NewPopulationTest 1.0.0.0";
        self.population.initialSize     = [NSNumber numberWithInteger:initialSize];
        self.population.minTreeDepth    = [NSNumber numberWithInteger:mintreeDepth];
        self.population.maxTreeDepth    = [NSNumber numberWithInteger:maxTreeDepth];
        self.population.genesisDate     = [NSDate date];
        self.population.mutationRate    = [NSNumber numberWithFloat:mutationRate];
		
		self.rankedPopulation = [self createNewHandicappers];
		
        [self fillWorkingPopulationArrayWithOriginalMembers];
    }
}


- (void)fillWorkingPopulationArrayWithOriginalMembers
{
	// fill the workingPopulationMembersDna with
	// arrays of each members trees created from their string form
	self.workingPopulationDna	= [NSMutableArray new];
	NSMutableArray *dnaTrees	= [NSMutableArray new];

	for(int popIndex = 0; popIndex < [self.population.initialSize integerValue]; popIndex++)
	{
		ECHandicapper *tempHandicapper	= self.rankedPopulation[popIndex];
		NSArray *thisMembersDnaTrees	= [NSArray arrayWithObjects:[self recoverTreeFromString:tempHandicapper.breakPositionTree],
																	[self recoverTreeFromString:tempHandicapper.breakSpeedTree],
																	[self recoverTreeFromString:tempHandicapper.earlySpeedTree],
																	[self recoverTreeFromString:tempHandicapper.topSpeedTree],
																	[self recoverTreeFromString:tempHandicapper.lateSpeedTree],
																	[self recoverTreeFromString:tempHandicapper.recentClassTree],
																	[self recoverTreeFromString:tempHandicapper.earlySpeedRelevanceTree],
																	[self recoverTreeFromString:tempHandicapper.otherRelevanceTree], nil];
				
		[dnaTrees addObject:thisMembersDnaTrees];
   }
   
	self.workingPopulationDna = [dnaTrees copy];
}

- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations
{
	if(nil == self.population)
	{
		// use NSAlert to deal with this
		NSAlert *alert          = [[NSAlert alloc] init];
		NSString *question      = NSLocalizedString(@"Create New Population",
													@"Cancel");
		NSString *info			= NSLocalizedString(@"No population has been selected.",
												@"Would you like to create new Population now?");
		NSString *quitButton    = NSLocalizedString(@"Yes, create a new population", @"Create population button title");
		NSString *cancelButton  = NSLocalizedString(@"No", @"Cancel button title");
		
		[alert setMessageText:question];
		[alert setInformativeText:info];
		[alert addButtonWithTitle:quitButton];
		[alert addButtonWithTitle:cancelButton];
		
		NSInteger answer = [alert runModal];
	
		if (answer == NSAlertDefaultReturn)
        {
			return;
        }
		else
		{
			self.rankedPopulation = [self createNewHandicappers];
		}
	}

    NSLog(@"trainPopulation called in ECEvolutionManager");
	
	self.trainingGenerationsThisCycle = numberGenerations;
    
    for(NSUInteger localGenNumber = 0; localGenNumber < numberGenerations; localGenNumber++)
    {
        [self testPopulation:self.population
			includingParents:localGenNumber > 0 ? NO : YES
	   withResultFilesAtPath:nil];
    
        [self createNextGenerationForPopulation:self.population];
		
	    [self mutateChildrenForPopulation:self.population];
    }
    
    [self updateAndSaveData];
}


   
- (void)testPopulation:(ECPopulation*)population
	  includingParents:(BOOL)parentsToo
 withResultFilesAtPath:(NSString *)path
{
	// self.workingPopulation array MUST be sorted at this point with:
	//	chldren occupying BOTTOM HALF of array with their indices

	NSUInteger startIndex = (parentsToo == TRUE) ? 0 : self.currentPopSize / 2;
		
    // iterate all subdirectories inside kResultsFolderPath
	NSString *tempPath = nil;
	
    while(1)
    {
		if([self isThisADirectory:tempPath] == TRUE)
		{
			[self testPopulation:population
			   includingParents:parentsToo
		   withResultFilesAtPath:tempPath];
			  
			  return;
		}
		
		NSArray *raceRecordsForThisEvent = [self getRaceRecordsForResultsFileAtPath:tempPath];
		
		for(ECRaceRecord *tempRaceRecord in raceRecordsForThisEvent)
		{
			NSUInteger winningPost	= [self getWinningPostFromRaceRecord:tempRaceRecord];
			NSArray *winBetsArray	= [self getWinPredictionsFromPopulation:population
																	forRace:tempRaceRecord
															startingAtIndex:startIndex];
								
			// iterate handicappers array
			for(NSUInteger index = startIndex; index < self.currentPopSize; index++)
			{
				ECHandicapper *tempHandicapper	= [self.workingPopulationDna objectAtIndex:index];
				int incrementedTotal			= (int)[tempHandicapper.numberWinBets integerValue] + 1;
				tempHandicapper.numberWinBets	= [NSNumber numberWithInt:incrementedTotal];
				
				if(winningPost == [[winBetsArray objectAtIndex:index] integerValue])
				{
					int incrementedTotal				= (int)[tempHandicapper.numberWinBetWinners integerValue] + 1;
					tempHandicapper.numberWinBetWinners	= [NSNumber numberWithInt:incrementedTotal];
				}
			}
		}
    }
}

- (BOOL)isThisADirectory:(NSString*)path
{
	// FIX:
	BOOL answer = NO;
	
	return answer;
}

- (NSUInteger)getWinningPostFromRaceRecord:(ECRaceRecord*)thisRaceRecord
{
	NSUInteger winningPost = 0;
	
	return winningPost;
}

- (NSArray*)getRaceRecordsForResultsFileAtPath:(NSString*)resultsFileAtPath
{
	NSArray *raceRecordsArray = nil;
	
	return raceRecordsArray;
}

- (NSArray*)getWinPredictionsFromPopulation:(ECPopulation*)population
									forRace:(ECRaceRecord*)thisRaceRecord
							startingAtIndex:(NSUInteger) startIndex
{
	NSMutableArray *winBetsArray = [NSMutableArray new];
	
	for(NSUInteger index = startIndex; index < self.currentPopSize; index++)
	{
		//Handicapper *tempHandicapper = [self.workingPopulationMembersDna objectAtIndex:index];
	
		// FIX: get actual prediction
		int  predictedPostOfWinner = rand();
	
		[winBetsArray addObject:[NSNumber numberWithInt:predictedPostOfWinner]];
    }
	
	return winBetsArray;
}

                       
- (void)createNextGenerationForPopulation:(ECPopulation*)testPopulation
{
   	// increment generation counter
	NSNumber *incrementedGenNumber		= [NSNumber numberWithInt:(int)[self.population.generationNumber integerValue] + 1];
	self.population.generationNumber	= incrementedGenNumber;
	
	// rerank population
	[self sortRankedPopulation];
	
	// remove and release worst performing half of pop
	// and replace them with children crossed over by best performing half
	[self replaceBottomHalfOfPopulationWithNewChildren];
}

- (void)sortRankedPopulation
{
	// sort population
	// sort rankedPopulation based on numberOfWinBetWinners (for now)
	NSSortDescriptor *discript	= [[NSSortDescriptor alloc] initWithKey:@"numberOfWinBetWinners"
																		  ascending:YES];
	NSArray *descriptorArray	= [NSArray arrayWithObjects:discript, nil];
	NSArray *rankedArray		= [self.rankedPopulation sortedArrayUsingDescriptors:descriptorArray];
	
	[self.rankedPopulation removeAllObjects];
	[self.rankedPopulation addObjectsFromArray:rankedArray];
}

- (void)replaceBottomHalfOfPopulationWithNewChildren
{
	NSInteger halfwayIndex = self.currentPopSize / 2;

    // iterate bottom half of rankedPopulation removing all handicappers
	for(NSInteger index = self.currentPopSize - 1; index >= halfwayIndex; index--)
	{
		ECHandicapper *dyingHandicapper = [self.rankedPopulation objectAtIndex:index];
		
		// remove handicapper from rankedPopulationArray
		[self.rankedPopulation removeObject:dyingHandicapper];
		
		// remove dyingHandicapper managedObject from data store
		[MOC deleteObject:dyingHandicapper];
	}
	
	// create new bottom half of rankedPop by crossing over dnaTrees form remaining half of pop
	for(NSInteger index = halfwayIndex ; index < self.currentPopSize; index++)
	{
		ECHandicapper *newHandicapper = [self createNewHandicapperForPopulation:self.population
																forGeneration:(int)self.population.generationNumber];
				
		[self.rankedPopulation addObject:newHandicapper];
	}
}

- (ECHandicapper*)createNewHandicapperForPopulation:(ECPopulation*)population
							forGeneration:(NSUInteger)birthGeneration
{
	// get 2 UNIQUE parents
	// based on selection method
	double summedFitnessForPopulation = 0.0;
	switch (kSelectionMethod)
	{
		case kSuaredFitnessSelection:
			// FIX: not implemented
			// simply skip to kLinearFitnessSelection
			
		case kLinearFitnessSelection:
		{
			for(NSUInteger popIndex = 0; popIndex <  self.currentPopSize / 2; popIndex++)
			{
				ECHandicapper *tempHandicapper	= [self.rankedPopulation objectAtIndex:popIndex];
				double tempFitness				= (double)[tempHandicapper.numberWinBetWinners integerValue] /
													(double)[tempHandicapper.numberWinBets integerValue];
				summedFitnessForPopulation		+= tempFitness;
			}
			
			break;
		}
		
		default:
			break;
	}
	
	NSUInteger parent1Index	= [self getParentIndexFromPopulation:self.population
										 withOverallFitnessValue:summedFitnessForPopulation];
	NSUInteger parent2Index	= parent1Index;

	while(parent2Index == parent1Index)
	{
		parent2Index = [self getParentIndexFromPopulation:self.population
								  withOverallFitnessValue:summedFitnessForPopulation];
	}
	
	ECHandicapper *parent1 = [self.rankedPopulation objectAtIndex:parent1Index];
	ECHandicapper *parent2 = [self.rankedPopulation objectAtIndex:parent2Index];
	
	ECHandicapper *newHandicapper = [NSEntityDescription insertNewObjectForEntityForName:@"Handicapper"
																inManagedObjectContext:MOC];
	
	newHandicapper.numberWinBets			= [NSNumber numberWithInteger:0];
	newHandicapper.numberWinBetWinners		= [NSNumber numberWithInteger:0];
	newHandicapper.amountBetOnWinBets		= [NSNumber numberWithDouble:0.0];
	newHandicapper.amountWonOnWinBets1		= [NSNumber numberWithDouble:0.0];
	
	NSArray *newChildsDnaTreesArray = [self createNewDnaByCrossingOverDnaFrom:parent1
																  withDnaFrom:parent2];
	
	newHandicapper.breakPositionTree		= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBreakPositionStrand]];
	newHandicapper.breakSpeedTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBreakSpeedStrand]];
	newHandicapper.earlySpeedTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kEarlySpeedStrand]];
	newHandicapper.topSpeedTree				= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kTopSpeedStrand]];
	newHandicapper.lateSpeedTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kLateSpeedStrand]];
	newHandicapper.recentClassTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kRecentClassStrand]];
	newHandicapper.earlySpeedRelevanceTree	= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kEarlySpeedRelevanceStrand]];
	newHandicapper.otherRelevanceTree		= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kOtherRelevanceStrand]];
	
	return newHandicapper;
}

- (NSUInteger)getParentIndexFromPopulation:(ECPopulation*)population
				   withOverallFitnessValue:(double)popsFitness
{
	// orgy type does not specify unique parent
	if(kReproductionType == kOrgyMethod)
	{
		return NOT_AN_INDEX; // orgy method does NOT require unique parents
	}

	// parents are chosen based on kReproductionType and kSelection

	NSUInteger parentIndex				= NOT_AN_INDEX;
	NSUInteger magnifiedSummedFitness	= (NSUInteger)(popsFitness * 10000);
	NSUInteger intTarget				= rand() % magnifiedSummedFitness;
	double targetValue					= (double)intTarget / 10000.0;
	double fitnessAccumulator			= 0.0;
	
	// roll through popoulation getting index for parent
	switch (kSelectionMethod)
	{
		case kSuaredFitnessSelection:
		
			// not implemented
			// so do not break - simply fall through to linearFitnessSelection
		
		case kLinearFitnessSelection:
				
			for(NSUInteger popIndex = 0; popIndex < self.currentPopSize / 2; popIndex++)
			{
				ECHandicapper *handicapper	= [self.rankedPopulation objectAtIndex:popIndex];
				double winningPercentage	= [handicapper.numberWinBetWinners integerValue] /
												[handicapper.numberWinBets doubleValue];
				fitnessAccumulator			+= winningPercentage;
			
				if(targetValue < fitnessAccumulator)
				{
					parentIndex = popIndex;
					break;
				}
			}
			
			break;
		
		default:
			break;
	}
	
	return parentIndex;
}

- (void)mutateChildrenForPopulation:(ECPopulation*)pop
{
    NSLog(@"mutateChildrenForPopulation: called");
	
	for(NSUInteger popIndex = self.currentPopSize / 2; popIndex < self.currentPopSize; popIndex++)
	{
		// mutate selected members
		double threshold = (double) (rand() % 100) / 100.0;
		
		if(threshold < [self.population.mutationRate doubleValue])
		{
			// mutate this member
			[self mutateHandicappersDnaTrees:[self.rankedPopulation objectAtIndex:popIndex]];
		}
	}
}

- (void)mutateHandicappersDnaTrees:(ECHandicapper*)futureMutant
{
	// FIX: implement
}


- (NSArray*)createNewDnaByCrossingOverDnaFrom:(ECHandicapper*)parent1
								  withDnaFrom:(ECHandicapper*)parent2
{
    NSUInteger parent1Index     = [parent1.rank integerValue];
    NSUInteger parent2Index     = [parent2.rank integerValue];
	NSUInteger parent1Level		= 0;
    NSUInteger traverseMoves	= 0;
	
    BOOL grandparent1UsingRightChild = YES;
	
	NSMutableArray*childDnaArray	= [NSMutableArray new];
    ECTreeNode *parent1Root			= nil;
    ECTreeNode *parent2Root			= nil;
	
	ECTreeNode *crossover1			= nil;
    ECTreeNode *crossover2			= nil;
    ECTreeNode *crossover1Parent		= nil;
	
	for(NSUInteger strandNumber = 0; strandNumber < kNumberDnaStrands; strandNumber++)
	{
        // identify motherCrossoverNode
        traverseMoves = rand() % ([self.population.maxTreeDepth integerValue] * 2);
       
         if(traverseMoves < 2)
        {
            traverseMoves = 2;
        }

        parent1Level	= 0;
        parent1Root     = self.workingPopulationDna[parent1Index][strandNumber];
		parent2Root		= self.workingPopulationDna[parent2Index][strandNumber];
		
        // randomly traverse parent1 tree to find crossover node and parent and direction
		
        // identifing parent1 crossover node
        crossover1Parent	= nil;
		crossover1		= parent1Root;
		
        for(NSUInteger moveNumber = 0; moveNumber < traverseMoves; moveNumber++)
        {
			parent1Level++;

            if(crossover1.rightBranch && rand() % 2)
            {
                crossover1Parent			= crossover1;
                crossover1					= crossover1.rightBranch;
				grandparent1UsingRightChild = YES;
            }
            else if(crossover1.leftBranch)
            {
                crossover1Parent			= crossover1;
                crossover1					= crossover1.leftBranch;
				grandparent1UsingRightChild = NO;

            }
            else	// reached a leaf --> goto root
            {
				grandparent1UsingRightChild = NO;
                parent1Level		= 0;
                crossover1			= parent1Root;
                crossover1Parent	= nil;
            }
			
			// avoid ending up at root node
			if(moveNumber == traverseMoves - 1 && crossover1 == parent1Root)
			{
				traverseMoves++;
			}
        }
    
		// when ending up back at root move down a level
        if(nil == crossover1 || crossover1 == parent1Root)
        {
            NSLog(@"crossover error alpha1");
            exit(1);
        }
        
        // identify parent2 crossover node
		crossover2 = [self getNodeFromChildAtLevel:parent1Level
										 usingTree:parent2Root];
				
		if(nil == crossover2)
		{
			NSLog(@"error finding parent2 grandparent node");
			exit(1);
		}
	
		for(NSUInteger dnaStrandNumber = 0; dnaStrandNumber < kNumberDnaStrands; dnaStrandNumber++)
		{
			[childDnaArray addObject:[self copyTree:parent1Root
									  replacingNode:crossover1
									  withNode:crossover2]];
		}
	}
	
	return childDnaArray;
}

- (ECTreeNode*)copyTree:parentRoot
		replacingNode:replaceThisNode
			 withNode:replacementNode
{
	if(nil == parentRoot)
	{
		return nil;
	}
	
	ECTreeNode *newTree   = nil;
    ECTreeNode *tempNode  = parentRoot;
	
	if(tempNode.functionPtr &&
       tempNode.leafVariableIndex == NOT_AN_INDEX &&
       tempNode.leafConstant == NOT_A_CONSTANT)
	{
        newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:tempNode.functionIndex];
		
		// traverse left branch first
		if(tempNode.leftBranch == replaceThisNode)
		{
			newTree.leftBranch = [self copyTree:replacementNode
								  replacingNode:nil
									   withNode:nil];
		}
		else
		{
			newTree.leftBranch = [self copyTree:tempNode.leftBranch
								  replacingNode:replaceThisNode
									   withNode:replacementNode];
		}
	
		// now traverse right branch
		if(tempNode.rightBranch == replaceThisNode)
		{
			newTree.rightBranch = [self copyTree:replacementNode
								   replacingNode:nil
										withNode:nil];
		}
		else
		{
			newTree.rightBranch = [self copyTree:tempNode.leftBranch
								   replacingNode:replaceThisNode
										withNode:replacementNode];
		}
	}
    else if(tempNode.leafConstant != NOT_A_CONSTANT)
	{
        newTree = [[ECTreeNode alloc] initWithConstantValue:tempNode.leafConstant];
	}
    else if(tempNode.leafVariableIndex != NOT_AN_INDEX)
	{
        newTree = [[ECTreeNode alloc] initWithRaceVariable:tempNode.leafVariableIndex];
	}
    else
	{
        NSLog(@"copy tree error");
        exit(1);
	}
	
	return newTree;
}

- (ECTreeNode*)getNodeFromChildAtLevel:(NSUInteger)parent1Level
						   usingTree:(ECTreeNode*)parent2Root
{
	ECTreeNode *crossoverFromParent2 = nil;

	return crossoverFromParent2;
}
- (double)evalTree:(ECTreeNode*)treeNode
	usingVariables:(NSMutableArray*)dataArray
			atPost:(NSUInteger)postPosition
{
	double returnVal = 0.0;
	
	if(postPosition > kMaximumNumberEntries)
		{
		NSLog(@"eval tree post error 1");
		exit(1);
		}
	
	if(treeNode.functionPtr)
		{
		double leftBranchVal = [self evalTree:treeNode.leftBranch
							   usingVariables:dataArray
									   atPost:postPosition];
		
		if(leftBranchVal == 00000)
			{
			return 00000;
			}
		
		if(treeNode.rightBranch)
			{
			double rightBranchVal = [self evalTree:treeNode.rightBranch
									usingVariables:dataArray
											atPost:postPosition];
			
			if(leftBranchVal == 00000)
				{
				return 00000;
				}
			
			returnVal = treeNode.functionPtr(leftBranchVal, rightBranchVal);
			}
		else
			{
			returnVal = treeNode.functionPtr(leftBranchVal);
			}
		}
	else if(treeNode.leafConstant != NOT_A_CONSTANT)
		{
		returnVal = treeNode.leafConstant;
		}
	else
		{
		// get value for this race variable
		if(treeNode.leafVariableIndex == NOT_AN_INDEX)
			{
			NSLog(@"eval tree error alpha");
			exit(1);
			}
		else
			{
			returnVal = [self getLeafVariableValueForIndex:treeNode.leafVariableIndex
										fromPastLineRecord:nil];
			}
		}
	
	if(returnVal == 00000)
		{
		return 00000;
		}
	
	return returnVal;
}


- (double)getLeafVariableValueForIndex:(NSUInteger)leafVariableIndex
					fromPastLineRecord:(PastLineRecord*)pastLineRecord
{
	double returnValue = 0.0;
	
	return returnValue;
}



- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex
{
    // Since dnaTrees are stored as strings in coreData data model
    // need to copy just edited trees to appropriate strings
    ECHandicapper *changedHandicapper = nil;
    
    changedHandicapper.breakPositionTree        = self.workingPopulationDna[popIndex][0];
    changedHandicapper.breakSpeedTree           = self.workingPopulationDna[popIndex][1];
    changedHandicapper.earlySpeedTree           = self.workingPopulationDna[popIndex][2];
    changedHandicapper.topSpeedTree             = self.workingPopulationDna[popIndex][3];
    changedHandicapper.lateSpeedTree            = self.workingPopulationDna[popIndex][4];
    changedHandicapper.recentClassTree          = self.workingPopulationDna[popIndex][5];
    changedHandicapper.earlySpeedRelevanceTree  = self.workingPopulationDna[popIndex][6];
    changedHandicapper.otherRelevanceTree       = self.workingPopulationDna[popIndex][7];
}


- (void)freeTree:(ECTreeNode*)node
{
	
	if(nil == node)
	{
		return;
	}
	
	[self freeTree:node.leftBranch];
	node.leftBranch = nil;
	
	[self freeTree:node.rightBranch];
	node.rightBranch = nil;
	
	[self freeTree:node];
	node = nil;

}

- (ECTreeNode*)copyTree:(ECTreeNode*)parentRoot
		  withoutNode:(ECTreeNode*)doNotCopyNode
{
	ECTreeNode *newTree   = nil;
    ECTreeNode *tempNode  = parentRoot;
	
	if(tempNode.functionPtr &&
       tempNode.leafVariableIndex == NOT_AN_INDEX &&
       tempNode.leafConstant == NOT_A_CONSTANT)
	{
        newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:tempNode.functionIndex];

        if(tempNode.leftBranch == doNotCopyNode)
        {
            newTree.leftBranch = nil;
        }
        else
        {
            newTree.leftBranch = [self copyTree:tempNode.leftBranch
								   withoutNode:doNotCopyNode];
        }
        
        if(tempNode.rightBranch)
        {
            if(tempNode.rightBranch == doNotCopyNode)
            {
                newTree.rightBranch = nil;
            }
            else
            {
                newTree.rightBranch = [self copyTree:tempNode.rightBranch
										withoutNode:doNotCopyNode];
            }
        }
    }
    else if(tempNode.leafConstant != NOT_A_CONSTANT)
    {
        newTree = [[ECTreeNode alloc] initWithConstantValue:tempNode.leafConstant];
    }
    else if(tempNode.leafVariableIndex != NOT_AN_INDEX)
    {
        newTree = [[ECTreeNode alloc] initWithRaceVariable:tempNode.leafVariableIndex];
    }
    else
    {
        NSLog(@"copy tree error");
        exit(1);
    }
	
	return newTree;
}


- (NSMutableArray*)createNewHandicappers
{
    NSMutableSet *handicappersSet	= [NSMutableSet new];
    NSArray *immutableArray			= nil;
	
    // create initial population
    for(int popIndex = 0; popIndex < self.currentPopSize; popIndex++)
    {
        ECHandicapper *newbie = [NSEntityDescription insertNewObjectForEntityForName:@"IndividualHandicapper"
                                                            inManagedObjectContext: MOC];
		
		NSLog(@"Population Index:%i:", popIndex);
    
        // iterate through dnaStrands
        for(int strandNumber = 0; strandNumber < kNumberDnaStrands; strandNumber++)
        {
            // iterate through dnaStrands
            int rootLevel = 0;
            
            if(strandNumber == 6)
            {
                rootLevel = 1;
            }
            else if(strandNumber == 7)
            {
                rootLevel = 2;
            }
            
            // don't worry about trees, will rebuild trees later from the strings below
            NSString *dnaString = [self saveTreeToString:[self createTreeForStrand:popIndex
                                                                           atLevel:rootLevel]];
            switch (strandNumber)
            {
                case kBreakPositionStrand:
                    newbie.breakPositionTree = dnaString;
                    break;
                    
                case kBreakSpeedStrand:
                    newbie.breakSpeedTree = dnaString;
                    break;
                    
                case kEarlySpeedStrand:
                    newbie.earlySpeedTree = dnaString;
                    break;
                    
                case kTopSpeedStrand:
                    newbie.topSpeedTree = dnaString;
                    break;
                    
                case kLateSpeedStrand:
                    newbie.lateSpeedTree = dnaString;
                    break;
                    
                case kRecentClassStrand:
                    newbie.recentClassTree = dnaString;
                    break;
                    
                case kEarlySpeedRelevanceStrand:
                    newbie.earlySpeedRelevanceTree = dnaString;
                    break;
                    
                case kOtherRelevanceStrand:
                    newbie.otherRelevanceTree = dnaString;
                    break;
                    
                default:
                    break;
            }
            
            NSLog(@"%i: %@", popIndex, dnaString);
        }
        
        newbie.birthGeneration  = self.population.generationNumber;
        newbie.rank				= [NSNumber numberWithInteger:popIndex];
        
        [handicappersSet addObject:newbie];
    }
    
    [self.population addIndividualHandicappers:[handicappersSet copy]];
	
	return [immutableArray mutableCopy];
}

- (ECTreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level
{
	// tree is made of TreeNodes
	// as we get deeper into the tree increase probability of leaf node
    level++;
    
    ECTreeNode *newNode   = nil;
	NSUInteger nodeType = [self getTreeNodeTypeAtLevel:level];
    
    switch (nodeType)
    {
        case kFunctionNode:
        {
            NSUInteger functionNumber = rand() % kNumberFunctions;
            
            // FIX: for now do NOT use quadratic nodes
            // make 9% of function nodes quadratic Iff they are low enough in tree
            // if(rand() % 11 == 10 && level < [[self.population maxTreeDepth] integerValue] - 2)
            if(0)
            {
                newNode = [self getQuadraticNodeAtLevel:level
                                              forStrand:dnaStrand];
            }
            else
            {
                newNode = [[ECTreeNode alloc] initWithFunctionPointerIndex:functionNumber];
            }
            
            newNode.rightBranch  = nil;
            newNode.leftBranch   = nil;
            
            if(functionNumber < kNumberTwoArgFuncs)
            {
                newNode.rightBranch = [self createTreeForStrand:dnaStrand
                                                       atLevel:level];
            }
            
            // Always make left child
            newNode.leftBranch = [self createTreeForStrand:dnaStrand
                                                  atLevel:level];
            
            break;
        }
            
        case kVariableNode:
        {
            NSUInteger arrayIndex   = [self getPastLineVariableForDnaStrand:dnaStrand];
            newNode                 = [[ECTreeNode alloc] initWithRaceVariable:arrayIndex];
            
            break;
        }
        case kConstantNode:
        {
            double c    = getRand(kRandomRange, kRandomGranularity);
            newNode     = [[ECTreeNode alloc] initWithConstantValue:c];
            
            break;
        }
            
        case kUndefinedNode:
        {
            NSLog(@"Node definition error");
            
            break;
        }
    }
    
	return newNode;
}


- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level
{
    NSUInteger nodeType = kUndefinedNode;
    
    if(level < [self.population.minTreeDepth intValue])
	{
		nodeType = kFunctionNode;
	}
	else
    {
        if(rand() % 3 == 0)  // 1/3 of remaining nodes are functions
        {
            nodeType = kFunctionNode;
        }
        else
        {
            // other 2/3 split evenly between constants and variables
            if(rand() % 2)
            {
                nodeType = kConstantNode;
            }
            else
            {
                nodeType = kVariableNode;
            }
        }
    }
    
    return nodeType;
}

- (NSString*)saveTreeToString:(ECTreeNode*)tree
{
    NSMutableString *treeString = [NSMutableString new];

    if(tree.functionPtr)
    {
        // append funcs name followed by the '('character
        [treeString appendString:tree.functionName];
        [treeString appendString:@"("];
        
        [treeString appendString:[self saveTreeToString:tree.leftBranch]];
        
        if(nil != tree.rightBranch)
        {
            [treeString appendString:@","];
            [treeString appendString:[self saveTreeToString:tree.rightBranch]];
        }
        
        [treeString appendString:@")"];
        
    }
    else if(tree.leafVariableIndex != NOT_AN_INDEX)
    {
        // append index in brackets[]
        [treeString appendString:[NSString stringWithFormat:@"%ld", (unsigned long)tree.leafVariableIndex]];
    }
    else
    {
        if(tree.leafConstant == NOT_A_CONSTANT)
        {
            NSLog(@"save tree error");
        }
        
        // append constant value
        NSString *constantAsString = [NSString stringWithFormat:@"%Lf", tree.leafConstant];
        
        [treeString appendString:constantAsString];
    }
    
    return treeString;
}

- (ECTreeNode*)recoverTreeFromString:(NSString*)inString
{
    ECTreeNode *newTree       = nil;
    NSString *newString     = nil;
    NSString *newString2    = nil;
    NSString *token         = nil;
    NSString *arg1String    = nil;
    NSString *arg2String    = nil;
    NSUInteger commaIndex   = 0;
    NSUInteger parenIndex   = 0;
    NSUInteger numArgs      = 0;
    NSUInteger i            = 0;
    char letter             = '$';
    BOOL gotFunction        = FALSE;
	
	i = 0;
    
	while(i < [inString length])
	{
		letter = [inString characterAtIndex:i++];
		
		if(letter == '(')
		{
			gotFunction = TRUE;
			token       = [inString substringToIndex:i-1];
			break;
		}
	}
	
	if(gotFunction)
	{
        newTree.functionName = token;
        
		if([token isEqualToString:@"add"])
		{
			newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"subtract"])
		{
			newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:kSubtractionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"multiply"])
		{
			newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"divide"])
		{
			newTree =[[ECTreeNode alloc] initWithFunctionPointerIndex:kDivisionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"squareRoot"])
		{
			newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:kSquareRootIndex];
			numArgs = 1;
		}
        else if([token isEqualToString:@"square"])
		{
			newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:kSquareIndex];
			numArgs = 1;
		}
		else if([token isEqualToString:@"naturalLog"])
		{
			newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:kNaturalLogIndex];;
			numArgs = 1;
		}
		else if([token isEqualToString:@"reciprocal"])
		{
			newTree = [[ECTreeNode alloc] initWithFunctionPointerIndex:kReciprocalIndex];
			numArgs = 1;
		}
		else
		{
			NSLog(@"bad function name in recoverTreeFromString");
			exit(1);
		}
		
		switch(numArgs)
		{
			case 1:
				parenIndex          = [self getIndexOfClosedParen:inString];
				newString           = [inString substringToIndex:parenIndex-1];
				arg1String          = [newString substringFromIndex:i];
				newTree.leftBranch   = [self recoverTreeFromString:arg1String];
				
				break;
                
			case 2:
				parenIndex = [self getIndexOfClosedParen:inString];
				commaIndex = [self getIndexOfComma:inString];
				
				if(commaIndex == 0 || parenIndex <= commaIndex)
				{
					NSLog(@"xxx");
					exit(1);
				}
				
				newString = [inString substringToIndex:parenIndex-1];
				arg2String = [newString substringFromIndex:commaIndex];
				
				newString2 = [newString substringToIndex:commaIndex-1];
				arg1String = [newString2 substringFromIndex:i];
                
				newTree.leftBranch   = [self recoverTreeFromString:arg1String];
				newTree.rightBranch  = [self recoverTreeFromString:arg2String];
                
				break;
                
			default:
				NSLog(@"numArgs error in recoverTreeFromString");
				exit(1);
		}
	}
	else
	{
		// this token must either be an int between 1 - NUM_PAST_LINE_VARIABLES
		// or a doulbe
		if(inString.length <= 2)
		{
			newTree = [[ECTreeNode alloc] initWithRaceVariable:[inString intValue]];
		}
		else
		{
			newTree = [[ECTreeNode alloc] initWithConstantValue:[inString doubleValue]];
		}
	}
	
	if(newTree.functionIndex >= 0 && newTree.functionIndex < 4)
	{
		if(newTree.leftBranch == nil || newTree.rightBranch == nil)
		{
			NSLog(@"recover error 1");
			exit(1);
		}
	}
	else if(newTree.functionIndex >= 4 && newTree.functionIndex < 9)
	{
		if(nil == newTree.leftBranch || newTree.rightBranch)
		{
			NSLog(@"recover error 2");
			exit(1);
		}
	}
	else if(newTree.leafConstant == 0.0 &&
            newTree.functionIndex == -1 &&
            newTree.leafVariableIndex == -1)
	{
		NSLog(@"recover error 3");
		exit(1);
	}
	else if((nil == newTree.functionPtr || newTree.functionIndex == -1) &&
            (newTree.leftBranch || newTree.rightBranch))
	{
		
		NSLog(@"recover error 4");
		exit(1);
	}
    
    return newTree;
}

- (NSUInteger)getIndexOfComma:(NSString*)inString
{
    NSUInteger commaIndex   = 0;
    NSUInteger level        = 0;
    NSUInteger  myLength    = [inString length];
    char letter             = '$';

    while(commaIndex < myLength)
    {
        letter = [inString characterAtIndex:commaIndex++];
        
        if(letter == '(')
        {
            level++;
        }
        else if(letter == ')')
        {
            level--;
        }
        else if(letter == ',' && level == 1)
        {
            break;
        }
    }

    return commaIndex;
}

- (NSUInteger)getIndexOfClosedParen:(NSString*)inString
{
    NSUInteger closedParenIndex = 0;
    NSInteger level             = 0;
    NSInteger myLength          = [inString length];
    char letter                 = '$';

    while(closedParenIndex < myLength)
    {
        letter = [inString characterAtIndex:closedParenIndex++];
        
        if(letter == '(')
        {
            level++;
        }
        else if(letter == ')')
        {
            level--;
            
            if(level == 0)
            {
                break;
            }
            
            if(level < 0)
            {
                NSLog(@"unbalanced parenthesis in tree error 1");
                break;
            }
        }
    }

    return closedParenIndex;
}


- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand
{
    // since each dnaStrand uses a subset of all raceLine variables
    // we carefully assign appropriate indices for later dereferencing the PastLineArray
    // Here is the map of the PastLine
    
    // 0:  weight
    // 1:  race distance
    // 2:  race class
    // 3:  track name
    // 4:  track conditions
    // 5:  past race date
    // 6:  number of entries
    // 7:  post number
    // 8:  position at break
    // 9:  position turn 1
    // 10: position turn 2
    // 11: position at finish
    // 12: entry time
    // 13: lead by lengths 1
    // 14: lead by lengths 2
    // 15: lead by lengths final
    // 16: delat 1
    // 17: delta 2
    // 18: delta 3
    // 19: winning time
    // 20: comments
    
    // dna variables by strand
    //
    
    // 0: break position
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 1: break speed
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 2: early speed
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 1
    
    // 3: top speed
    //      9:  winning time
    //      12: entry time
    //      16: delta 1
    //      17: delta 2
    //      18: delta 3
    
    // 4: late speed
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 3

    // 5: recent class
    //      2:  race class
    //      9:  winning time
    //      11: position at finish
    //      12: entry time
    
    // 6: early speed relevance
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      7:  post number (used to calculate delta post)

    // 7: other relevance
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    
    NSUInteger pastLineVariableIndex = 999;

    switch (dnaStrand)
    {
        case 0: // break position
        {
            NSUInteger varIndex = rand() % 4;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 3;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 9;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 1: // break speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 2:  // early speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 12;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 16;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 17;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 18;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 3: // top speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 4:  // late speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 6;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 11;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 12;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
       
        case 5:  // recent class
        {
            NSUInteger varIndex = rand() % 4;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 11;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 12;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
     
        case 6:  // early speed relevance
        {
            NSUInteger varIndex = rand() % 3;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 7;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
      
        case 7:  // other relevance
        {
            NSUInteger varIndex = rand() % 2;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }

    if(pastLineVariableIndex == 999)
    {
        NSLog(@"error in getPastLineRaceVariable");
        exit(1);
    }

    return pastLineVariableIndex;
}

// overflow, underflow and division by zero are ignored here
// to be trapped in evalTree method

double getRand(int max, int granularity)
{
    double val  = ((rand() % 10000) / 10000.0) * max;

    if(rand() % 2)
    {
        val *= -1;
    }

    return val;
}


- (ECTreeNode*)getQuadraticNodeAtLevel:(NSUInteger)level
                           forStrand:(NSUInteger)dnaStrand
{
    // creates the form:  a(x^2) + bx + c
    //  where a, b and c are derived from independent tree branches
    //  and X is a random pastLine variable

    double x = getRand(kRandomRange, kRandomGranularity);
    level++;

    ECTreeNode *quadTree                          = [[ECTreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add

    quadTree.leftBranch.leftBranch                = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'a' branch
    quadTree.leftBranch                          = [[ECTreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // mult
    quadTree.leftBranch.rightBranch               = [[ECTreeNode alloc] initWithConstantValue:x];                           // 'x'
    quadTree.leftBranch.rightBranch.leftBranch     = [[ECTreeNode alloc] initWithFunctionPointerIndex:kSquareIndex];         // square


    quadTree.rightBranch                         = [[ECTreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add
    quadTree.rightBranch.leftBranch.leftBranch     = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'b' branch
    quadTree.rightBranch.leftBranch               = [[ECTreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // multiply
    quadTree.rightBranch.leftBranch.rightBranch    = [[ECTreeNode alloc] initWithConstantValue:x];                           // 'x'
    quadTree.rightBranch.rightBranch              = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level];                                     // 'c' branch
    return quadTree;
}

- (void)updateAndSaveData
{
    
}


@end
