#pragma once
#include "cocos2d.h"
#include "RenderComponent.h"
#include "MoveComponent.h"
#include "HealthComponent.h"
#include "PlayerComponent.h"
#include "TeamComponent.h"
#include "MeleeComponent.h"
#include "GunComponent.h"
#include "AIComponent.h"
#include "MonsterComponent.h"
#include "BulletComponent.h"
#include "SelectionComponent.h"
#include "ItemComponent.h"
#include "CommunicateComponent.h"


NS_CC_BEGIN
class EntityManager;
class Entity :	public CCObject
{
public:
	uint32_t _eid;
	EntityManager* entityManager;


	Entity(uint32_t eid,EntityManager *entityManager);
	~Entity();
	uint32_t getEid();
	RenderComponent* render();
	MoveComponent* move();
	HealthComponent* health();
	PlayerComponent* player();
	TeamComponent* team();
	MeleeComponent* melee();
	GunComponent* gun();
	AIComponent* ai();
	MonsterComponent* monster();
	BulletComponent* bullet();
	SelectionComponent* select();
	ItemComponent* item();
	CommunicateComponent* communicate();
	
	CCArray *getAllEntitiesOnTeam(int team,std::string className);
	Entity *closestEntityOnTeam(int team);
	Entity *playerForTeam(int team);
	CCArray *entitiesWithinRange(float range,int team);
	// implement the "static node()" method manually
	static Entity* create(uint32_t eid,EntityManager *entityManager);
	bool isEqual(const Entity* pObject);
protected:

};

NS_CC_END
