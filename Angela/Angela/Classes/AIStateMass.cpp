#include "AIStateMass.h"
#include "AISystem.h"
#include "AIStateDefend.h"
#include "AIStateCounter.h"
#include "SimpleAudioEngine.h"

USING_NS_CC;

CCString *AIStateMass::name() {
    return  CCString::create("Mass");
}

void AIStateMass::enter() {
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("mass.wav");
    //CCLog("Mass State");
}

 void AIStateMass::updateEntity(Entity *entity,AISystem *system) {
    
    TeamComponent* team = entity->team();
    PlayerComponent* player = entity->player();
    AIComponent* ai = entity->ai();
    if (!team || !player || !ai) return;
    
    CCArray* enemies = entity->entitiesWithinRange(decks[0].fight.Range*SPEEDRATIO,OPPOSITE_TEAM(team->team));
    if (enemies->count() > 0) {
        system->changeStateForEntity(entity,AIStateDefend::create());
        //CCLog("Defend State");
        return;
    }
 
//	int total = 0;
//	for(int i = BUILDING_NUM; i<g_level&& i<BUILDING_NUM+SPRITE_NUM;i++)
//	{
//		//if(decks[i].selection)
//			total += decks[i].price;
//	}
//	if (player->coins > total) {
//		//AIState *state = AIStateCounter::create();
//		//state->retain();
//        //system->changeStateForEntity(entity,AIStateCounter::create());
//        //CCLog("Counter State");
////		for(int i = BUILDING_NUM; i<BUILDING_NUM+SPRITE_NUM;i++)
////		{
//			//if(decks[i].selection)
//        system->spawnMonsterForEntity(MonsterType((int)CCRANDOM_X_Y(BUILDING_NUM, BUILDING_NUM+SPRITE_NUM)),entity);
////		}
////        return;
//    }
    system->spawnMonsterForEntity(MonsterType((int)CCRANDOM_X_Y(BUILDING_NUM, BUILDING_NUM+SPRITE_NUM)),entity);

    player->attacking = false;
    
}