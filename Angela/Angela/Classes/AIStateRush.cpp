#include "AIStateRush.h"
#include "AIStateDefend.h"
#include "SimpleAudioEngine.h"
#include "AIStateMass.h"

USING_NS_CC;


CCString *AIStateRush::name() {
    return  CCString::create("Rush");
}

void AIStateRush::enter() {
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("attack.wav");
}

void AIStateRush::updateEntity(Entity *entity,AISystem *system) {
    
    TeamComponent* team = entity->team();
    PlayerComponent* player = entity->player();
    AIComponent* ai = entity->ai();
    if (!team || !player || !ai) return;
    
	int aitotal = 0;
	int playertotal = 0;
	for(int i = BUILDING_NUM; i<BUILDING_NUM+SPRITE_NUM;i++)
	{
		playertotal += values[0][i];
		aitotal += values[1][i];
	}
    CCArray* enemies = entity->entitiesWithinRange(decks[0].fight.Range*SPEEDRATIO,OPPOSITE_TEAM(team->team));
    if (enemies->count() > 0 &&playertotal>aitotal) {
		AIState *state =  AIStateDefend::create();
		//state->retain();
        system->changeStateForEntity(entity, state);
        return;
    }
	//int total = 0;
	//for(int i = BUILDING_NUM; i<BUILDING_NUM+SPRITE_NUM;i++)
	//{
	//	if(decks[i].selection)
	//		total += decks[i].price;
	//}
	//if (total == 0) {
	////AIState *state =  AIStateMass::create();
 //       //state->retain();
 //       system->changeStateForEntity(entity, AIStateMass::create());
 //       //CCLog("Mass State");
 //       return;
 //   }
    
    player->attacking = true;

    if (aitotal > playertotal) {
		for(int i = BUILDING_NUM; i<BUILDING_NUM+SPRITE_NUM;i++)
		{
			//if(decks[i].selection)
			//{
				system->spawnMonsterForEntity(MonsterType((int)(CCRANDOM_0_1()*SPRITE_NUM)+BUILDING_NUM),entity);
				//break;
			//}
		}
    }    
}

