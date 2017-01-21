#pragma once
#include "cocos2d.h"
#include "Component.h"
#include "AIState.h"

NS_CC_BEGIN
class AIState;
class AIComponent:public Component
{
public:
	AIState* state;
	AIComponent(AIState *state);
	~AIComponent();
 	CCString* ClassName();
	 static AIComponent* create(AIState *state);
};
NS_CC_END