#pragma once

#include "cocos2d.h"


extern int COST_QUIRK;
extern int COST_ZAP;
extern int COST_MUNCH;
extern int POPU_QUIRK;
extern int POPU_ZAP;
extern int POPU_MUNCH;

NS_CC_BEGIN


class GameObject:public CCSprite
{
public:
	bool init(CCString* spriteFrameName);

	float curHp;
	float maxHp;
	bool alive;

	int team;
	bool attacking;
  CCString* spriteFrameName;
	int people;
	int maxPeople;
	int coins;
};

NS_CC_END

