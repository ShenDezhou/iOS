#pragma once
#include "cocos2d.h"
#include "Component.h"
#include "Constant.h"

NS_CC_BEGIN

class MeleeComponent:public Component
{
public:
 float damage;
bool destroySelf;
 float damageRate;
 float lastDamageTime;
 bool aoe;
CCString* sound;
bool notBullet;

Deck* deck;
Damage* _damage;
MeleeComponent(Deck* deck,Damage* _damage);
static MeleeComponent* create(Deck* deck,Damage* _damage);
MeleeComponent(float damage,bool destroySelf,float damageRate,bool aoe, CCString *sound,bool notBullet);
~MeleeComponent();
CCString* ClassName();
static MeleeComponent* create(float damage,bool destroySelf,float damageRate,bool aoe, CCString *sound,bool notBullet);

};

NS_CC_END