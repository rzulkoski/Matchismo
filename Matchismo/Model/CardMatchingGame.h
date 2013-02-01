//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/30/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
          cardMatchMode:(NSUInteger)numCards;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (NSString *)flipHistoryForFlip:(NSUInteger)flipIndex;

- (NSUInteger)numberOfFlips;

@property (readonly, nonatomic) int score;

@end
