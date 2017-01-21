#pragma once
#include "cocos2d.h"
#include "System.h"


NS_CC_BEGIN
class Entity;
class EntityManager;
class EntityFactory;

class CommunicateSystem :public System
{
public:

    void notice(const char* notice,CCPoint position);
CommunicateSystem(EntityManager *entityManager,EntityFactory* entityFactory);
void update(float dt);
    inline void clean(CCNode* node){
		node->removeFromParentAndCleanup(true);
	}
};
NS_CC_END

