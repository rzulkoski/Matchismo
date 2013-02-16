//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/13/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic, getter=isFaceUp) BOOL faceUp;

@end
