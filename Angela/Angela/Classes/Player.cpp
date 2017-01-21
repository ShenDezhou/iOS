#include "Player.h"

USING_NS_CC;

bool Player::create(CCString* spriteFrameName)
{
	if(GameObject::init(spriteFrameName))
	{
		curHp = 200;
        	maxHp = 200;
        	attacking = false;
	}
	return true;
}