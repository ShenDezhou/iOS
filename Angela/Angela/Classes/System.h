#pragma once
#include "cocos2d.h"
#include "EntityManager.h"
#include "EntityFactory.h"

NS_CC_BEGIN

class System:public CCObject
{
 public:
	EntityManager* entityManager;
	EntityFactory* entityFactory;
	void init(EntityManager *entityManager,EntityFactory* entityFactory);
	~System();
      virtual void update(float dt)=0;

};

NS_CC_END