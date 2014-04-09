//
//  CardGameViewController.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-16.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "Grid.h"
#import "PlayingCard.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *playingCardViews; //of PlayingCardView
@property (strong, nonatomic) UIView *cardAreaView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) Grid *grid;
@property (nonatomic) NSInteger numberOfCards;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property BOOL piled;

- (IBAction)touchRestartButton:(UIButton *)sender;
@end

@implementation CardGameViewController


- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardAreaView];
        _animator.delegate = self;
    }
    return _animator;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.numberOfCards = 12;
    self.cardAreaView.center = self.view.center;
    [self.cardAreaView setFrame:CGRectMake(20, 70, self.view.bounds.size.width - 40, self.view.bounds.size.height - 160)];

    [self.view addSubview:self.cardAreaView];
    
    [self resetGame];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.cardAreaView setFrame:CGRectMake(20, 70, self.view.bounds.size.width - 40, self.view.bounds.size.height - 160)];
    if (!self.piled)
    {
        [self reCalculateGrid];
    }
    else
    {
        [self animatePileViews:[self.cardAreaView subviews]];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.cardAreaView setFrame:CGRectMake(20, 70, self.view.bounds.size.width - 40, self.view.bounds.size.height - 160)];
    if (!self.piled)
    {
        [self reCalculateGrid];
    }
    else
    {
        [self animatePileViews:[self.cardAreaView subviews]];
    }

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

- (Deck *)createDeck
{
    self.deck = [[PlayingCardDeck alloc] init];
    return self.deck;
}


- (IBAction)touchRestartButton:(UIButton *)sender
{
    [self resetGame];
}

- (void) resetGame
{
    self.piled = NO;
    [[self.cardAreaView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.playingCardViews removeAllObjects];
    
    
    self.numberOfCards = 12;
    
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCards
                                              usingDeck:[self createDeck]];
    
    for (int i = 0; i < self.numberOfCards; i++)
    {
        PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.bounds.size.height, 0, 0)];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [cardView addGestureRecognizer:tgr];
        [cardView addGestureRecognizer:pgr];
        
        [self.cardAreaView addSubview:cardView];
        [self.playingCardViews addObject:cardView];
    }
    
    for (PlayingCardView *cardView in self.playingCardViews) {
        NSInteger cardIndex = [self.playingCardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        PlayingCard *playingCard = (PlayingCard *)card;
        cardView.suit = playingCard.suit;
        cardView.rank = playingCard.rank;
        cardView.faceUp = NO;
        cardView.matched = NO;
    }
    
    [self reCalculateGrid];
    [self updateUI];
}


- (void)resetGrid
{
    self.grid = [[Grid alloc] init];
    self.grid.size = CGSizeMake(self.cardAreaView.frame.size.width, self.cardAreaView.frame.size.height);
    self.grid.cellAspectRatio = (CGFloat)(2.0)/(3.0);
    self.grid.minimumNumberOfCells = self.numberOfCards;
}

- (void)reCalculateGrid
{
    int currentCardNumber = [[self.cardAreaView subviews] count];
    self.numberOfCards = currentCardNumber;
    self.grid.minimumNumberOfCells = self.numberOfCards;
    [self resetGrid];
    
    if ([[self.cardAreaView subviews] count])
    {
        [self animateReSizeViews:[self.cardAreaView subviews]];
    }
}

- (void)animateReSizeViews:(NSArray *)viewsToReSize
{
    NSUInteger rowCount = self.grid.rowCount;
    NSUInteger columnCount = self.grid.columnCount;
    Grid *grid = self.grid;
    int currentCardNumber = [viewsToReSize count];
    
    [UIView animateWithDuration:0.8 animations:^{
        
        int cardCount = 0;
        for (NSUInteger row = 0; row < rowCount; row++)
        {
            for (NSUInteger column = 0; column < columnCount; column++)
            {
                if (cardCount < currentCardNumber)
                {
                    CGRect frame = [grid frameOfCellAtRow:row inColumn:column];
                    [[viewsToReSize objectAtIndex:cardCount] resetFrame:frame];
                }
                cardCount++;
            }
        }
        
    }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)animatePileViews:(NSArray *)viewsToPile
{
    [UIView animateWithDuration:0.8 animations:^{
        for (UIView *card in viewsToPile) {
            int x = self.cardAreaView.center.x;
            int y = self.cardAreaView.frame.origin.y;
            card.center = CGPointMake(x, y);
        }
    }
                     completion:^(BOOL finished) {
                     }];
    
}


- (void) updateUI
{
    for (PlayingCardView *cardView in self.playingCardViews) {
        NSInteger cardIndex = [self.playingCardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        cardView.faceUp = card.chosen;
        cardView.matched = card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.piled)
    {
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            [self reCalculateGrid];
        }
        self.piled = NO;
    }
    else {
        PlayingCardView *view = (PlayingCardView *)recognizer.view;
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            NSInteger cardIndex = [self.playingCardViews indexOfObject:view];
            Card *card = [self.game cardAtIndex:cardIndex];
            if (!card.matched)
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationDuration:0.5f];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                     forView:view cache:YES];
                [UIView setAnimationDelegate:self];
                [UIView commitAnimations];
                
                [self.game chooseCardAtIndex:cardIndex];
                [self updateUI];
            }
        }
    }
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.piled)
    {
        CGPoint gesturePoint = [recognizer locationInView:self.cardAreaView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            for (UIView *card in [self.cardAreaView subviews])
            {
                card.center = gesturePoint;
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            
        }
    }
    
}


- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    if (!self.piled)
    {
        [self animatePileViews:[self.cardAreaView subviews]];
        self.piled = YES;
    }
}


@end
