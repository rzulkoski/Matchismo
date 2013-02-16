//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 1/29/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

#define CARD_MATCH_MODE 2

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate { } //abstract

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                          usingDeck:[self createDeck]
                                                      cardMatchMode:CARD_MATCH_MODE
                                                         matchBonus:4
                                                    mismatchPenalty:2
                                                           flipCost:1];
    return _game;
}

- (Deck *)createDeck { return nil; } // abstract

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)deal {
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        [self updateUI];
        self.gameResult.score = self.game.score;
    }
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self deal];
}

- (NSMutableAttributedString *)parseFlipResult:(NSArray *)flipResult
{
    NSMutableAttributedString *flipSummary = nil;
    NSAttributedString *cardSeparator = [[NSAttributedString alloc] initWithString:@"&"];
    
    if ([flipResult count] > 0) {
        if ([flipResult[0] isKindOfClass:[NSNumber class]]) {
            int matchPoints = [flipResult[0] integerValue];
            NSArray *cards = [flipResult subarrayWithRange:NSMakeRange(1, [flipResult count]-1)];
            if (matchPoints > 0) {
                flipSummary = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
                [flipSummary appendAttributedString:[self createAttributedStringFromCards:cards  withSeparator:cardSeparator]];
                [flipSummary appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", [flipResult[0] integerValue]]]];
            } else {
                flipSummary = [[NSMutableAttributedString alloc] initWithAttributedString:[self createAttributedStringFromCards:cards withSeparator:cardSeparator]];
                [flipSummary appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match (%d penalty)", matchPoints]]];
            }
        } else {
            Card *flippedCard = flipResult[0];
            flipSummary = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
            [flipSummary appendAttributedString:flippedCard.attributedContents];
        }
        //[flipSummary addAttributes:self.flipSummaryAttributes range:NSMakeRange(0, [flipSummary length])];
    }
    
    return flipSummary;
}

- (NSMutableAttributedString *)createAttributedStringFromCards:(NSArray *)cards withSeparator:(NSAttributedString *)separator
{
    NSMutableAttributedString *stringOfCards = nil;
    Card * currentCard = nil;
    
    if ([cards count] > 0) {
        currentCard = cards[0];
        stringOfCards = [[NSMutableAttributedString alloc] initWithAttributedString:currentCard.attributedContents];
        for (int i = 1; i < [cards count]; i++) {
            currentCard = cards[i];
            [stringOfCards appendAttributedString:separator];
            [stringOfCards appendAttributedString:currentCard.attributedContents];
        }
    }
    
    return stringOfCards;
}*/

@end
