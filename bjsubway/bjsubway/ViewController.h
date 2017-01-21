//
//  ViewController.h
//  bjsubway
//
//  Created by apple on 14/11/30.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//
#import <math.h>
#import "MarkView.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

enum ViewState{
    LOADED=1,
    ZOOMIN,
    ZOOMOUT
};
@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) IBOutlet ADBannerView *adBanner;

- (void)addAd:(NSTimer*)theTimer ;
- (void)removeAd:(NSTimer*)theTimer;
- (IBAction)onTapped:(UITapGestureRecognizer *)sender;
- (IBAction)onDragged:(UIPanGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pointSelector;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UISegmentedControl *End;
@property (strong, nonatomic) IBOutlet UIImageView *Flag;
@property(nonatomic, strong) NSValue* touchPoint;
@property(nonatomic, strong) NSArray* touchPointNearBy;
@end
#define ccp CGPointMake
#define mp(x,y) [NSValue valueWithCGPoint:ccp((x),(y))]
/** Returns opposite of point.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpNeg(const CGPoint v)    //计算关于原点的对称点
{
    return ccp(-v.x, -v.y);
}
/** Calculates sum of two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpAdd(const CGPoint v1, const CGPoint v2)//计算两个向量的和
{
    return ccp(v1.x + v2.x, v1.y + v2.y);
}
/** Calculates difference of two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpSub(const CGPoint v1, const CGPoint v2)// 计算两个向量的差
{
    return ccp(v1.x - v2.x, v1.y - v2.y);
}
/** Returns point multiplied by given factor.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpMult(const CGPoint v, const CGFloat s)// 给定一个因子，算向量的倍数
{
    return ccp(v.x*s, v.y*s);
}
/** Calculates midpoint between two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpMidpoint(const CGPoint v1, const CGPoint v2)// 计算两个点得中心点
{
    return ccpMult(ccpAdd(v1, v2), 0.5f);
}
/** Calculates distance between point an origin
 @return float
 @since v2.1.4
 */
static inline float ccpDistance(const CGPoint v1, const CGPoint v2) {
    CGPoint atob = ccpSub(v1, v2);
    return sqrtf(atob.x*atob.x + atob.y*atob.y);
};
