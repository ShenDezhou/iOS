#pragma once
#include "cocos2d.h"
#include "Component.h"

NS_CC_BEGIN

class MoveComponent:public Component
{
public:
  CCPoint moveTarget;
 
  CCPoint velocity;
  CCPoint acceleration;
 
  float maxVelocity;
  float maxAcceleration;

  	MoveComponent(CCPoint moveTarget, float maxVelocity, float maxAcceleration);
	static MoveComponent* create(CCPoint moveTarget, float maxVelocity, float maxAcceleration);
  	~MoveComponent();
	CCString* ClassName();
};

NS_CC_END