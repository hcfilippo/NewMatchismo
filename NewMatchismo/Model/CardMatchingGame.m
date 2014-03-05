//
//  CardMatchingGame.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-17.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) NSString *message;
@end


@implementation CardMatchingGame


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



static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (void)chooseCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // match against another card
            int otherCardExsits = 0;
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        card.matched = YES;
                        otherCard.matched = YES;
                        self.message = [NSString stringWithFormat:@"%@%@ matched for %d points", card.contents, otherCard.contents,matchScore * MATCH_BONUS];
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        self.message = [NSString stringWithFormat:@"%@%@ mismatched! %d points penalty",card.contents,otherCard.contents,MISMATCH_PENALTY];
                        otherCard.chosen = NO;
                    }
                    otherCardExsits = 1;
                    break;
                }
            }
            if (otherCardExsits == 0)
            {
                self.message = [NSString stringWithFormat:@"%@", card.contents];
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }

}

- (void)chooseCardAtIndex:(NSInteger)index gameMode:(NSInteger)mode
{
    if (mode == 0)
    {
        //2-card-match
        [self chooseCardAtIndex:index];
    } else
    {
        //3-card-match
        Card *card = [self cardAtIndex:index];
        if (!card.isMatched) {
            if (card.isChosen) {
                card.chosen = NO;
            } else {
                NSMutableArray *otherCards;
                otherCards = [[NSMutableArray alloc] init];
                
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        [otherCards addObject:otherCard];
                    }
                }
                if (otherCards.count == 2)
                {
                    int matchScore = [card match:otherCards];
                    NSString *contentsMessage = [NSString stringWithFormat:@"%@",card.contents];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        card.matched = YES;
                        for (Card *otherCard in otherCards)
                        {
                            otherCard.matched = YES;
                            contentsMessage = [contentsMessage stringByAppendingString:otherCard.contents];
                        }
                        self.message = [NSString stringWithFormat:@"%@ matched for %d points", contentsMessage,matchScore * MATCH_BONUS];
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        for (Card *otherCard in otherCards)
                        {
                            otherCard.chosen = NO;
                            contentsMessage = [contentsMessage stringByAppendingString:otherCard.contents];
                        }
                        self.message = [NSString stringWithFormat:@"%@ mismatched! %d points penalty",contentsMessage,MISMATCH_PENALTY];
                    }
                }
                else
                {
                    self.message = [NSString stringWithFormat:@"%@", card.contents];
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
            }
        }
    
    }
}



- (Card *)cardAtIndex:(NSInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}



@end
