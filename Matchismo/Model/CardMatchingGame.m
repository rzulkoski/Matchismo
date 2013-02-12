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
    NSMutableArray *flipResult = [[NSMutableArray alloc] init];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            [flipResult addObject:card];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [flipResult addObject:otherCard];
                    if ([flipResult count] == self.numberOfCardsToMatch) {
                        int matchScore = [flipResult[0] match:[flipResult subarrayWithRange:NSMakeRange(1, [flipResult count]-1)]];
                        if (matchScore) {
                            for (Card *cardToMakeUnplayable in flipResult) {
                                cardToMakeUnplayable.unplayable = YES;
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

@end
