//
//  PlayingCard.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-16.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if ([self.suit isEqualToString:otherCard.suit]) {
            score = 1;
        } else if (self.rank == otherCard.rank){
            score = 4;
        }
    }
    else if ([otherCards count] == 2)
    {
        // 3-card-match
        PlayingCard *firstCard = otherCards[0];
        PlayingCard *secondCard = otherCards[1];
        if ([self.suit isEqualToString:firstCard.suit]) {
            score += 1;
        } else if (self.rank == firstCard.rank){
            score += 4;
        }
        if ([self.suit isEqualToString:secondCard.suit]) {
            score += 1;
        } else if (self.rank == secondCard.rank){
            score += 4;
        }
        if ([firstCard.suit isEqualToString:secondCard.suit]) {
            score += 1;
        } else if (firstCard.rank == secondCard.rank){
            score += 4;
        }
    }
    return score;
}


- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♦",@"♣",@"♥",@"♠"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *) suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *) rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger) maxRank
{
    NSUInteger rank = 13;
    return rank;
}

@end
