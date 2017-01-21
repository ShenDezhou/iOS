#pragma once
#include "cocos2d.h"
#include "Constant.h"
#include "GameObject.h"
#include "TeamComponent.h"
#include "PlayerComponent.h"
#include "AIComponent.h"

NS_CC_BEGIN

class Entity;
class AISystem;

class AIState :public CCObject
{
public:
	bool init();
virtual CCString *name();
virtual void enter();
virtual void exit();
virtual void updateEntity(Entity *entity,AISystem *system)=0;
      // implement the "static node()" method manually
      //CREATE_FUNC(AIState);
};
NS_CC_END