#pragma once
#include "cocos2d.h"
#include "System.h"


NS_CC_BEGIN
class Entity;
class EntityManager;
class EntityFactory;

class ItemSystem :public System
{
public:
	float counter;
	
	ItemSystem(EntityManager *entityManager,EntityFactory* entityFactory);
	void update(float dt);
    void notice(const char* notice,CCPoint position);
    inline void clean(CCNode* node){
		node->removeFromParentAndCleanup(true);
	}
};
NS_CC_END

