#include "AIComponent.h"

USING_NS_CC;

CCString* AIComponent::ClassName()
{
	return CCString::create("AIComponent");
}
AIComponent::AIComponent(AIState *state)
{
	this->state = state;
	this->state->retain();
}
AIComponent* AIComponent::create(AIState *state)
{
	AIComponent *pRet = new AIComponent(state); \
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
	 
AIComponent::~AIComponent()
{
	this->state->release();
}