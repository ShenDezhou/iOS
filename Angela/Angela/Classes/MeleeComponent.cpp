#include "MeleeComponent.h"

USING_NS_CC;

MeleeComponent::MeleeComponent(float damage,bool destroySelf,float damageRate,bool aoe, CCString *sound,bool notBullet) {
 
    this->damage = damage;
    this->destroySelf = destroySelf;
    this->damageRate = damageRate;
    this->aoe = aoe;
    this->sound = sound;
    this->sound->retain();
    this->notBullet = notBullet;
 }
MeleeComponent::MeleeComponent(Deck* deck,Damage* _damage)
{
	this->deck = deck;
	this->_damage = _damage;
}

MeleeComponent* MeleeComponent::create(Deck* deck,Damage* _damage)
{
	MeleeComponent *pRet = new MeleeComponent(deck,_damage); \
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
MeleeComponent* MeleeComponent::create(float damage,bool destroySelf,float damageRate,bool aoe, CCString *sound,bool notBullet)
{
	MeleeComponent *pRet = new MeleeComponent(damage, destroySelf, damageRate, aoe, sound,notBullet); \
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

CCString* MeleeComponent::ClassName()
{
	return CCString::create("MeleeComponent");

}

MeleeComponent::~MeleeComponent()
{
	this->sound->release();
}
