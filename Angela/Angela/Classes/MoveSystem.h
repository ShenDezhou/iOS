#pragma once
#include "cocos2d.h"
#include "system.h"
#include "Entity.h"
#include "EntityManager.h"
#include "RenderComponent.h"
#include "HealthComponent.h"
#include "MoveComponent.h"

NS_CC_BEGIN


class MoveSystem : public System
{
public:
	MoveSystem(EntityManager *entityManager,EntityFactory *entityFactory);
	CCPoint arriveEntity(Entity * entity,MoveComponent *move,RenderComponent *render);
	CCPoint separateEntity(Entity *entity, MoveComponent *move,RenderComponent *render);
	void update(float dt);
};

NS_CC_END