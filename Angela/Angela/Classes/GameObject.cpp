#include "GameObject.h"

USING_NS_CC;
int COST_QUIRK=10;
int COST_ZAP = 25;
int COST_MUNCH = 50;
int POPU_QUIRK = 2;
int POPU_ZAP = 3;
int POPU_MUNCH = 4;
//int MAX_PEOPLE = 30;
bool GameObject::init(CCString* spriteFrameName)
{       
	this->spriteFrameName = spriteFrameName;
	//this->sprite =  CCSprite::createWithSpriteFrameName(spriteFrameName->getCString());
	//this->layer = layer;
    this->alive = true;
    this->scheduleUpdateWithPriority(1);
	return true;
}
