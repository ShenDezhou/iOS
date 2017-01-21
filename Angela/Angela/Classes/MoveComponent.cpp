#include "MoveComponent.h"

USING_NS_CC;

MoveComponent::MoveComponent(CCPoint moveTarget, float maxVelocity, float maxAcceleration)
{
    this->moveTarget = moveTarget;
    velocity = CCPointZero;
    acceleration = CCPointZero;
    this->maxVelocity = maxVelocity;
    this->maxAcceleration = maxAcceleration;
}

MoveComponent* MoveComponent::create(CCPoint moveTarget, float maxVelocity, float maxAcceleration)
{
	MoveComponent *pRet = new MoveComponent(moveTarget,  maxVelocity,  maxAcceleration); \
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
  	
MoveComponent::~MoveComponent()
{

}
CCString* MoveComponent::ClassName(){
	return CCString::create("MoveComponent");
}