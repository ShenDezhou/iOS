#include "AIStateDefend.h"
#include "SimpleAudioEngine.h"
#include "AIStateRush.h"

USING_NS_CC;

CCString *AIStateDefend::name() {
    return  CCString::create("Defend");
}

void AIStateDefend::enter() {
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("defend.wav");
}

 void AIStateDefend::updateEntity(Entity *entity,AISystem *system) {
    
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
    if (enemies->count() == 0||playertotal<aitotal) {
		system->changeStateForEntity(entity, AIStateRush::create());
        //CCLog("Rush state");
        return;
    }    
    player->attacking = false;
	//generate next monster
	for(int i = BUILDING_NUM; i<SPRITE_NUM+BUILDING_NUM;i++)
	{
		if(decks[i].selection && values[0][i] > values[1][i] && player->coins > decks[i].price)
		{
            system->spawnMonsterForEntity(MonsterType((i+4)%SPRITE_NUM +1),entity);
//			int j = 0;
//			while(!decks[(i+j)%SPRITE_NUM +1].selection)
//				j++;
//			if(decks[(i+j)%SPRITE_NUM +1].selection)
//				system->spawnMonsterForEntity(MonsterType((i+j)%SPRITE_NUM +1),entity);
			break;
		}

	}


}
