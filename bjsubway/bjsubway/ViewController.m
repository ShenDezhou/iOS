//
//  ViewController.m
//  bjsubway
//
//  Created by apple on 14/11/30.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#import "ViewController.h"
#import "QueryViewController.h"
#import "AppDelegate.h"
@interface ViewController ()
@property (nonatomic, strong) NSValue* l2center;
@property (nonatomic, strong) NSNumber* viewstate;
@property (strong, nonatomic) IBOutlet MarkView *mkView;
@property (nonatomic) BOOL bannerVisible;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _stepper.minimumValue = 1;
    _stepper.maximumValue = 2;
    _l2center = [NSValue valueWithCGPoint:self.view.center];
    enum ViewState currentStatus=LOADED;
    _viewstate = [[NSNumber alloc] initWithInt:currentStatus];
    _mkView = [_mkView initWithFrame:self.view.frame];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    [components setDay:18];
//    schedule = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];
//    [self addLocalNotification:schedule];
//    _adBanner
//    = [[ADBannerView alloc] initWithFrame:CGRectZero];
//    
    _adBanner.frame
    = CGRectMake((self.view.frame.size.width-320)/2,-50,320,50);
//
//    _adBanner.requiredContentSizeIdentifiers
//    = [NSSet
//       
//       setWithObject:ADBannerContentSizeIdentifier320x50];
//    
//    _adBanner.currentContentSizeIdentifier
//    = ADBannerContentSizeIdentifier320x50;
//    
//    [self.view
//     addSubview:_adBanner];
//    
//    _adBanner.delegate=self;

    self.bannerVisible=NO;
    [NSTimer scheduledTimerWithTimeInterval:60.0
                                     target:self selector:@selector(addAd:)
                                   userInfo:nil repeats:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Responding to gestures

/*
 In response to a tap gesture, show the image view appropriately then make it fade out in place.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender{
    QueryViewController* query = (QueryViewController*)segue.destinationViewController;
    query.APoint = _mkView.APoint;
    query.BPoint = _mkView.BPoint;
    
    //GraphList* graph=[[_mkView.g graph]pointerValue];
    AppDelegate* del = [[UIApplication sharedApplication] delegate];
    
    GraphList* graph=(GraphList*)del.graphlist.bytes;
    //graph->numVertexes = _mkView.g.numVertexes.intValue;
    //graph->numEdges = _mkView.g.numEdges.intValue;
#ifdef DEBUG
    printf("vertex info:%d,%d\n", graph->numVertexes, graph->numEdges);
#endif
    Distance d = [_mkView.g Path:graph :[_mkView.APoint  intValue]:[_mkView.BPoint intValue]];
    NSMutableString* stanames = [NSMutableString stringWithCapacity:1000];
    for (int i =0; i<d.count; i++) {
        if([_mkView.g isTransfer:d.route[i]]&&i!=0)
            [stanames appendString:@"⇅"];
        [stanames appendString:[_mkView.g NameByIndex:d.route[i]]];
        [stanames appendString:@","];
    }
    [stanames appendString:[_mkView.g NameByIndex:d.route[d.count]]];
    
    query.Astations = [stanames componentsSeparatedByString:@","];
    query.PathCount =  [[NSNumber alloc] initWithInt:d.count];
    query.KiloCount =  [[NSNumber alloc] initWithFloat:d.weight];
    char* aName = graph->adjList[[_mkView.APoint intValue]].data.staname;
    //    int anameLen = graph->adjList[[_mkView.APoint intValue]].data.lenname;
    //    query.AName = [[NSString alloc]initWithBytes:aName length:anameLen encoding:NSUTF8StringEncoding];
    query.AName = [NSString stringWithUTF8String:aName];
    char* bName = graph->adjList[[_mkView.BPoint intValue]].data.staname;
    //    int bnameLen = graph->adjList[[_mkView.BPoint intValue]].data.lenname;
    //    query.BName = [[NSString alloc]initWithBytes:bName length:bnameLen encoding:NSUTF8StringEncoding];
    query.BName = [NSString stringWithUTF8String:bName];
//    char* poidesc =graph->adjList[[_mkView.BPoint intValue]].data.poidesc;
    query.PoiDesc =@"";
    query.BusDesc =@"";
    NSString* poi = [NSString stringWithFormat:@"%@@",query.BName];
    NSMutableString* desc = [NSMutableString stringWithCapacity:1000];
    int lastIndex=0;
    for(int i=0;i<_mkView.g.poiware.count;i++)
        if([(NSString*)_mkView.g.poiware[i] hasPrefix:poi])
        {
            [desc deleteCharactersInRange:NSMakeRange(0, [desc length])];
            if([query.PoiDesc length]!=0)
                [desc appendString:query.PoiDesc];
            if([_mkView.g.poiware[i] hasSuffix:@"@"])
                continue;
            if([_mkView.g.poiware[i] isEqualToString:_mkView.g.poiware[lastIndex]])
               continue;
            [desc appendString:_mkView.g.poiware[i]];
            [desc replaceOccurrencesOfString:@"@" withString:@":\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [desc length])];
            //            desc = [desc stringByReplacingOccurrencesOfString:@"@" withString:@":\n"];
            //            NSLog(@"OKOKOKOK%d,%@",i,(NSString*)_mkView.g.poiware[i]);
            
            //            if([desc containsString:@";"])
            //            {
            //                desc = [desc stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
            [desc replaceOccurrencesOfString:@";" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [desc length])];
            //                NSLog(@"OKOKOKOK%d,%@",i,(NSString*)_mkView.g.poiware[i]);
            query.PoiDesc =[NSString stringWithFormat:@"%@\n\n",desc];
            //            }
            lastIndex = i;

        }
    
    [desc deleteCharactersInRange:NSMakeRange(0, [desc length])];
    for(int i=0;i<_mkView.g.busware.count;i++)
        if([(NSString*)_mkView.g.busware[i] hasPrefix:poi])
        {
            //            NSString* desc = (NSString*)_mkView.g.busware[i];
            //            desc = [desc stringByReplacingOccurrencesOfString:@"@" withString:@":\n"];
            //            NSMutableString* desc = [NSMutableString stringWithString:(NSString*)_mkView.g.busware[i]];
            [desc deleteCharactersInRange:NSMakeRange(0, [desc length])];
            if([query.BusDesc length]!=0)
                [desc appendString:query.BusDesc];
            [desc appendString:@"公交线路-"];
            [desc appendString:_mkView.g.busware[i]];
            [desc replaceOccurrencesOfString:@"@" withString:@":\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [desc length])];
            //            if([desc containsString:@";"])
            //            {
            //                desc = [desc stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
            [desc replaceOccurrencesOfString:@";" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [desc length])];
            query.BusDesc =[NSString stringWithFormat:@"%@\n\n",desc];
            //            }
        }
    NSLog(@"MAGIC:%@,%@,%@\n",query.AName,query.BName, query.PoiDesc);
    
    //    [_mkView.g printGraph];
}

- (IBAction)onPinched:(UIPinchGestureRecognizer *)sender {
    if(sender.state==UIGestureRecognizerStateEnded)
    {
        if((sender.velocity>0&&_viewstate.intValue == ZOOMIN)
           ||(sender.velocity<0&&_viewstate.intValue == LOADED))
            return;
        
        if(sender.velocity>0)
        {
            _viewstate = [NSNumber numberWithInt:ZOOMIN];
            _stepper.value =ZOOMIN;
        }
        else
        {
            _viewstate = [NSNumber numberWithInt:LOADED];
            _stepper.value =LOADED;
        }
        if(_viewstate.intValue==ZOOMIN)
        {
            [_mkView.aPath applyTransform:CGAffineTransformMakeScale(2.0f, 2.0f)];
//            CGPoint vector = ccpSub(ccp(0,0),self.imageView.center);
            [UIView animateWithDuration:0.5 animations:^{
                CGRect r = self.imageView.frame;
                r.origin = CGPointMake(-r.size.width/2, -r.size.height/2);
                r.size = CGSizeMake(r.size.width*2, r.size.height*2);
                self.imageView.frame = r;
                self.mkView.frame = r;
                _l2center = [NSValue valueWithCGPoint:self.imageView.center];
            }];
            
        }else if(_viewstate.intValue==LOADED)
        {
            [_mkView.aPath applyTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
            [UIView animateWithDuration:0.5 animations:^{
                CGRect r = self.imageView.frame;
                r.origin = ccp(0,0);
                r.size = CGSizeMake(r.size.width/2, r.size.height/2);
                self.imageView.frame = r;
                self.mkView.frame = r;
                _l2center = [NSValue valueWithCGPoint:self.imageView.center];
            }];
        }

    }
}
- (IBAction)onTapped:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint locInVector = [sender locationInView:self.imageView];
    enum ViewState cur = _viewstate.intValue;
    //    if(cur!=LOADED)
    //    {
    //        _mkView.touchPoint = mp(locInVector.x/2,locInVector.y/2);
    //        [_mkView touch:locInVector];
    //    }
    
    _mkView.touchPoint = mp(locInVector.x/_viewstate.intValue,locInVector.y/_viewstate.intValue);
    _touchPoint = mp(locInVector.x,locInVector.y);
    //state
    if(cur==LOADED)
    {
        [_mkView.aPath applyTransform:CGAffineTransformMakeScale(2.0f, 2.0f)];
        enum ViewState currentStatus=ZOOMIN;
        _viewstate = [[NSNumber alloc] initWithInt:currentStatus];
        
        CGPoint vector = ccpSub(location,self.imageView.center);
        [UIView animateWithDuration:0.5 animations:^{
            CGRect r = self.imageView.frame;
            if(vector.x>0&&vector.y>0)
            {
                r.origin = CGPointMake(-r.size.width, -r.size.height);
                
            }
            if(vector.x<0&&vector.y>0)
            {
                r.origin = CGPointMake(0, -r.size.height);
                
            }
            if(vector.x<0&&vector.y<0)
            {
                r.origin = CGPointMake(0, 0);
                
            }
            if(vector.x>0&&vector.y<0)
            {
                r.origin = CGPointMake(-r.size.width, 0);
                
            }
            r.size = CGSizeMake(r.size.width*2, r.size.height*2);
            self.imageView.frame = r;
            self.mkView.frame = r;
            _l2center = [NSValue valueWithCGPoint:self.imageView.center];
        }];
        
    }
    else if(cur==ZOOMIN)
    {
        if([_mkView testPoint:locInVector])
        {
            if([_mkView.status intValue]==NONE)
            {
                //                _Start.hidden = false;
                //                _Start.center = ccpAdd(locInVector,ccp(0,- _Start.bounds.size.height/2));
                [_mkView touchAB:NONE :_touchPoint.CGPointValue];
                _Flag.hidden = false;
                _Flag.center =  ccpAdd(_touchPoint.CGPointValue,ccp(0,- _Flag.bounds.size.height/2));
                
            }else if([_mkView.status intValue]==ONE)
            {
                _End.hidden = false;
                _End.center =  ccpAdd(locInVector,ccp(0,- _End.bounds.size.height/2));
            }
        }else{
            [_pointSelector removeAllSegments];
            _touchPointNearBy = [_mkView.g Nearby:[_mkView.touchPoint CGPointValue]];
            for (int i=0; i<[_touchPointNearBy count]; i++) {
                NearBy *value = [_touchPointNearBy[i] pointerValue];
                NSString *name = [NSString stringWithCString:value->staname encoding:NSUTF8StringEncoding];
                [_pointSelector insertSegmentWithTitle:name atIndex:i animated:false];
            }
            if([_touchPointNearBy count]>1)
            {
                _pointSelector.center =  ccpAdd(_touchPoint.CGPointValue,ccp(0,- _pointSelector.bounds.size.height/2));
                _pointSelector.hidden = false;
                //_End.hidden = true;
            }
            if([_touchPointNearBy count]==1)
            {
                NearBy* value = [_touchPointNearBy[0] pointerValue];
                _mkView.touchPoint = [NSValue valueWithCGPoint:value->pos];
                
                if([_mkView.status intValue]==NONE)
                {
                    [_mkView touchAB:NONE :ccpMult(value->pos,2)];

                    _Flag.hidden = false;
                    _Flag.center =  ccpAdd(ccpMult(value->pos,2),ccp(0,- _Flag.bounds.size.height/2));
                    
                }else if([_mkView.status intValue]==ONE)
                {
                    [_mkView touchAB:ONE :ccpMult(value->pos,2)];

                    _End.hidden = false;
                    _End.center =  ccpAdd(ccpMult(value->pos,2),ccp(0,- _End.bounds.size.height/2));
                }
                _pointSelector.hidden = true;
            }
        }
        //         [_mkView touch:locInVector];
    }
    
    _stepper.value =_viewstate.doubleValue;
    
    //    if([_mkView.status intValue]==TWO)
    //    {
    //        [self performSegueWithIdentifier:@"query" sender:self];
    //        _mkView.status = [NSNumber numberWithInt:NONE];
    //    }
    printf("(%.1f,%.1f),\n",locInVector.x,locInVector.y);
    
}

- (IBAction)onSelectStation:(UISegmentedControl *)sender {
    NearBy* value = [_touchPointNearBy[sender.selectedSegmentIndex] pointerValue];
    _mkView.touchPoint = [NSValue valueWithCGPoint:value->pos];

    if([_mkView.status intValue]==NONE)
    {
        [_mkView touchAB:NONE :ccpMult(value->pos,2)];

        _Flag.hidden = false;
        _Flag.center =  ccpAdd(ccpMult(value->pos,2),ccp(0,- _Flag.bounds.size.height/2));
        
    }else if([_mkView.status intValue]==ONE)
    {
        _End.hidden = false;
        _End.center =  ccpAdd(ccpMult(value->pos,2),ccp(0,- _End.bounds.size.height/2));
    }
    _pointSelector.hidden = true;
}

- (IBAction)onDragged:(UIPanGestureRecognizer *)sender {
    if(_viewstate.intValue==ZOOMIN)
    {
        
        CGPoint location = [sender translationInView:self.imageView];
        printf("location:(%.1f,%.1f),\n",location.x,location.y);
        CGPoint c = ccpAdd(location, self.imageView.center );
        CGRect r = self.imageView.frame;
        
        if(c.x<0||c.y<0||c.x>r.size.width/2||c.y>r.size.height/2)
            ;
        else
        {
            self.imageView.center = c;
            self.mkView.center = c;
            //            self.stepper.center = c;
        }
        //_l2center = [NSValue valueWithCGPoint:self.imageView.center];
        [sender setTranslation:ccp(0,0) inView:self.imageView];
    }
    
}
- (IBAction)onZoomed:(UIStepper *)sender {
    _viewstate = [NSNumber numberWithDouble:sender.value];
    if(_viewstate.intValue==ZOOMIN)
    {
        [_mkView.aPath applyTransform:CGAffineTransformMakeScale(2.0f, 2.0f)];
//        CGPoint vector = ccpSub(ccp(0,0),self.imageView.center);
        [UIView animateWithDuration:0.5 animations:^{
            CGRect r = self.imageView.frame;
            r.origin = CGPointMake(-r.size.width/2, -r.size.height/2);
            r.size = CGSizeMake(r.size.width*2, r.size.height*2);
            self.imageView.frame = r;
            self.mkView.frame = r;
            _l2center = [NSValue valueWithCGPoint:self.imageView.center];
        }];
        
    }else if(_viewstate.intValue==LOADED)
    {
        [_mkView.aPath applyTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect r = self.imageView.frame;
            r.origin = ccp(0,0);
            r.size = CGSizeMake(r.size.width/2, r.size.height/2);
            self.imageView.frame = r;
            self.mkView.frame = r;
            _l2center = [NSValue valueWithCGPoint:self.imageView.center];
        }];
    }
    [self removeAd:nil];
}

- (IBAction)onSelectEnd:(UISegmentedControl *)sender {
    sender.hidden = true;
    [_mkView touchAB:(int)sender.selectedSegmentIndex :ccpMult([_mkView.touchPoint CGPointValue],2)];
    
    if([_mkView.status intValue]==TWO)
    {
        _Flag.hidden = true;
        [self performSegueWithIdentifier:@"query" sender:self];
        _mkView.status = [NSNumber numberWithInt:NONE];
    }else
        _Flag.center = ccpAdd(_touchPoint.CGPointValue,ccp(0,- _Flag.bounds.size.height/2));
    
    
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
//    NSLog(@"BANNER:%@ is loading ad.\n",banner);
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    NSLog(@"BANNER:%@ is loaded with ad.\n",banner);
    if(!self.bannerVisible)
    {
        
        [UIView
         beginAnimations:@"animateAdBannerOn"
         
         context:NULL];
        
        //banner is invisible now and moved out of the screen on 50 px
        
        banner.frame
        = CGRectOffset(banner.frame, 0, 50);
        
        [UIView
         commitAnimations];
        
        self.bannerVisible
        = YES;
    }
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner
               willLeaveApplication:(BOOL)willLeave{
//    NSLog(@"BANNER:%@,leaving app:%d\n",banner,willLeave);
    _adBanner.hidden = true;
    return true;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
//    NSLog(@"BANNER:%@ back.\n",banner);
}

- (void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"BANNER:%@ met error:%@.\n",banner,error);
    if(self.bannerVisible)
    {
        [UIView
         beginAnimations:@"animateAdBannerOff"
         
         context:NULL];
        
        //banner is visible and we move it out of the screen, due to connection issue
        
        banner.frame
        = CGRectOffset(banner.frame, 0, -50);
        
        [UIView
         commitAnimations];
        
        self.bannerVisible
        = NO;
        
    }
}
- (void)addAd:(NSTimer*)theTimer {
    if(_adBanner.hidden )
    {
        _adBanner.hidden = false;
    }
}
- (void)removeAd:(NSTimer*)theTimer {
    _adBanner.hidden = true;
}

@end
