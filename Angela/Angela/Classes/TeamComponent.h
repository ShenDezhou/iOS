#pragma once
#include "cocos2d.h"
#include "Component.h"
NS_CC_BEGIN
class TeamComponent:public Component
{
public:
	int team;
	TeamComponent(int team);
	static TeamComponent* create(int team);
	CCString* ClassName();
};
NS_CC_END