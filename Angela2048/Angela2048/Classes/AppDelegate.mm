#include "AppDelegate.h"
//#include "LoadingScene.h"
#include "GameScene.h"
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
    //director->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);

    // create a scene. it's an autorelease object
    auto scene = GameScene::create();

	CCEGLView::sharedOpenGLView()->setDesignResolutionSize(435,640,kResolutionExactFit);
    // run
    director->runWithScene(scene);
    [KTPlay startWithAppKey:@"zE2Hra"];

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    CCDirector::sharedDirector()->stopAnimation();

    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    CCDirector::sharedDirector()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
