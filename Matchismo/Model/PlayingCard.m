//
//  PlayingCard.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/29/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if (otherCards.count == 2) {
        PlayingCard *secondCard = [otherCards objectAtIndex:0];
        PlayingCard *thirdCard = [otherCards objectAtIndex:1];
        if (secondCard.rank == self.rank && thirdCard.rank == self.rank) {
            score = 22; // 3 of the same Rank
        } else if ([secondCard.suit isEqualToString:self.suit] && [thirdCard.suit isEqualToString:self.suit]) {
            score = 1;  // 3 of the same Suit
        } else if ((secondCard.rank == self.rank || thirdCard.rank == self.rank || secondCard.rank == thirdCard.rank) &&
                   ([secondCard.suit isEqualToString:self.suit] || [thirdCard.suit isEqualToString:self.suit] || [secondCard.suit isEqualToString:thirdCard.suit])) {
            score = 6;  // 2 of the same Rank & 2 of the same Suit
        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
