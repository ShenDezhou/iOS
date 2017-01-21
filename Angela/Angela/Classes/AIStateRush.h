#pragma once
#include "cocos2d.h"
#include "AIState.h"
#include "AISystem.h"

NS_CC_BEGIN

class AIStateRush:public AIState
{
public:
CCString *name(); 
void enter();
void updateEntity(Entity *entity,AISystem *system);
     CREATE_FUNC(AIStateRush);
};

NS_CC_END
