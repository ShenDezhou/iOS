#include "GameScene.h"
#include "GameLayer.h"

bool GameScene::init(){
	bool bRet=false;
	do{
		CC_BREAK_IF(!CCScene::init());
        CCTextureCache::sharedTextureCache()->addImage("sucai.png");
        CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("sucai.plist");
 
		auto layer=GameLayer::create();
		CC_BREAK_IF(!layer);

		this->addChild(layer);
         

		bRet=true;
	}while(0);
	return bRet;
}