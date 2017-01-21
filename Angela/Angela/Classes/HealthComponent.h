#pragma once
#include "cocos2d.h"
#include "Component.h"
NS_CC_BEGIN

class HealthComponent:public Component
{
public:
	float curHP;
	float maxHP;
	bool alive;
	HealthComponent(float curHP,float maxHP);	
	static HealthComponent* create(float curHP,float maxHP);
	~HealthComponent();
	CCString* ClassName();
};

NS_CC_END