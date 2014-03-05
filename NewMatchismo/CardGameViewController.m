//
//  CardGameViewController.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-16.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"
#import "Grid.h"
#import "PlayingCard.h"

@interface CardGameViewController ()

- (IBAction)touchRestartButton:(UIButton *)sender;

@property (nonatomic, strong) Deck *deck;
//@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *playingCardViews; //of PlayingCardView
@property (strong, nonatomic) UIView *cardAreaView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) Grid *grid;
@property (nonatomic) NSInteger cardNumbers;

@end

@implementation CardGameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.cardNumbers =12;
    
    self.grid.size = CGSizeMake(280, 320);
    self.grid.cellAspectRatio = (CGFloat)(2.0)/(3.0);
    self.grid.minimumNumberOfCells = 12;
    
    
    self.cardAreaView.center = CGPointMake(20, 70);
    [self.cardAreaView setFrame:CGRectMake(20, 70, 280, 320)];
    [self.view addSubview:self.cardAreaView];
    
    
    
    
    NSUInteger rowCount = self.grid.rowCount;
    NSUInteger columnCount = self.grid.columnCount;

    int index = 0;
    for (NSUInteger row = 0; row < rowCount; row++)
    {
        for (NSUInteger column = 0; column < columnCount; column++)
        {
            CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
            
            PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:frame];
            
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [cardView addGestureRecognizer:tgr];
            
            [self.cardAreaView addSubview:cardView];
            [self.playingCardViews addObject:cardView];
            index++;
        }
    }
    [self resetGame];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *) playingCardViews
{
    if (!_playingCardViews) _playingCardViews = [[NSMutableArray alloc] init];
    return _playingCardViews;
}

- (UIView *)cardAreaView
{
    if (!_cardAreaView) _cardAreaView = [[UIView alloc]init];
    return _cardAreaView;
}

- (Grid *)grid
{
    if (!_grid) _grid = [[Grid alloc] init];
    return _grid;
}

@synthesize game = _game;


- (void)setGame:(CardMatchingGame *)game
{
    _game = game;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardViews count]
                                                          usingDeck:[self createDeck]];
    return _game;
}


- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck    // abstract
{
    return nil;
}


- (IBAction)touchRestartButton:(UIButton *)sender
{
    [self resetGame];
}

- (void) resetGame
{
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardViews count]
                                              usingDeck:[self createDeck]];
    
    for (PlayingCardView *cardView in self.playingCardViews) {
        int cardIndex = [self.playingCardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        PlayingCard *playingCard = (PlayingCard *)card;
        cardView.suit = playingCard.suit;
        cardView.rank = playingCard.rank;
        cardView.faceUp = NO;
        cardView.matched = NO;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


- (void) updateUI
{
    for (PlayingCardView *cardView in self.playingCardViews) {
        int cardIndex = [self.playingCardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        cardView.faceUp = card.chosen;
        cardView.matched = card.matched;
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    PlayingCardView *view = (PlayingCardView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        int cardIndex = [self.playingCardViews indexOfObject:view];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (!card.matched)
        {
            [self.game chooseCardAtIndex:cardIndex];
            [self updateUI];
        }
    }
}



@end
