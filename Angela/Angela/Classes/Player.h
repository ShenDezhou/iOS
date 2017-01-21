#pragma once
#include "cocos2d.h"
#include "GameObject.h"

NS_CC_BEGIN



class Player:public GameObject
{
public:
	//int people;
	//int coins;

	double lastCoinDrop;
	bool create(CCString* spriteFrameName);
};

NS_CC_END