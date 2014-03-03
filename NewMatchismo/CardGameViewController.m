//
//  CardGameViewController.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-2-16.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"
#import "PlayingCardView.h"
#import "Grid.h"

@interface CardGameViewController ()

- (IBAction)touchRestartButton:(UIButton *)sender;

@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;

@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSMutableArray *playingCardViews;

@property (strong, nonatomic) UIView *cardAreaView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int gameMode;

@end

@implementation CardGameViewController



#define WIDTH_SIZE 4
#define HEIGHT_SIZE 3


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    Grid *grid = [[Grid alloc] init];
    CGSize cardArea;
    cardArea.width = 280;
    cardArea.height = 320;
    grid.size = cardArea;
    grid.cellAspectRatio = (CGFloat)(2.0)/(3.0);
    grid.minimumNumberOfCells = 12;
    
    CGSize cellSize = grid.cellSize;
    NSUInteger rowCount = grid.rowCount;
    NSUInteger columnCount = grid.columnCount;
    
    
    CGPoint cardAreaViewCenter;
    cardAreaViewCenter.x = 20;
    cardAreaViewCenter.y = 70;
    self.cardAreaView.center = cardAreaViewCenter;
    [self.view addSubview:self.cardAreaView];
    

    for (NSUInteger row = 0; row < rowCount; row++)
    {
        for (NSUInteger column = 0; column < columnCount; column++)
        {
            CGRect frame = [grid frameOfCellAtRow:row inColumn:column];
            PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:frame];
            
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:cardView action:@selector(tap:)];
            [cardView addGestureRecognizer:tgr];
            
            [self.cardAreaView addSubview:cardView];
            [self.playingCardViews addObject:cardView];
            
        }
    }
}


- (void)tap:(UITapGestureRecognizer *)gesture
{
    int a = 1;
    a++;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *) playingCardViews
{
    _playingCardViews = [[NSMutableArray alloc] init];
    return _playingCardViews;
}

- (UIView *)cardAreaView
{
    if (!_cardAreaView) _cardAreaView = [[UIView alloc]init];
    return _cardAreaView;
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



- (void)drawRandomPlayingCard
{
    Card *card = [self.deck drawRandomCard];
    
}


- (IBAction)touchRestartButton:(UIButton *)sender
{
    [self resetGame];
}

- (IBAction)touchGameModeSwitch:(id)sender
{
    int selectedIndex = [sender selectedSegmentIndex];
    self.gameMode = selectedIndex;
    [self resetGame];
}

- (void) resetGame
{
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardViews count]
                                              usingDeck:[self createDeck]];

    
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


- (void) updateUI
{

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}



@end
