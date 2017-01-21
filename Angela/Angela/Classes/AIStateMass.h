#pragma once
#include "cocos2d.h"
#include "AIState.h"

NS_CC_BEGIN

class AIStateMass:public AIState
{
public:
CCString *name(); 
void enter();
void updateEntity(Entity *entity,AISystem *system);
     CREATE_FUNC(AIStateMass);

};

NS_CC_END
