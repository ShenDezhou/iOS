#include "AppDelegate.h"
//#include "HelloWorldScene.h"
//#include "GameScene.h"
//#include "test\TestScene.h"
//#include "demo\Demo.h"
//#include "demo\bird\FlyBirdGame.h"
#include "FlyBirdGame.h"
#include "KTPlay.h"

USING_NS_CC;

AppDelegate::AppDelegate() {
    
}

AppDelegate::~AppDelegate()
{
}

bool AppDelegate::applicationDidFinishLaunching() {
    // initialize director
    auto director = CCDirector::sharedDirector();
    auto eglView = CCEGLView::sharedOpenGLView();
    
    director->setOpenGLView(eglView);
	
    // turn on display FPS
    director->setDisplayStats(false);
    
    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 30);
    
	CCEGLView::sharedOpenGLView()->setDesignResolutionSize(320, 480, kResolutionExactFit);
    
    
    // create a scene. it's an autorelease object
    //auto scene = HelloWorld::createScene();
	//auto scene = GameScene::createScene();
	//auto scene = Demo::createScene();
	//auto scene = TestScene::createScene();
	auto scene = FlyBirdGame::scene();
    
    // run
    director->runWithScene(scene);
    [KTPlay startWithAppKey:@"2is1j8I"];
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    CCDirector::sharedDirector()->stopAnimation();
    
    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    CCDirector::sharedDirector()->startAnimation();
    
    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
