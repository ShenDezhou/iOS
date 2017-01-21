//
//  MarkView.m
//  bjsubway
//
//  Created by apple on 14/12/5.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#import "MarkView.h"
#import "Graph.h"
#import "AppDelegate.h"

@implementation MarkView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        GraphList g;
        AppDelegate* del = [[UIApplication sharedApplication] delegate];
        
        _g = [[Graph alloc]initWithGraphList:(GraphList*)del.graphlist.bytes];

//        [_g printGraph];

//        [_g BFSTraverse];
        
        _aPath = [UIBezierPath bezierPath];
        _status = [NSNumber numberWithInt:NONE];
        
        
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Create an oval shape to draw.
    
    // Set the render colors.
    [[UIColor clearColor] setStroke];
    //[[UIColor redColor] setFill];
    
//    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform.
    //CGContextSaveGState(aRef);
    CGSize rx = [ UIScreen mainScreen ].bounds.size;
    rx = rx.width<rx.height?CGSizeMake(rx.height,rx.width):rx;
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    for (NSString* value in _g.dataware) {
        NSArray* fragments = [value componentsSeparatedByString:@","];
        
        [_aPath moveToPoint: ccp(IS_NORMSCREEN?(([fragments[2] floatValue]+2.0)*568/667-44):([fragments[2] floatValue]+2.0)*rx.width/667,[fragments[3] floatValue]*rx.height/375)];
        [_aPath addArcWithCenter: ccp(IS_NORMSCREEN?([fragments[2] floatValue]*568/667-44):[fragments[2] floatValue]*rx.width/667,[fragments[3] floatValue]*rx.height/375) radius:2.0*rx.width/667 startAngle:0 endAngle:M_PI *2 clockwise:YES];
        
    }
    //CGContextTranslateCTM(aRef, p.x,p.y);
    
    // Adjust the drawing options as needed.
    _aPath.lineWidth = 1;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    //[aPath fill];
    [_aPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}
-(bool) testPoint:(CGPoint) point{
    return [_aPath containsPoint:point];
}
- (int)touch:(CGPoint)point{
    //_touchPoint=[NSValue valueWithCGPoint:point];
    //CGPoint p= [_touchPoint CGPointValue];
    if([_aPath containsPoint:point])
    {
        if([_status intValue]==NONE)
        {
            _APoint = [NSNumber numberWithInt:[_g Locate:_touchPoint.CGPointValue]];
            NSLog(@"POINT:(%d)",[_APoint intValue]);
            _status = [NSNumber numberWithInt:ONE];
            return _APoint.intValue;
        }
        else if([_status intValue]==ONE)
        {
            _BPoint= [NSNumber numberWithInt:[_g Locate:_touchPoint.CGPointValue]];
            NSLog(@"POINT:(%d,%d)",[_APoint intValue],[_BPoint intValue]);
            _status = [NSNumber numberWithInt:TWO];
           return _BPoint.intValue;
        }
    }
    else
        _status = [NSNumber numberWithInt:NONE];
    return -1;
}

- (void)touchAB:(int)state :(CGPoint)point{
    if([_aPath containsPoint:point])
    {
        if(state==NONE)
        {
            _APoint = [NSNumber numberWithInt:[_g Locate:_touchPoint.CGPointValue]];
            NSLog(@"POINT:(%d)",[_APoint intValue]);
            _status = [NSNumber numberWithInt:ONE];
        }
       if(state==ONE)
        {
            _BPoint= [NSNumber numberWithInt:[_g Locate:_touchPoint.CGPointValue]];
            NSLog(@"POINT:(%d,%d)",[_APoint intValue],[_BPoint intValue]);
            _status = [NSNumber numberWithInt:TWO];
        }
    }
    else
        _status = [NSNumber numberWithInt:NONE];
 }

@end
