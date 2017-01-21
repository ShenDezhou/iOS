#pragma once

#include "cocos2d.h"
#include "Entity.h"
#include "EntityManager.h"
#include "RenderComponent.h"
#include "HealthComponent.h"
#include "MoveComponent.h"
#include "GunComponent.h"
#include "SelectionComponent.h"
#include "math.h"

NS_CC_BEGIN
class Entity;
class EntityManager;


class EntityFactory:  public CCObject
{
public:
	EntityManager* _entityManager;
	
       CCSpriteBatchNode* _batchNode;
	CCDictionary* _particleNodes;
	EntityFactory(EntityManager *entityManager,CCSpriteBatchNode *batchNode);
	void AddBatchNode(CCNode* batchNode,std::string key);
	CCParticleBatchNode* GetBatchNode(std::string key);
	~EntityFactory();
	Entity* createHumanPlayer();
	Entity* createAIPlayer();
	Entity* createMonsterWithTeam(MonsterType monsterType,int team);

	
	Entity* createLaserWithTeam(int team);

	Entity* createItemWithTeam(ItemType ItemType,int team);
	void createEffect(EffectType effectType,CCPoint position);

};

NS_CC_END
