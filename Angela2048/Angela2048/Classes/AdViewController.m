//
//  AdViewController.m
//  Flappy Angela
//
//  Created by apple on 14-5-22.
//
//

#import "AdViewController.h"

@interface AdViewController ()

@end

@implementation AdViewController
{
    ADBannerView *_bannerView;
}

- (void)initializeBanner {
        //以画面直立的方式设定Banner于画面底部
    _bannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(50.0,50.0, self.view.frame.size.height, self.view.frame.size.width )];
        //此Banner所能支援的类型
        _bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, ADBannerContentSizeIdentifier320x50,ADBannerContentSizeIdentifier480x32,nil];
        
        //目前的Banner 类型
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
 
        //设定代理
        _bannerView.delegate = self;
        
        //无法按下触发广告
        _bannerView.userInteractionEnabled = NO;
    
        //设定偏位移量
        _bannerView.frame = CGRectOffset(_bannerView.frame,30, 30);
        
        [self.view addSubview:_bannerView];

 }
- (void)layoutAnimated:(BOOL)animated
{
    NSLog(@"Animated");
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGRect contentFrame = self.view.bounds;
    if (contentFrame.size.width < contentFrame.size.height) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        //contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _bannerView.frame = bannerFrame;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeBanner];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutAnimated:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}
#endif

- (NSUInteger)supportedInterfaceOrientations
{
#ifdef __IPHONE_6_0
    return UIInterfaceOrientationMaskLandscape;
#endif
}

- (BOOL) shouldAutorotate {
    return YES;
}
- (void)viewDidLayoutSubviews
{
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

#pragma mark -
#pragma mark iAd广告代理
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iad bannerViewDidLoadAd");
    [self bannerViewAnimation];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iad didFailToReceiveAd");
    [self layoutAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"actiondidfinish");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bannerViewAnimation {
    
    //动画设定
    [UIView beginAnimations:@"BannerViewAnimation" context:NULL];
    
    //以userInteractionEnabled状态排判断bannerView是否在画面内
    if (_bannerView.userInteractionEnabled) {
        _bannerView.frame = CGRectOffset(_bannerView.frame, 0, 50);
    }
    else {
        CGRect adBannerViewFrame = [_bannerView frame];
        CGRect contentFrame = self.view.bounds;
        adBannerViewFrame.origin.x =( 435-contentFrame.size.width)/2;
        adBannerViewFrame.origin.y = 30;
        [_bannerView setFrame:adBannerViewFrame];
        _bannerView.frame = CGRectOffset(_bannerView.frame, 0, -50);
    }
    
    //开始动画
    [UIView commitAnimations];
    
    //将userInteractionEnabled做反向设定
    _bannerView.userInteractionEnabled = !_bannerView.userInteractionEnabled;
}
//使用者按钮事件
- (IBAction)onButtonPress:(id)sender {
    [self bannerViewAnimation];
}
//画面转动时呼叫的内建函式
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"rotate to interface");
    //还原bannerView预设值
    _bannerView.userInteractionEnabled = NO;
    _bannerView.frame = CGRectOffset(_bannerView.frame, 0,0);
    
    //判断画面是否倾置
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        _bannerView.frame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 32.0);
    }
    else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        _bannerView.frame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 50.0);
    }
    
    //重新设定偏移量
    _bannerView.frame = CGRectOffset(_bannerView.frame, 0, 50);
}
@end
