#pragma once
#include "cocos2d.h"
#include "AIState.h"
#include "Monster.h"
NS_CC_BEGIN

class AIStateDefend:public AIState
{
public:
CCString *name(); 
void enter();
void updateEntity(Entity *entity,AISystem *system);
      CREATE_FUNC(AIStateDefend);
};

NS_CC_END