//
//  SetCardView.m
//  NewMatchismo
//
//  Created by hcfilippo on 14-3-4.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView


- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    [self setNeedsDisplay];
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

#define SYMBOL_DIAMOND 0
#define SYMBOL_OVAL 1
#define SYMBOL_SQUIGGLE 2

#define COLOR_RED 0
#define COLOR_PURPLE 1
#define COLOR_GREEN 2

#define SHADING_UNFILLED 0
#define SHADING_SOLID 1
#define SHADING_STRIPED 2

#define NUMBER_1 0
#define NUMBER_2 1
#define NUMBER_3 2


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.color == COLOR_RED)
    {
        CGContextSetRGBStrokeColor(context, 0.9, 0, 0, 1.0);
        CGContextSetRGBFillColor(context, 0.9, 0, 0, 1.0);
    }
    else if (self.color == COLOR_PURPLE)
    {
        CGContextSetRGBStrokeColor(context, 0.4, 0, 0.4, 1.0);
        CGContextSetRGBFillColor(context, 0.4, 0, 0.4, 1.0);
    }
    else if (self.color == COLOR_GREEN)
    {
        CGContextSetRGBStrokeColor(context, 0.6, 0.9, 0, 1.0);
        CGContextSetRGBFillColor(context, 0.6, 0.9, 0, 1.0);
    }
    
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    path.lineWidth = 3;
    
    if (self.symbol == SYMBOL_DIAMOND)
    {
        if (self.number != NUMBER_1)
        [self drawDiamond:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                     path:path];
        if (self.number != NUMBER_2)
        [self drawDiamond:CGRectMake(self.bounds.origin.x + self.bounds.size.width / 3, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                     path:path];
        if (self.number != NUMBER_1)
        [self drawDiamond:CGRectMake(self.bounds.origin.x + self.bounds.size.width * 2 / 3, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                     path:path];
    }
    else if (self.symbol == SYMBOL_OVAL)
    {
        if (self.number != NUMBER_1)
        [self drawOval:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                  path:path];
        if (self.number != NUMBER_2)
        [self drawOval:CGRectMake(self.bounds.origin.x + self.bounds.size.width / 3, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                  path:path];
        if (self.number != NUMBER_1)
        [self drawOval:CGRectMake(self.bounds.origin.x + self.bounds.size.width * 2 / 3, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                  path:path];
    }
    else if (self.symbol == SYMBOL_SQUIGGLE)
    {
        if (self.number != NUMBER_1)
        [self drawSquiggle:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                      path:path];
        if (self.number != NUMBER_2)
        [self drawSquiggle:CGRectMake(self.bounds.origin.x + self.bounds.size.width / 3, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                      path:path];
        if (self.number != NUMBER_1)
        [self drawSquiggle:CGRectMake(self.bounds.origin.x + self.bounds.size.width * 2 / 3, self.bounds.origin.y, self.bounds.size.width / 3, self.bounds.size.height)
                      path:path];
    }
    
    
    if (self.shading == SHADING_UNFILLED)
    {
        //do nothing
    }
    if (self.shading == SHADING_SOLID)
    {
        [path fill];
    }
    else if (self.shading == SHADING_STRIPED)
    {
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        for (CGFloat x = 0.1; x < 1.0; x = x + 0.1)
        {
            [stripes moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * x)];
            [stripes addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * x)];
        }
        [stripes stroke];
    }
    
    
    if (self.chosen) {
        self.alpha = 0.5;
    }
    else {
        self.alpha = 1;
    }
    
}

#define EDGE_RATIO 0.1

- (UIBezierPath *)drawDiamond:(CGRect)rect path:(UIBezierPath *)path
{
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * EDGE_RATIO)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - EDGE_RATIO), rect.origin.y + rect.size.height / 2)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * (1 - EDGE_RATIO))];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * EDGE_RATIO, rect.origin.y + rect.size.height / 2)];
    [path closePath];
    [path stroke];
    return path;
}


- (CGFloat) ovalRadius:(CGFloat)rectWidth
{
    return rectWidth * EDGE_RATIO * 2;
}

- (UIBezierPath *)drawOval:(CGRect)rect path:(UIBezierPath *)path
{
    CGFloat OVAL_RADIUS = [self ovalRadius:rect.size.width];
//    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 - OVAL_RADIUS, rect.origin.y + rect.size.height * EDGE_RATIO + OVAL_RADIUS)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 - OVAL_RADIUS, rect.origin.y + rect.size.height * (1 - EDGE_RATIO) - OVAL_RADIUS)];
    [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 + OVAL_RADIUS, rect.origin.y + rect.size.height * (1 - EDGE_RATIO) - OVAL_RADIUS)
            controlPoint1:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * (1 - EDGE_RATIO))
            controlPoint2:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * (1 - EDGE_RATIO))];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 + OVAL_RADIUS, rect.origin.y + rect.size.height * EDGE_RATIO + OVAL_RADIUS)];
    
    [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 - OVAL_RADIUS, rect.origin.y + rect.size.height * EDGE_RATIO + OVAL_RADIUS)
            controlPoint1:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * EDGE_RATIO)
            controlPoint2:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * EDGE_RATIO)];
    [path closePath];
    [path stroke];
    return path;
}

- (CGFloat) squiggleWidth:(CGFloat)rectWidth
{
    return rectWidth * EDGE_RATIO * 3;
}

- (CGFloat) squiggleArcOffset:(CGFloat)rectWidth
{
    return rectWidth * EDGE_RATIO;
}

- (UIBezierPath *)drawSquiggle:(CGRect)rect path:(UIBezierPath *)path
{
    CGFloat SQUIGGLE_ARC_OFFSET = [self squiggleArcOffset:rect.size.width];
    CGFloat SQUIGGLE_WIDTH = [self squiggleWidth:rect.size.width];
//    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * EDGE_RATIO)];
    [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2)
            controlPoint1:CGPointMake(rect.origin.x + rect.size.width / 2 - SQUIGGLE_ARC_OFFSET, rect.origin.y + rect.size.height * EDGE_RATIO + (0.5 - EDGE_RATIO) / 3 * rect.size.height)
            controlPoint2:CGPointMake(rect.origin.x + rect.size.width / 2 - SQUIGGLE_ARC_OFFSET, rect.origin.y + rect.size.height * EDGE_RATIO + (0.5 - EDGE_RATIO) * 2 / 3 * rect.size.height)];
    [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height * (1 - EDGE_RATIO))
            controlPoint1:CGPointMake(rect.origin.x + rect.size.width / 2 + SQUIGGLE_ARC_OFFSET, rect.origin.y + rect.size.height / 2 + (0.5 - EDGE_RATIO) / 3 * rect.size.height)
            controlPoint2:CGPointMake(rect.origin.x + rect.size.width / 2 + SQUIGGLE_ARC_OFFSET, rect.origin.y + rect.size.height / 2 + (0.5 - EDGE_RATIO) * 2 / 3 * rect.size.height)];
    
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 + SQUIGGLE_WIDTH, rect.origin.y + rect.size.height * (1 - EDGE_RATIO))];
    
    [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 + SQUIGGLE_WIDTH, rect.origin.y + rect.size.height / 2)
            controlPoint1:CGPointMake(rect.origin.x + rect.size.width / 2 + SQUIGGLE_ARC_OFFSET + SQUIGGLE_WIDTH, rect.origin.y + rect.size.height / 2 + (0.5 - EDGE_RATIO) * 2 * rect.size.height / 3)
            controlPoint2:CGPointMake(rect.origin.x + rect.size.width / 2 + SQUIGGLE_ARC_OFFSET + SQUIGGLE_WIDTH, rect.origin.y + rect.size.height / 2 + (0.5 - EDGE_RATIO) * rect.size.height / 3)];
    
    [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2 + SQUIGGLE_WIDTH, rect.origin.y + rect.size.height * EDGE_RATIO)
            controlPoint1:CGPointMake(rect.origin.x + rect.size.width / 2 - SQUIGGLE_ARC_OFFSET + SQUIGGLE_WIDTH, rect.origin.y + rect.size.height * EDGE_RATIO + (0.5 - EDGE_RATIO) * 2 * rect.size.height / 3)
            controlPoint2:CGPointMake(rect.origin.x + rect.size.width / 2 - SQUIGGLE_ARC_OFFSET + SQUIGGLE_WIDTH, rect.origin.y + rect.size.height * EDGE_RATIO + (0.5 - EDGE_RATIO) * rect.size.height / 3)];
    [path closePath];
    [path stroke];
    
    return path;
}

#pragma mark - Gesture


#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = [UIColor blackColor];
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

#pragma mark - ReSize

- (id)resetFrame:(CGRect)frame
{
    [super setFrame:frame];
    return self;
}


@end
