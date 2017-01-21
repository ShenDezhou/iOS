#include "Tiled.h"

const int Tiled::nums[16]={0,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768};
Tiled::Tiled(){
	level=0;
}

bool Tiled::init(){
	bool bRet=false;
	do{
		CC_BREAK_IF(!CCNode::init());

		auto cache=CCSpriteFrameCache::sharedSpriteFrameCache();

		this->backround=CCSprite::createWithSpriteFrame(cache->spriteFrameByName("level0.png"));
		this->backround->setPosition(CCPointZero);
		this->addChild(backround);

		this->label= CCLabelTTF::create(CCString::createWithFormat("%d",Tiled::nums[level])->getCString(), fontname, fontSizeTiny, ccp(26,13), kCCTextAlignmentCenter );;
		this->label->setPosition(CCPointZero);
		this->addChild(label,1);

		bRet=true;
	}while(0);
	return bRet;
}

void Tiled::setLevel(int l){
	auto cache=CCSpriteFrameCache::sharedSpriteFrameCache();
	this->level=l;
	this->backround->setDisplayFrame(cache->spriteFrameByName(CCString::createWithFormat("level%d.png",level)->getCString()));
	this->label->setString(CCString::createWithFormat("%d",Tiled::nums[level])->getCString());
}