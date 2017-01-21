#include "GameOverScene.h"

USING_NS_CC;

CCScene* GameOverLayer::scene()
{
	// 'scene' is an autorelease object    
	CCScene *scene = CCScene::create();
	
	GameOverLayer* layer = GameOverLayer::create();	
	// add layer as a child to scene
	scene->addChild(layer);
	// return the scene
	return scene;
}
bool  GameOverLayer::init()
{
	basicSetup();
	return true;
}

void GameOverLayer::GameFinished()
{
    CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
}

void GameOverLayer::basicSetup()
{
	CCSize winSize = CCDirector::sharedDirector()->getWinSize();


	//nodes
	CCSize frameSize = CCEGLView::sharedOpenGLView()->getFrameSize();  
	 // In this demo, we select resource according to the frame's height.
	 // If the resource size is different from design resolution size, you need to set contentScaleFactor.    
	 // We use the ratio of resource's height to the height of design resolution,    
	 // this can make sure that the resource's height could fit for the height of design resolution.     
	 // if the frame's height is larger than the height of medium resource size, select large resource.    
    if(frameSize.width == ip5Resource.size.width)
    {
        CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ip5.plist");
		_batchNodes = CCSpriteBatchNode::create("Sprites1-ip5.pvr.ccz");
        
    }else
    {
        if (frameSize.height > mediumResource.size.height)
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ipadhd.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1-ipadhd.pvr.ccz");
            
//            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites2-ipadhd.plist");
//            CCSpriteBatchNode* _nodes = CCSpriteBatchNode::create("Sprites2-ipadhd.pvr.ccz");
//            
//            for(int i=0;i<_nodes->getChildrenCount();i++)
//            {
//                _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
//                
//            }
            
//            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites3-ipadhd.plist");
//            _nodes = CCSpriteBatchNode::create("Sprites3-ipadhd.pvr.ccz");
//            for(int i=0;i<_nodes->getChildrenCount();i++)
//            {
//                _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
//            }
            //CCFileUtils::sharedFileUtils()->setResourceDirectory(largeResource.directory);
            //pDirector->setContentScaleFactor(largeResource.size.height/designResolutionSize.height);
        }
        // if the frame's height is larger than the height of small resource size, select medium resource.
        else if (frameSize.height > smallResource.size.height)
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ipad.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1-ipad.pvr.ccz");
            //CCFileUtils::sharedFileUtils()->setResourceDirectory(mediumResource.directory);
            //pDirector->setContentScaleFactor(mediumResource.size.height/designResolutionSize.height);
        }
        // if the frame's height is smaller than the height of medium resource size, select small resource.
        else  if (frameSize.height > tinyResource.size.height)
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-hd.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1-hd.pvr.ccz");
            
        }
        else
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1.pvr.ccz");
            //CCFileUtils::sharedFileUtils()->setResourceDirectory(smallResource.directory);        
            //pDirector->setContentScaleFactor(smallResource.size.height/designResolutionSize.height); 
        }
    }
	this->addChild(_batchNodes);
	//_particleNodes = CCDictionary::create();
	//_particleNodes->setObject(CCParticleBatchNode::create("bullet.png"),"bullet");
	//_particleNodes->setObject(CCParticleBatchNode::create("explosion1.png"),"explosion1");
	//_particleNodes->setObject(CCParticleBatchNode::create("explosion2.png"),"explosion2");
	//_particleNodes->setObject(CCParticleBatchNode::create("aoe1.png"),"aoe1");
	//_particleNodes->setObject(CCParticleBatchNode::create("aoe2.png"),"aoe2");
	//_particleNodes->setObject(CCParticleBatchNode::create("coldline1.png"),"coldline1");
	//_particleNodes->setObject(CCParticleBatchNode::create("coldline2.png"),"coldline2");
	//CCDictElement* object = NULL;
	//CCDICT_FOREACH(_particleNodes,object)
	//{
	//	this->addChild((CCParticleBatchNode*)object->getObject());
	//}


   //// Sounds
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("Latin_Industries.mp3");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("bigHit.wav");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("boom.wav");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew.wav");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew2.wav");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("smallHit.wav");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("attack.wav");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("defend.wav");
   // CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("spawn.wav");

	
	//other UI
	CCSprite *background =  CCSprite::createWithSpriteFrameName(backgrounds[(int)CCRANDOM_X_Y(1,3)]);
    background->setPosition(ccp(winSize.width/2, winSize.height/2-yOffset/2));
    this->addChild(background,-1);

	std::string gameword1 = CCUserDefault::sharedUserDefault()->getStringForKey("gameover1");
	std::string gameword2 = CCUserDefault::sharedUserDefault()->getStringForKey("gameover2");

	CCSprite *gameword =  CCSprite::createWithSpriteFrameName(gameresult?gameword1.c_str():gameword2.c_str());
	gameword->setPosition(ccp(winSize.width * 0.5, winSize.height * 0.5));
	this->addChild(gameword);
	

	//CCLabelBMFont* guide = CCLabelBMFont::create(gameresult?gameword1.c_str():gameword2.c_str(),fontfile,winSize.width * 0.25,kCCTextAlignmentLeft);
	////CCLabelTTF* guide = CCLabelTTF::create(gameresult?"You've won the battle!":"Mission failed!", "Helvetica", 12, ccp(MARGIN * 4,2*MARGIN), kCCTextAlignmentLeft );
	//guide->setPosition(ccp(winSize.width * 0.5, winSize.height * 0.5));
 //   this->addChild(guide);

	this->setTouchEnabled(true);
	
	int store = CCUserDefault::sharedUserDefault()->getIntegerForKey("level");
	if(gameresult&&g_level+1>store)
	{
		CCUserDefault::sharedUserDefault()->setIntegerForKey("level",g_level+1);
	}

}
void GameOverLayer::registerWithTouchDispatcher()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}
bool GameOverLayer::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
	CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
	return true;
}