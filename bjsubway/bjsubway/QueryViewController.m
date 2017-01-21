//
//  QueryViewController.m
//  bjsubway
//
//  Created by apple on 14/12/12.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#import "QueryViewController.h"
#import "AppDelegate.h"
@interface QueryViewController ()

@property (strong, nonatomic) IBOutlet UIView *basicInfoView;
@property (strong, nonatomic) IBOutlet UILabel *zolaInfo;

@property (strong, nonatomic) IBOutlet UITextField *sourceText;
@property (strong, nonatomic) IBOutlet UIButton *source;
@property (strong, nonatomic) IBOutlet UIButton *dest;
@property (strong, nonatomic) IBOutlet UIButton *stations;
@property (strong, nonatomic) IBOutlet UITextField *destText;
@property (strong, nonatomic) IBOutlet UIButton *kilometers;
@property (strong, nonatomic) IBOutlet UIButton *priceOfTicket;
@property (strong, nonatomic) IBOutlet UIButton *timeForTrip;
@property (strong, nonatomic) IBOutlet UIButton *arriveTime;
@property (strong, nonatomic) IBOutlet UITextField *countText;
@property (strong, nonatomic) IBOutlet UITextField *priceText;
@property (strong, nonatomic) IBOutlet UITextView *poiText;
@property (strong, nonatomic) IBOutlet UIPageControl *resultPage;
@property (strong, nonatomic) IBOutlet UITextField *distText;
@end

@implementation QueryViewController
- (IBAction)onSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if(_resultPage.currentPage ==0)
            _resultPage.currentPage=_resultPage.numberOfPages-1;
        else if(_resultPage.currentPage >0)
            _resultPage.currentPage=_resultPage.currentPage-1;
        NSLog(@"swipe up...up...up.");
    }else if(sender.direction == UISwipeGestureRecognizerDirectionLeft){
        if(_resultPage.currentPage <_resultPage.numberOfPages-1)
            _resultPage.currentPage=_resultPage.currentPage+1;
        else if(_resultPage.currentPage ==_resultPage.numberOfPages-1)
            _resultPage.currentPage=0;

        NSLog(@"swipe down...down...down.");
    }

    int poicount =[_PoiDesc  isEqual:@""]?0:(int)([_PoiDesc componentsSeparatedByString:@"\n\n\n"].count-1);
    int buscount =[_BusDesc  isEqual:@""]?0:(int)([_BusDesc componentsSeparatedByString:@"\n\n\n"].count-1);
    float labelfontSize = 16.0;
    if(!IS_NORMSCREEN)
        labelfontSize = 19.0;

    if(_resultPage.currentPage ==0)
    {
        _zolaInfo.text =@"查看出口信息请点击这里➡️";
//        _zolaInfo.textColor = [UIColor brownColor];
        _zolaInfo.font = [UIFont systemFontOfSize:labelfontSize];
    }
    if(_resultPage.currentPage==poicount)
    {
        _zolaInfo.text =@"查看公交信息请点击这里➡️";
//        _zolaInfo.textColor = [UIColor brownColor];
        _zolaInfo.font = [UIFont systemFontOfSize:labelfontSize];
    }
    if(_resultPage.currentPage==poicount+buscount)
    {
        _zolaInfo.text =@"查看路径信息请点击这里➡️";
//        _zolaInfo.textColor = [UIColor brownColor];
        _zolaInfo.font = [UIFont systemFontOfSize:labelfontSize];
    }
    if(_resultPage.currentPage==poicount+buscount+1)
    {
        _zolaInfo.text =@"查看导航信息请点击这里➡️";
        //        _zolaInfo.textColor = [UIColor brownColor];
        _zolaInfo.font = [UIFont systemFontOfSize:labelfontSize];
    }

    float fontSize = 16.0;
    if(!IS_NORMSCREEN)
        fontSize = 22.0;
    if(_resultPage.currentPage==0)
    {
        _basicInfoView.hidden = false;
        _poiText.hidden = true;
    }else if(_resultPage.currentPage>0&&_resultPage.currentPage<poicount+1)
    {
        _poiText.hidden = false;
        _basicInfoView.hidden = true;
            NSArray* parts =[_PoiDesc componentsSeparatedByString:@"\n\n\n"];
            _poiText.text = parts[_resultPage.currentPage-1];
            _poiText.textColor = [UIColor brownColor];
            _poiText.font = [UIFont systemFontOfSize:fontSize];
        
    }else if(_resultPage.currentPage>poicount&&_resultPage.currentPage<poicount+buscount+1)
    {
        _poiText.hidden = false;
        _basicInfoView.hidden = true;
            NSArray* parts =[_BusDesc componentsSeparatedByString:@"\n\n\n"];
            _poiText.text = parts[_resultPage.currentPage-poicount-1];
            _poiText.textColor = [UIColor brownColor];
            _poiText.font = [UIFont systemFontOfSize:fontSize];

    }else if(_resultPage.currentPage==poicount+buscount+1)
    {
        _poiText.hidden = false;
        _basicInfoView.hidden = true;

        NSMutableString *text = [NSMutableString stringWithCapacity:1000];
        int i=[_Astations count]-1;
        while(i>=0)
        {
            if(i==[_Astations count]-1)
                [text appendString:@"起点→"];
            else if(i==0)
                [text appendString:@"终点←"];
            else
            {
                [text appendString:@"      "];
                if(![_Astations[i] hasPrefix:@"⇅"])
                    [text appendString:@"↓"];
            }
            [text appendString:_Astations[i]];
            
            [text appendString:@"\n"];
            i--;
        }
        
        [text appendString:@"\n⇄:换乘站，路线仅供参考。"];
        _poiText.text = text;
        _poiText.textColor = [UIColor brownColor];
        _poiText.font = [UIFont systemFontOfSize:fontSize];
        
    }
    

}
- (IBAction)onZola:(UIButton *)sender {
    if(_resultPage.currentPage <_resultPage.numberOfPages-1)
        _resultPage.currentPage=_resultPage.currentPage+1;
    else if(_resultPage.currentPage ==_resultPage.numberOfPages-1)
        _resultPage.currentPage=0;
    NSLog(@"zola");
    [self onSwipe:nil];
}
- (IBAction)onNavigated:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==0)
    {
            if(_resultPage.currentPage ==0)
                _resultPage.currentPage=_resultPage.numberOfPages-1;
            else if(_resultPage.currentPage >0)
                _resultPage.currentPage=_resultPage.currentPage-1;
            NSLog(@"GO Left");
    }else  if(sender.selectedSegmentIndex==1)
    {
            if(_resultPage.currentPage <_resultPage.numberOfPages-1)
                _resultPage.currentPage=_resultPage.currentPage+1;
            else if(_resultPage.currentPage ==_resultPage.numberOfPages-1)
                _resultPage.currentPage=0;
            NSLog(@"Go Right");
    }

    [self onSwipe:nil];
}
- (IBAction)onInformation:(UIButton *)sender {
    //[self onQuery:nil];
    NSDate *arrive = [[NSDate date ] addTimeInterval:_TimeNeed.floatValue*3600];
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"HH:mm"];
    NSString *dateString=[dateFormtter stringFromDate:arrive];
    
    NSMutableString *text = [NSMutableString stringWithCapacity:1000];
    int i=[_Astations count]-1;
    while(i>=0)
    {
        if(i==[_Astations count]-1)
            [text appendString:@"起点→"];
        else
        {
            if(![_Astations[i] hasPrefix:@"⇅"])
                [text appendString:@"→"];
        }
        [text appendString:_Astations[i]];
        if(i==0)
            [text appendString:@"→终点"];
        
//        [text appendString:@","];
        i--;
    }

    NSString* message = [NSString stringWithFormat:@"起点：%@ 终点：%@ 途径：%@站 里程：%@公里 票价：%@元 预计时间：%d分 预计到达时间：%@ 路线：%@",_AName,_BName,_PathCount,_KiloCount,_Price,(int)(_TimeNeed.floatValue*60),dateString,text];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"详细提示"
                          
                                                   message:message
                          
                                                  delegate:nil
                          
                                         cancelButtonTitle:@"关闭"
                          
                                         otherButtonTitles:nil];
    
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate* del = [[UIApplication sharedApplication] delegate];
    del.rate = [NSNumber numberWithInt:(int)buttonIndex];
    if(buttonIndex==0)
    {
        del.willNotice =[NSNumber numberWithDouble:([[NSDate date] timeIntervalSince1970]+60*60*24)];
        [self addLocalNotification:nil];

    }
    if(buttonIndex==1)
    {
        del.willNotice =[NSNumber numberWithDouble:([[NSDate date] timeIntervalSince1970]+60*60*24*7)];
    }
    if(buttonIndex==2)
    {
        NSString * appstoreUrlString = @"itmss://itunes.apple.com/us/app/de-tie-zhu-shou-zuo-la/id957194113?mt=8";
        
        NSURL * url = [NSURL URLWithString:appstoreUrlString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
            del.rate = [NSNumber numberWithInt:NOTYET];
        }
    }
    
    
}
-(void)addLocalNotification:(NSDate*) when{
    //    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types==UIUserNotificationTypeNone) {
    //        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    //    }
    //定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置调用时间
    if(!when)
        notification.fireDate=when;
    else
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:600.0];//通知触发的时间，10s以后
    notification.repeatInterval=1;//通知重复次数
    //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    //设置通知属性
//    NSString* station;
//    NSString* message;
    
//    for(int j=0;j<3;j++)
//    {
//        AppDelegate* del = [[UIApplication sharedApplication] delegate];
//        
//        GraphList* graph=(GraphList*)del.graphlist.bytes;

//        int random=arc4random()%graph->numVertexes;
//        station= graph->adjList[random];
//        message = @"";
//        NSMutableString* desc = [NSMutableString stringWithCapacity:1000];
//        for(int i=0;i<graph.poiware.count;i++)
//            if([(NSString*)graph.poiware[i] hasPrefix:station])
//            {
//                [desc deleteCharactersInRange:NSMakeRange(0, [desc length])];
//                if([message length]!=0)
//                    [desc appendString:message];
//                if([graph.poiware[i] hasSuffix:@"@"])
//                    continue;
//                [desc appendString:graph.poiware[i]];
//                message =[NSString stringWithFormat:@"%@",desc];
//            }
//        if(![message isEqualToString:@""])
//            break;
//        
//    }
    
    notification.alertBody=[NSString stringWithFormat:@"地铁宝是以北京地铁为基础的一款导航类APP，提供目的地出口信息、公交换乘信息和到达目的地所需的金额，时间，距离等信息。适合地铁乘客在做地铁前查询到达目的地所需金额，时间，以及要到达目的地的出站口信息：饭店、公园，和出口换乘公交。"]; //通知主体
    notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
    //    notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    //    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    
    //设置用户信息
    //    notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他附加信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (IBAction)onQuery:(UIButton*)sender {
    AppDelegate* del = [[UIApplication sharedApplication] delegate];
    if((del.rate.intValue == NOSTATUS||
        del.rate.intValue == ONEWEEKLATER
        ||del.rate.intValue== NOTYET)&& ([[NSDate date] timeIntervalSince1970]> del.willNotice.doubleValue))
    {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                              
                                                       message:@"如果你觉得这个程序好用，可以移步appstore评论区来吐槽。"
                              
                                                      delegate:self
                              
                                             cancelButtonTitle:@"果断拒绝"
                              
                                             otherButtonTitles:@"一周后提醒我",@"好吧,去评论",nil];
        
        [alert show];
    }
    
    
    
    _countText.text = [_PathCount stringValue];
    int price=0;
    if(_KiloCount.floatValue<=6)
        price = 3;
    else if(_KiloCount.floatValue<=12)
        price = 4;
    else if(_KiloCount.floatValue<=32)
    {
        price = 4 + (_KiloCount.floatValue-12+10)/10;
    }
    else
    {
        price = 7 +(_KiloCount.floatValue-32+20)/20;
    }
    _Price = [NSNumber numberWithInt:price];
    
    float timeNeed = 0;
    timeNeed = _KiloCount.floatValue / 35 + _PathCount.floatValue/ 120.0;
    _TimeNeed = [NSNumber numberWithFloat:timeNeed];
    
    _priceText.text = [NSString stringWithFormat:@"%d",price];
    //_poiText.text = _PoiDesc;
    _distText.text = [NSString stringWithFormat:@"%.2fkm",_KiloCount.floatValue];
    
    [_priceOfTicket setTitle:[NSString stringWithFormat:@"%d元",price] forState:UIControlStateNormal];
    [_kilometers setTitle:[NSString stringWithFormat:@"%.0f公里",_KiloCount.floatValue] forState:UIControlStateNormal];
    [_stations setTitle:[NSString stringWithFormat:@"%@站",[_PathCount stringValue]] forState:UIControlStateNormal];
    if(timeNeed>1)
        [_timeForTrip setTitle:[NSString stringWithFormat:@"%d时%2d分",(int)(timeNeed*60)/60,(int)(timeNeed*60)%60] forState:UIControlStateNormal];
    else
        [_timeForTrip setTitle:[NSString stringWithFormat:@"%2d分",(int)(timeNeed*60)] forState:UIControlStateNormal];
    NSDate *arrive = [[NSDate date] addTimeInterval:timeNeed*3600];
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"HH:mm"];
    NSString *dateString=[dateFormtter stringFromDate:arrive];
    [_arriveTime setTitle:[NSString stringWithFormat:@"%@",dateString ] forState:UIControlStateNormal];
}
- (IBAction)onBack:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
-(void)makeRound:(UIButton* )button setTitle:(NSString*) title{
    if(IS_NORMSCREEN)
        button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    button.layer.masksToBounds = true;
    button.layer.cornerRadius = button.bounds.size.width/2;
    [button setTitle:title forState:UIControlStateNormal];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"zola"],
                         [UIImage imageNamed:@"zola1"],nil];
    _zola.animationImages = gifArray;
    _zola.animationDuration = 5;
    [_zola startAnimating];

    // Do any additional setup after loading the view.
    [self makeRound:_source setTitle:_AName];
    [self makeRound:_dest setTitle:_BName];
    [self makeRound:_stations setTitle:@""];
    [self makeRound:_kilometers setTitle:@""];
    [self makeRound:_priceOfTicket setTitle:@""];
    [self makeRound:_timeForTrip setTitle:@""];
    [self makeRound:_arriveTime setTitle:@""];
    [self makeRound:_goQuery setTitle:@"查询"];
    [self makeRound:_goBack setTitle:@"返回"];
 
    _sourceText.text =_AName;
    _destText.text = _BName;
    int poicount =[_PoiDesc  isEqual:@""]?0:(int)([_PoiDesc componentsSeparatedByString:@"\n\n\n"].count-1);
    int buscount =[_BusDesc  isEqual:@""]?0:(int)([_BusDesc componentsSeparatedByString:@"\n\n\n"].count-1);
    _resultPage.numberOfPages =2+poicount+buscount;
    
    float labelfontSize = 16.0;
    if(!IS_NORMSCREEN)
        labelfontSize = 19.0;
    
    if(_resultPage.currentPage ==0)
    {
        _zolaInfo.text =@"查看出口信息请点击这里➡️";
        //        _zolaInfo.textColor = [UIColor brownColor];
        _zolaInfo.font = [UIFont systemFontOfSize:labelfontSize];
    }
    if(_resultPage.currentPage==poicount)
    {
        _zolaInfo.text =@"查看公交信息请点击这里➡️";
        //        _zolaInfo.textColor = [UIColor brownColor];
        _zolaInfo.font = [UIFont systemFontOfSize:labelfontSize];
    }

    [NSTimer scheduledTimerWithTimeInterval:0.5
             target:self selector:@selector(flashingZolaInfo:)
             userInfo:nil repeats:YES];
    [self onQuery:nil];

}
- (void)flashingZolaInfo:(NSTimer*)theTimer {
    if([_zolaInfo.text hasSuffix:@"➡️"])
        _zolaInfo.text = [_zolaInfo.text substringWithRange:NSMakeRange(0, _zolaInfo.text.length-2)];
    else
        _zolaInfo.text = [NSString stringWithFormat:@"%@%@",_zolaInfo.text,@"➡️"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
