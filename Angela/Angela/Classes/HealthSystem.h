#pragma once
#include "cocos2d.h"
#include "System.h"
#include "EntityManager.h"
#include "HealthComponent.h"
#include "RenderComponent.h"
#include "SimpleAudioEngine.h"

NS_CC_BEGIN

class HealthSystem:public System
{
public:

	HealthSystem(EntityManager *entityManager,EntityFactory* entityFactory);
	void update(float dt);
	void draw();

	void clean(CCNode* node,void* entity);
	
};

NS_CC_END