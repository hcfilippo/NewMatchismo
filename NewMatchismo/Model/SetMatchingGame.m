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


static const int MISMATCH_PENALY = 5;
static const int MATCH_BONUS = 10;


- (void)chooseCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isChosen)
    {
        NSMutableArray *chosenCards;
        chosenCards = [[NSMutableArray alloc] init];
        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen) {
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
            }
            else {
                
                self.message = [NSString stringWithFormat:@"Not a set! %d points penalty", MISMATCH_PENALY];
                self.score -= MISMATCH_PENALY;
            }
            for (Card *otherCard in chosenCards)
            {
                otherCard.chosen = NO;
            }
        } else {
            self.message = @"";
            card.chosen = YES;
        }
    }
    
}



- (Card *)cardAtIndex:(NSInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}





@end
