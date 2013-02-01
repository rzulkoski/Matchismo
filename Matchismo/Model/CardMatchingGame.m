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
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck cardMatchMode:(NSUInteger)numCards
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
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (NSString *)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *otherCardsToMatch = [[NSMutableArray alloc] init];
    NSString *flipSummary = nil;
    BOOL matchAttempted = NO;
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCardsToMatch addObject:otherCard];
                    if ([otherCardsToMatch count]+1 == self.numberOfCardsToMatch) {
                        matchAttempted = YES;
                        int matchScore = [card match:otherCardsToMatch];
                        if (matchScore) {
                            for (Card *cardToMakeUnplayable in otherCardsToMatch) {
                                cardToMakeUnplayable.unplayable = YES;
                            }
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            flipSummary = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card, [otherCardsToMatch componentsJoinedByString:@" & "], matchScore * MATCH_BONUS];
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            flipSummary = [NSString stringWithFormat:@"%@ & %@ don't match! -%d points!", card, [otherCardsToMatch componentsJoinedByString:@" & "], MISMATCH_PENALTY];
                        }
                        break;
                    }
                }
            }
            self.score -= FLIP_COST;
            if (!matchAttempted) flipSummary = [NSString stringWithFormat:@"Flipped up %@", card];
        }
        card.faceUp = !card.isFaceUp;
    }
    return flipSummary;
}

@end
