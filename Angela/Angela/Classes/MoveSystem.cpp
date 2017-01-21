#include "MoveSystem.h"

USING_NS_CC;

MoveSystem::MoveSystem(EntityManager *entityManager,EntityFactory *entityFactory)
{
	init(entityManager,entityFactory);
}

CCPoint MoveSystem::arriveEntity(Entity * entity,MoveComponent *move,RenderComponent *render)
{
	CCPoint vector = ccpSub(move->moveTarget, render->node->getPosition());
    float distance = ccpLength(vector);
 
    float targetRadius = 5;
    float slowRadius = targetRadius + 25;
    static float timeToTarget = 0.1f;
 
    if (distance < targetRadius) {
        return CCPointZero;
    }
 
    float targetSpeed;
    if (distance > slowRadius) {
        targetSpeed = move->maxVelocity*SPEEDRATIO;
    } else {
        targetSpeed = move->maxVelocity*SPEEDRATIO * distance / slowRadius;
    }
 
    CCPoint targetVelocity = ccpMult(ccpNormalize(vector), targetSpeed);
 
    CCPoint acceleration = ccpMult(ccpSub(targetVelocity, move->velocity), 1/timeToTarget);
    if (ccpLength(acceleration) > move->maxAcceleration) {
        acceleration = ccpMult(ccpNormalize(acceleration), move->maxAcceleration);
    }
    return acceleration;

}

CCPoint MoveSystem::separateEntity(Entity *entity, MoveComponent *move,RenderComponent *render)
{
	//return CCPointZero;
    CCPoint steering = CCPointZero;
    CCArray* entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("RenderComponent");
	for(UINT i=0;i<entities->count();i++){
	//for (Entity * otherEntity in entities) {
 		Entity* otherEntity=  (Entity*)entities->objectAtIndex(i);
        if (otherEntity->_eid == entity->_eid) continue;
        RenderComponent * otherRender = (RenderComponent *)this->entityManager->getComponentOfClass("RenderComponent",otherEntity);
 
        CCPoint direction = ccpSub(render->node->getPosition(), otherRender->node->getPosition());
        
        CCPoint bound = ccp(MAX(render->node->getContentSize().width/2,otherRender->node->getContentSize().width/2),
                            MAX(render->node->getContentSize().width/2,otherRender->node->getContentSize().width/2)/direction.x*direction.y);
        float distance = ccpLength(direction);
        
        static float SEPARATE_THRESHHOLD = ccpLength(bound);
 
        if (distance < SEPARATE_THRESHHOLD) {
            direction = ccpNormalize(direction);
            steering = ccpAdd(steering, ccpMult(direction, move->maxAcceleration));
			return steering;
		}
    }
    return steering;
}

void MoveSystem::update(float dt)
{
 
    CCArray* entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("MoveComponent");
  	for(UINT i=0;i<entities->count();i++){
		Entity* entity=  (Entity*)entities->objectAtIndex(i);
  
        MoveComponent* move = (MoveComponent*) this->entityManager->getComponentOfClass("MoveComponent",entity);
        RenderComponent* render = (RenderComponent*)  this->entityManager->getComponentOfClass("RenderComponent",entity);
        if (!move || !render) continue;
		
 		
        CCPoint arrivePart =this->arriveEntity(entity,move,render);
        CCPoint separatePart =this->separateEntity(entity,move,render);
        CCPoint newAcceleration = ccpAdd(arrivePart, separatePart);
 
        // Update current acceleration based on the above, and clamp
        move->acceleration = ccpAdd(move->acceleration, newAcceleration);
        if (ccpLength(move->acceleration) > move->maxAcceleration) {
            move->acceleration = ccpMult(ccpNormalize(move->acceleration), move->maxAcceleration);
        }
 
        // Update current velocity based on acceleration and dt, and clamp
        move->velocity = ccpAdd(move->velocity, ccpMult(move->acceleration, dt));
        if (ccpLength(move->velocity) > move->maxVelocity*SPEEDRATIO) {
            move->velocity = ccpMult(ccpNormalize(move->velocity), move->maxVelocity*SPEEDRATIO);
        }
		
        // Update position based on velocity
        CCPoint newPosition = ccpAdd(render->node->getPosition(), ccpMult(move->velocity, dt));
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        newPosition.x = MAX(MIN(newPosition.x, winSize.width - render->node->getContentSize().width/2),  render->node->getContentSize().width/2);
        newPosition.y = MAX(MIN(newPosition.y, winSize.height - render->node->getContentSize().height/2), render->node->getContentSize().height/2);
        render->node->setPosition (newPosition);
		
    }
}