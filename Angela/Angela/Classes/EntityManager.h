#pragma once
#include "cocos2d.h"
#include "Component.h"
#include "Entity.h"
//#include "Box2d.h"
NS_CC_BEGIN

class EntityManager :public CCObject
{
public:

	CCArray* _entities;
    CCDictionary* _componentsByClass;
    uint32_t _lowestUnassignedEid;

	EntityManager();
	~EntityManager();

	uint32_t generateNewEid();
	Entity* createEntity();
	void addComponent(Component* component,Entity * entity);
	CCObject* getComponentOfClass(std::string  className ,Entity *entity);
	void removeEntity(Entity *entity);
	CCArray* getAllEntitiesPosessingComponentOfClass(std::string className);
};

NS_CC_END
