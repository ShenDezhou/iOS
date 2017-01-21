#pragma once
#include "cocos2d.h"
#include "AIState.h"

NS_CC_BEGIN

class AIStateCounter:public AIState
{
public:
	CCString* name();
	void updateEntity(Entity *entity,AISystem *system);
	      // implement the "static node()" method manually
      CREATE_FUNC(AIStateCounter);
};

NS_CC_END