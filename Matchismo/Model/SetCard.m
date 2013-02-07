//
//  SetCard.m
//  Matchismo
//
//  Created by Ryan Zulkoski on 2/6/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize symbol = _symbol;
@synthesize shade = _shade;
@synthesize color = _color;

- (int)match:(NSArray *)otherCards
{
    int score = 0;

    if ([otherCards count] == 2) {
        SetCard *secondCard = [otherCards objectAtIndex:0];
        SetCard *thirdCard = [otherCards objectAtIndex:1];
        int differences = 0;
        
        if (![self.symbol isEqualToString:secondCard.symbol] && ![self.symbol isEqualToString:thirdCard.symbol] && ![secondCard.symbol isEqualToString:thirdCard.symbol]) {
            differences++;
        } else if (![self.symbol isEqualToString:secondCard.symbol] || ![self.symbol isEqualToString:thirdCard.symbol]) {
            return score;
        }
        if (self.number != secondCard.number && self.number != thirdCard.number && secondCard.number != thirdCard.number) {
            differences++;
        } else if (self.number != secondCard.number || self.number != thirdCard.number) {
            return score;
        }
        if (![self.shade isEqualToString:secondCard.shade] && ![self.shade isEqualToString:thirdCard.shade] && ![secondCard.shade isEqualToString:thirdCard.shade]) {
            differences++;
        } else if (![self.shade isEqualToString:secondCard.shade] || ![self.shade isEqualToString:thirdCard.shade]) {
            return score;
        }
        if (![self.color isEqualToString:secondCard.color] && ![self.color isEqualToString:thirdCard.color] && ![secondCard.color isEqualToString:thirdCard.color]) {
            differences++;
        } else if (![self.color isEqualToString:secondCard.color] || ![self.color isEqualToString:thirdCard.color]) {
            return score;
        }
        switch (differences) {
            case 1:
                score = 4;
                break;
            case 2:
                score = 2;
                break;
            case 3:
                score = 1;
                break;
            case 4:
                score = 3;
                break;
        }
    }
    
    return score;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d%@%@%@", self.number, self.shade, self.color, self.symbol];
}

- (NSAttributedString *)attributedContents
{
    NSString *symbols = @"";
    for (int i = 1; i <= self.number; i++) { symbols = [symbols stringByAppendingString:self.symbol]; }
    NSDictionary *attributes = @{ NSStrokeColorAttributeName     : [self displayColor],
                                  NSForegroundColorAttributeName : [self shadeColor],
                                  NSStrokeWidthAttributeName     : @-5 };
    return [[NSAttributedString alloc] initWithString:symbols attributes:attributes];
}

- (UIColor *)displayColor
{
    NSDictionary *colorMappings = @{ @"Red"   : [UIColor redColor],
                                     @"Green" : [UIColor greenColor],
                                     @"Blue"  : [UIColor blueColor] };
    
    return [colorMappings objectForKey:self.color] ? [colorMappings objectForKey:self.color] : [UIColor blackColor];
}

- (UIColor *)shadeColor
{
    UIColor *shadeColor = nil;
    NSDictionary *shadedColorMappings = @{ @"Red"   : [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3],
                                           @"Green" : [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.3],
                                           @"Blue"  : [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3] };
    
    if ([self.shade isEqualToString:@"Solid"]) {
        shadeColor = [self displayColor];
    } else if ([self.shade isEqualToString:@"Shaded"]) {
        shadeColor = [shadedColorMappings objectForKey:self.color];
    } else if ([self.shade isEqualToString:@"Open"]) {
        shadeColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    }
    return shadeColor;
}

+ (NSArray *)validSymbols
{
    return @[@"▲",@"●",@"■"];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

+ (NSUInteger)maxNumber
{
    return 3;
}

- (void)setNumber:(int)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

+ (NSArray *)validShades
{
    return @[@"Solid",@"Shaded",@"Open"];
}

- (void)setShade:(NSString *)shade
{
    if ([[SetCard validShades] containsObject:shade]) {
        _shade = shade;
    }
}

- (NSString *)shade
{
    return _shade ? _shade : @"?";
}

+ (NSArray *)validColors
{
    return @[@"Red",@"Green",@"Blue"];
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)color
{
    return _color ? _color : @"?";
}

@end
