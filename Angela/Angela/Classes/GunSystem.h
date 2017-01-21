#pragma once
#include "cocos2d.h"
#include "System.h"

NS_CC_BEGIN
class GunSystem:public System
{
public:
	GunSystem(EntityManager *entityManager,EntityFactory *entityFactory);
	void update(float dt) ;
	inline void clean(CCNode* node){
		node->removeFromParentAndCleanup(true);
	}
};

NS_CC_END