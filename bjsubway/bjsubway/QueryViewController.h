//
//  QueryViewController.h
//  bjsubway
//
//  Created by apple on 14/12/12.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"

@interface QueryViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *zola;
@property (strong, nonatomic) IBOutlet UIButton *goBack;
@property (strong, nonatomic) IBOutlet UIButton *goQuery;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pageNav;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swapGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightswapGesture;

@property(nonatomic, strong) NSNumber* APoint,*BPoint,*PathCount,*KiloCount,*Price,*TimeNeed;
@property(nonatomic, strong) NSArray* Astations;
@property(nonatomic, strong) Graph *g;

@property(nonatomic, strong) NSString *AName,*BName,*PoiDesc,*BusDesc;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
