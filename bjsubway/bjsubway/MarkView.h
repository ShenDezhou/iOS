//
//  MarkView.h
//  bjsubway
//
//  Created by apple on 14/12/5.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Graph.h"
enum SELECT{
    NONE,
    ONE,
    TWO,
};
@interface MarkView : UIView
@property(nonatomic, strong) NSArray* aPointPool;
@property(nonatomic, strong) NSValue* touchPoint;
@property(nonatomic, strong) NSNumber* status;
@property(nonatomic, strong) NSNumber* APoint,*BPoint;
@property(nonatomic, strong)UIBezierPath *aPath;
@property(nonatomic, strong) Graph *g;
- (int)touch:(CGPoint)point;
-(bool) testPoint:(CGPoint) point;
- (void)touchAB:(int)state :(CGPoint)point;
@end
