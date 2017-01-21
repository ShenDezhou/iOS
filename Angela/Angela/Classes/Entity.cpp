#include "Entity.h"
#include "EntityManager.h"
USING_NS_CC;

Entity::Entity(uint32_t eid,EntityManager *entityManager)
{
	_eid = eid;
	this->entityManager = entityManager;
	this->entityManager->retain();
}
Entity::~Entity()
{
	this->entityManager->release();
}
uint32_t Entity::getEid()
{
	return _eid;
}

RenderComponent* Entity::render() {
    return (RenderComponent*)entityManager->getComponentOfClass("RenderComponent",this);
}

MoveComponent* Entity::move() {
    return (MoveComponent*) entityManager->getComponentOfClass("MoveComponent",this);
}

HealthComponent* Entity::health() {
    return (HealthComponent*)entityManager->getComponentOfClass("HealthComponent",this);
}

PlayerComponent*Entity::player() {
    return (PlayerComponent*) entityManager->getComponentOfClass("PlayerComponent",this);
}

TeamComponent* Entity::team() {
    return (TeamComponent*)entityManager->getComponentOfClass("TeamComponent",this);
}

MeleeComponent* Entity::melee() {
    return (MeleeComponent*) entityManager->getComponentOfClass("MeleeComponent",this);
}

GunComponent* Entity::gun() {
    return (GunComponent*) entityManager->getComponentOfClass("GunComponent",this);
}

 AIComponent* Entity::ai() {
    return (AIComponent*) entityManager->getComponentOfClass("AIComponent",this);
}

MonsterComponent* Entity::monster() {
    return (MonsterComponent*) entityManager->getComponentOfClass("MonsterComponent",this);
}
BulletComponent* Entity::bullet()
{
	return (BulletComponent*) entityManager->getComponentOfClass("BulletComponent",this);
}
SelectionComponent* Entity::select()
{
	return (SelectionComponent*) entityManager->getComponentOfClass("SelectionComponent",this);
}

ItemComponent* Entity::item()
{
	return (ItemComponent*) entityManager->getComponentOfClass("ItemComponent",this);
}
CommunicateComponent* Entity::communicate()
{
	return (CommunicateComponent*) entityManager->getComponentOfClass("CommunicateComponent",this);

}

CCArray* Entity::getAllEntitiesOnTeam(int team,std::string className) {
    
    CCArray* allEntities = entityManager->getAllEntitiesPosessingComponentOfClass(className);
    allEntities->retain();
    CCArray* retval = CCArray::create();
    //for (Entity* entity in allEntites) {
    for(UINT i=0;i< allEntities->count();i++){
		Entity* entity=(Entity*) allEntities->objectAtIndex(i);
		TeamComponent* curTeam = entity->team();
        if (team && curTeam->team == team) {
            retval->addObject(entity);
        }
    }
    allEntities->release();
    return retval;
    
}

Entity* Entity::closestEntityOnTeam(int team) {

    RenderComponent* ourRender = this->render();
    if (!ourRender) return NULL;
    
    Entity* closestEntity = NULL;
    float closestEntityDistance = -1;
    
    CCArray* allEntities = this->getAllEntitiesOnTeam(team,"RenderComponent");
    allEntities->retain();
    //for (Entity* entity in allEntities) {
    for(UINT i=0;i< allEntities->count();i++){
		Entity* entity=(Entity*) allEntities->objectAtIndex(i);
		RenderComponent* otherRender = entity->render();
		BulletComponent* otherBullet = entity->bullet();
		ItemComponent* otherItem = entity->item();
		if(otherBullet||otherItem) continue;
		  float distance = ccpDistance(ourRender->node->getPosition(), otherRender->node->getPosition());
			if (distance < closestEntityDistance || closestEntityDistance == -1) {
				closestEntity = entity;
				closestEntityDistance = distance;
			}
    }
    allEntities->release();
    return closestEntity;
}

Entity* Entity::playerForTeam(int team) {
    CCArray* players = this->getAllEntitiesOnTeam( team,"PlayerComponent");
    return (Entity*)players->objectAtIndex(0);
}

CCArray* Entity::entitiesWithinRange(float range,int team) {
    
    RenderComponent* ourRender = this->render();
    if (!ourRender) return NULL;
    
    CCArray* allEntities = this->getAllEntitiesOnTeam(team,"RenderComponent");
    allEntities->retain();
    CCArray* retval =CCArray::create();
  //  for (Entity* entity in allEntities) {
    for(UINT i=0;i<allEntities->count();i++){
		Entity* entity=(Entity*) allEntities->objectAtIndex(i);
	    	RenderComponent* otherRender = entity->render();
	
		BulletComponent* otherBullet = entity->bullet();
		if(otherBullet) continue;
	        float distance = ccpDistance(ourRender->node->getPosition(), otherRender->node->getPosition());
	        if (distance < range) {
	            retval->addObject(entity);
	        }
    }
    allEntities->release();
    return retval;
}

Entity* Entity::create(uint32_t eid,EntityManager *entityManager)
{
	Entity *pRet = new Entity(eid,entityManager); \
	if (pRet ) \
	{ \
		pRet->autorelease(); \
		return pRet; \
	} \
	else \
	{ \
		delete pRet; \
		pRet = NULL; \
		return NULL; \
	} \
}

bool Entity::isEqual(const Entity* pObject)
{

	if(pObject  && this->_eid == pObject->_eid)
		return true;
	return false;
}
