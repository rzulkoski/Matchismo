//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/14/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
