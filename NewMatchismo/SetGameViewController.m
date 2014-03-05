//
//  SetGameViewController.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-24.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetMatchingGame.h"
#import "SetCardDeck.h"
#import "Grid.h"
#import "SetCardView.h"
#import "Deck.h"

@interface SetGameViewController ()
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) SetMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSMutableArray *setCardViews;
@property (strong, nonatomic) UIView *cardAreaView;
@property (nonatomic) NSInteger numberOfCards;
@property (strong, nonatomic) Grid *grid;
- (IBAction)touchRestartButton:(id)sender;
- (IBAction)touchDrawCardsButton:(id)sender;

@end

@implementation SetGameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.cardAreaView.center = CGPointMake(10, 70);
    [self.cardAreaView setFrame:CGRectMake(10, 70, 300, 300)];
    [self.view addSubview:self.cardAreaView];
    
    [self resetGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SetMatchingGame *)game
{
    if (!_game) _game = [[SetMatchingGame alloc] initWithCardCount:[self.setCardViews count]
                                                          usingDeck:[self createDeck]];
    return _game;
}



- (IBAction)touchRestartButton:(UIButton *)sender
{
    [self resetGame];
}

- (IBAction)touchDrawCardsButton:(id)sender
{
    
    if (![self.game drawCards:3 usingDeck:self.deck])
    {
        return;
    }
    
    int currentCardNumber = 0;
    for (SetCardView *cardView in self.setCardViews)
    {
        if (!cardView.matched)
        {
            currentCardNumber++;
        }
    }
    
    NSMutableArray *newCardViews = [[NSMutableArray alloc] init];
    for (SetCardView *cardView in self.setCardViews)
    {
        if (!cardView.matched)
        {
            [newCardViews addObject:cardView];
        }
    }
    
    for(UIView *view in [self.cardAreaView subviews])
    {
        [view removeFromSuperview];
    }
    
    self.numberOfCards = currentCardNumber + 3;
    self.grid.minimumNumberOfCells = self.numberOfCards;
    [self resetGrid];
    
    
    NSUInteger rowCount = self.grid.rowCount;
    NSUInteger columnCount = self.grid.columnCount;
    int cardCount = 0;
    for (NSUInteger row = 0; row < rowCount; row++)
    {
        for (NSUInteger column = 0; column < columnCount; column++)
        {
            if (cardCount < currentCardNumber)
            {
                CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
                SetCardView *cardView = [[newCardViews objectAtIndex:cardCount] resetFrame:frame];
                [self.cardAreaView addSubview:cardView];
            }
            else if (cardCount < self.numberOfCards) {
                CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
                SetCardView *cardView = [[SetCardView alloc] initWithFrame:frame];
                
                UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                [cardView addGestureRecognizer:tgr];
                
                [self.cardAreaView addSubview:cardView];
                [self.setCardViews addObject:cardView];
                
            }
            cardCount++;
        }
    }
    [self updateUI];
}

- (void)resetGrid
{
    self.grid = [[Grid alloc] init];
    self.grid.size = CGSizeMake(300, 300);
    self.grid.cellAspectRatio = (CGFloat)(3.0)/(2.0);
    self.grid.minimumNumberOfCells = self.numberOfCards;
}


- (void) resetGame
{
    self.numberOfCards = 12;
    [self resetGrid];
    [self.setCardViews removeAllObjects];
    
    NSUInteger rowCount = self.grid.rowCount;
    NSUInteger columnCount = self.grid.columnCount;
    
    for(UIView *view in [self.cardAreaView subviews])
    {
        [view removeFromSuperview];
    }
    
    int cardCount = 0;
    for (NSUInteger row = 0; row < rowCount; row++)
    {
        for (NSUInteger column = 0; column < columnCount; column++)
        {
            if (cardCount < self.numberOfCards)
            {
                CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
                SetCardView *cardView = [[SetCardView alloc] initWithFrame:frame];
                
                UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                [cardView addGestureRecognizer:tgr];
                
                [self.cardAreaView addSubview:cardView];
                [self.setCardViews addObject:cardView];
                
                cardCount++;
            }
        }
    }
    
    _game = [[SetMatchingGame alloc] initWithCardCount:[self.setCardViews count]
                                              usingDeck:[self createDeck]];
    for (SetCardView *cardView in self.setCardViews) {
        int cardIndex = [self.setCardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        SetCard *setCard = (SetCard *)card;
        cardView.symbol = setCard.symbol;
        cardView.number = setCard.number;
        cardView.shading = setCard.shading;
        cardView.color = setCard.color;
        cardView.matched = NO;
        cardView.chosen = NO;
    }
    [self updateUI];
}


- (void)updateUI
{
    
    for (SetCardView *cardView in self.setCardViews) {
        int cardIndex = [self.setCardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        cardView.chosen = card.chosen;
        cardView.matched = card.matched;
        
        SetCard *setCard = (SetCard *)card;
        cardView.symbol = setCard.symbol;
        cardView.number = setCard.number;
        cardView.shading = setCard.shading;
        cardView.color = setCard.color;
        
        if (card.matched)
        {
//            [self.game removeCardAtIndex:cardIndex];
//            [self.setCardViews removeObjectAtIndex:cardIndex];
            [cardView removeFromSuperview];
        //    [self.setCardViews removeObject:cardView];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


- (NSInteger)numberOfCards
{
    if (!_numberOfCards) _numberOfCards = 0;
    return _numberOfCards;
}


- (NSMutableArray *)setCardViews
{
    if (!_setCardViews) _setCardViews = [[NSMutableArray alloc] init];
    return _setCardViews;
}

- (UIView *)cardAreaView
{
    if (!_cardAreaView) _cardAreaView = [[UIView alloc]init];
    return _cardAreaView;
}


- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck    // abstract
{
    self.deck = [[SetCardDeck alloc] init];
    return self.deck;
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    SetCardView *view = (SetCardView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        int cardIndex = [self.setCardViews indexOfObject:view];
        Card *card = [self.game cardAtIndex:cardIndex];
        
        if (!card.matched)
        {
            if (card.chosen)
            {
                card.chosen = !card.chosen;
            }
            else
            {
                [self.game chooseCardAtIndex:cardIndex];
            }
            [self updateUI];
        }
    }
}



@end
