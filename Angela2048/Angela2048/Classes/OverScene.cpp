#include "OverScene.h"
#include "GameScene.h"

CCScene* OverScene::createScene(){
	auto scene=CCScene::create();

	auto layer=OverScene::create();

	scene->addChild(layer);

	return scene;
}

bool OverScene::init(){
	if(!CCLayer::init()){
		return false;
	}

	CCSize size=CCDirector::sharedDirector()->getVisibleSize();

	auto label=CCLabelTTF::create("GAME OVER", fontname, fontSizeTiny, ccp(26,13), kCCTextAlignmentCenter );
	label->setPosition(CCPoint(size.width/2,size.height/2));
	this->addChild(label);

	auto mLabel=CCLabelTTF::create("Restart", fontname, fontSizeTiny, ccp(26,13), kCCTextAlignmentCenter );
	auto uiRestart=CCMenuItemLabel::create(mLabel,this,menu_selector(OverScene::restartMenu));
	uiRestart->setAnchorPoint(CCPointZero);
	uiRestart->setPosition(CCPointZero);
	auto menu=CCMenu::create(uiRestart,NULL);
	menu->setAnchorPoint(CCPointZero);
	menu->setPosition(CCPoint(10,10));
	this->addChild(menu);
	return true;
}

void OverScene::restartMenu(CCObject *pSender){
	CCDirector::sharedDirector()->replaceScene(CCTransitionFade::create(1.0f,GameScene::create()));
}