//
//  SetCard.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SetCard.h"
#import "Card.h"

@implementation SetCard


- (int)match:(NSArray *)otherCards
{
    SetCard *first = otherCards[0];
    SetCard *second = otherCards[1];
    if (![self card1:self.symbol card2:first.symbol card3:second.symbol])
        return NO;
    if (![self card1:self.number card2:first.number card3:second.number])
        return NO;
    if (![self card1:self.shading card2:first.shading card3:second.shading])
        return NO;
    if (![self card1:self.color card2:first.color card3:second.color])
        return NO;
    return YES;
}


- (BOOL)card1:(NSInteger)card1 card2:(NSInteger)card2 card3:(NSInteger)card3
{
    if (card1 == card2 && card2 == card3)
    {
        return YES;
    }
    else if (card1 != card2 && card2 != card3 && card3 != card1)
    {
        return YES;
    }
    return NO;
}


+ (NSArray *)validSymbols
{
    return @[@"▲",@"●",@"■"];
}

- (NSString *) contents
{
    NSArray *validSymbols = [SetCard validSymbols];
    NSMutableString *ret = [[NSMutableString alloc] init];
    for (int i = 0; i < self.number + 1; i++)
        [ret appendString:validSymbols[self.symbol]];
    return ret;
}

- (UIColor *)fontColor
{
    if (self.color == 0)
        return [UIColor redColor];
    else if (self.color == 1)
        return [UIColor greenColor];
    else if (self.color == 2)
        return [UIColor blueColor];
    return [UIColor blackColor];
}


- (NSAttributedString *)getAttributedTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.contents];
    if (self.shading == 0)
    {
        [title addAttributes:@{NSForegroundColorAttributeName:[self fontColor]}
                       range:NSMakeRange(0, [title length])];
    } else if (self.shading == 1)
    {
        [title addAttributes:@{NSStrokeWidthAttributeName:@-10,
                               NSStrokeColorAttributeName:[UIColor blackColor],
                               NSForegroundColorAttributeName:[self fontColor]}
                       range:NSMakeRange(0, [title length])];
    } else if (self.shading == 2)
    {
        [title addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                               NSForegroundColorAttributeName:[self fontColor]
                               }
                       range:NSMakeRange(0, [title length])];
    }
    return title;
}



@end
