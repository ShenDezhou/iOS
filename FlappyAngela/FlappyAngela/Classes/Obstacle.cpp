#include "Obstacle.h"
#include "resource.h"

USING_NS_CC;
Obstacle::Obstacle(void)
{
}
void Obstacle::onEnter()
{
	CCNode::onEnter();
	obstacleList = CCArray::create();
	obstacleList->retain();
}


void Obstacle::update()
{
	if (GAME_STATUS != GAME_STATUS_PLAYING)
		return;
	addCount++;
	if (addCount == 60)
	{
		addOne(0);
		addCount = 0;
	}
	for (int i = obstacleList->count() - 1; i >= 0; i--)
	{
		auto s = (CCSprite*)obstacleList->objectAtIndex(i);
		s->setPositionX(s->getPositionX() - 3);
		if (s->getPositionX() < -s->getContentSize().width / 2)
		{
			obstacleList->removeObjectAtIndex(i);
			this->removeChild(s);
		}
	}
}

void Obstacle::addOne(int offsetX)
{
	CCSize size = CCDirector::sharedDirector()->getWinSize();
	auto sprite = CCSprite::create(bird_obstacle_up);
	CCSize spriteSize = sprite->getContentSize();
	obstacleList->addObject(sprite);
	this->addChild(sprite);
	auto sprite2 = CCSprite::create(bird_obstacle_down);
	CCSize spriteSize2 = sprite->getContentSize();
	obstacleList->addObject(sprite2);
	this->addChild(sprite2);
	// set positon
	int maxUpY = size.height + spriteSize.height / 4;
	int minUpY = size.height - spriteSize.height / 4;
	int y1 = CCRANDOM_0_1()*(maxUpY - minUpY) + minUpY;
	int maxDownY = spriteSize.height / 4;
	int minDownY = -spriteSize.height / 4;
	int y2 = CCRANDOM_0_1()*(maxDownY - minDownY) + minDownY;
	if (y1 - y2 - spriteSize.height < 160)
	{
		y2 = y1 - spriteSize.height - 160;
	}
	sprite->setPosition(ccp(size.width + spriteSize.width / 2 + offsetX, y1));
	sprite2->setPosition(ccp(size.width + spriteSize2.width / 2 + offsetX, y2));
}