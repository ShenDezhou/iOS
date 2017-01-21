#include "HealthComponent.h"

USING_NS_CC;

HealthComponent::HealthComponent(float curHP,float maxHP)
{
	this->curHP = curHP;
	this->maxHP = maxHP;
	alive = true;
}
HealthComponent* HealthComponent::create(float curHP,float maxHP)
{	
	HealthComponent *pRet = new HealthComponent(curHP,maxHP); \
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
CCString* HealthComponent::ClassName()
{
	return new CCString("HealthComponent");
}

HealthComponent::~HealthComponent(){}