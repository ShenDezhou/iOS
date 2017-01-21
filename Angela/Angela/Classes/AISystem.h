#pragma once
#include "cocos2d.h"
#include "System.h"
#include "AIState.h"

NS_CC_BEGIN
class Entity;
class EntityManager;
class EntityFactory;

class AISystem :public System
{
public:

 double lastCreateTime[SPRITE_NUM+BUILDING_NUM];

AISystem(EntityManager *entityManager,EntityFactory* entityFactory);
void update(float dt);
void spawnMonsterForEntity(MonsterType monsterType,Entity *entity);
//deprecate since 1.0
void changeStateForEntity(Entity *entity,AIState *state);

 bool handleEconomic(PlayerComponent* player,Deck* deck);
};
NS_CC_END
