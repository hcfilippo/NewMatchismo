//
//  SetMatchingGame.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SetMatchingGame.h"

@interface SetMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) NSString *message;
@end


@implementation SetMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        self.score = 0;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            
        }
    }
    return self;
}

- (BOOL) drawCards:(NSInteger)count usingDeck:(Deck *)deck
{
    for (int i = 0; i < count; i++) {
        Card *card = [deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        } else {
            return NO;
        }
    }
    return YES;
}



static const int MISMATCH_PENALY = 5;
static const int MATCH_BONUS = 10;


-(void)removeCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];
    [self.cards removeObject:card];
}


- (int)chooseCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isChosen && !card.isMatched)
    {
        NSMutableArray *chosenCards;
        chosenCards = [[NSMutableArray alloc] init];
        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen && !otherCard.isMatched) {
                [chosenCards addObject:otherCard];
            }
        }
        if (chosenCards.count == 2)
        {
            int matchScore = [card match:chosenCards];
            if (matchScore)
            {
                self.message = [NSString stringWithFormat:@"A set found! %d points bonus",matchScore * MATCH_BONUS];
                self.score += matchScore * MATCH_BONUS;
                for (Card *otherCard in chosenCards)
                {
                    otherCard.chosen = YES;
                    otherCard.matched = YES;
                }
                card.matched = YES;
                card.chosen = YES;
                return 1;
            }
            else {
                
                self.message = [NSString stringWithFormat:@"Not a set! %d points penalty", MISMATCH_PENALY];
                self.score -= MISMATCH_PENALY;
                for (Card *otherCard in chosenCards)
                {
                    otherCard.chosen = NO;
                    otherCard.matched = NO;
                }
                card.matched = NO;
                card.chosen = NO;
                return 0;
            }
        } else {
            self.message = @"";
            card.chosen = YES;
        }
    }
    return 0;
}



- (Card *)cardAtIndex:(NSInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}





@end
