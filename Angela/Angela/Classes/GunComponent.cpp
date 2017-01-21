#include "GunComponent.h"

USING_NS_CC;

GunComponent::GunComponent(float range,float damage,float damageRate,CCString *sound )
{
  	this->range = range;
	this->damage = damage;
	this->damageRate = damageRate;
	this->sound = sound;
	this->sound->retain();
}
GunComponent* GunComponent::create(float range,float damage,float damageRate,CCString *sound )\
{
	GunComponent *pRet = new GunComponent( range, damage, damageRate,sound); \
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

GunComponent::GunComponent(Deck* deck,Damage* _damage)
{
	this->deck = deck;
	this->_damage = _damage;
}

GunComponent* GunComponent::create(Deck* deck,Damage* _damage)
{
	GunComponent *pRet = new GunComponent(deck,_damage); \
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
 GunComponent::~GunComponent()
{
	this->sound->release();
}
CCString* GunComponent::ClassName()
{
	return CCString::create("GunComponent");
}