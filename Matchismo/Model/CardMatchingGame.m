//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/30/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (readwrite, nonatomic) int score;
@property (nonatomic) int numberOfCardsToMatch;
@property (nonatomic) NSUInteger matchBonus;
@property (nonatomic) NSUInteger mismatchPenalty;
@property (nonatomic) NSUInteger flipCost;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) BOOL replaceMatchedCards;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
          cardMatchMode:(NSUInteger)numCards
     replaceMatchedCards:(BOOL)replaceMatchedCards
             matchBonus:(NSUInteger)matchBonus
        mismatchPenalty:(NSUInteger)mismatchPenalty
               flipCost:(NSUInteger)flipCost
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        if (numCards >=2) {
            self.numberOfCardsToMatch = numCards;
        }
    }
    self.replaceMatchedCards = replaceMatchedCards;
    if (self.replaceMatchedCards) self.deck = deck;
    self.matchBonus = matchBonus;
    self.mismatchPenalty = mismatchPenalty;
    self.flipCost = flipCost;
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSArray *)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *otherCardsToMatch = [[NSMutableArray alloc] init];
    NSMutableArray *flipResult = [[NSMutableArray alloc] init];
    BOOL matchAttempted = NO;
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            [flipResult addObject:card];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCardsToMatch addObject:otherCard];
                    if ([otherCardsToMatch count]+1 == self.numberOfCardsToMatch) {
                        matchAttempted = YES;
                        [flipResult addObjectsFromArray:otherCardsToMatch];
                        int matchScore = [card match:otherCardsToMatch];
                        if (matchScore) {
                            for (int i = 0; i < [otherCardsToMatch count]; i++) {
                                Card *cardToMakeUnplayable = otherCardsToMatch[i];
                                if (self.replaceMatchedCards) {
                                    Card *replacementCard = [self.deck drawRandomCard];
                                    if (replacementCard) {
                                        self.cards[[self.cards indexOfObjectIdenticalTo:cardToMakeUnplayable]] = replacementCard;
                                    } else {
                                        cardToMakeUnplayable.unplayable = YES;
                                    }
                                } else {
                                    cardToMakeUnplayable.unplayable = YES;
                                }
                            }
                            if (self.replaceMatchedCards) {
                                Card *replacementCard = [self.deck drawRandomCard];
                                if (replacementCard) {
                                    self.cards[[self.cards indexOfObjectIdenticalTo:card]] = replacementCard;
                                } else {
                                    card.unplayable = YES;
                                }
                            } else {
                                card.unplayable = YES;
                            }
                            self.score += matchScore * self.matchBonus;
                            [flipResult insertObject:[NSNumber numberWithInt:matchScore * self.matchBonus] atIndex:0];
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= self.mismatchPenalty;
                            [flipResult insertObject:[NSNumber numberWithInt:-self.mismatchPenalty] atIndex:0];
                        }
                        break;
                    }
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
    return [flipResult copy];
}

- (NSArray *)remainingMoves
{
    NSMutableArray *remainingMoves = [[NSMutableArray alloc] init];
    NSArray *potentialMoves = [self getPotentialMovesFromCards:self.cards numberOfCardsNeeded:self.numberOfCardsToMatch];
    
    for (NSArray *potentialMove in potentialMoves) {
        int matchScore = [potentialMove[0] match:[potentialMove subarrayWithRange:NSMakeRange(1, [potentialMove count]-1)]];
        if (matchScore) {
            [remainingMoves addObject:[potentialMove componentsJoinedByString:@" & "]];
        }
    }
    
    return [remainingMoves copy];
}

- (NSArray *)getPotentialMovesFromCards:(NSArray *)cards numberOfCardsNeeded:(NSUInteger)numberOfCardsNeeded
{
    NSMutableArray *potentialMoves = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [cards count]-numberOfCardsNeeded+1; i++) {
        Card *card = cards[i];
        if (!card.isUnplayable) {
            if (numberOfCardsNeeded == 1) {
                [potentialMoves addObject:@[card]];
            } else {
                NSMutableArray *partialMoves = [[self getPotentialMovesFromCards:[cards subarrayWithRange:NSMakeRange(i+1, [cards count]-i-1)] numberOfCardsNeeded:numberOfCardsNeeded-1] mutableCopy];
                for (NSArray *partialMove in partialMoves) {
                    NSArray *potentialMove = [partialMove arrayByAddingObject:card];
                    [potentialMoves addObject:potentialMove];
                }
            }
        }
    }
    
    return [potentialMoves copy];
}

@end
