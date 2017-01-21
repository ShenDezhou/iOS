#include "AIStateCounter.h"
#include "AIStateDefend.h"
#include "Entity.h"
#include "AISystem.h"

USING_NS_CC;


CCString *AIStateCounter::name() {
    return CCString::create("Counter");
}

 void AIStateCounter::updateEntity(Entity *entity,AISystem *system) {
    
    TeamComponent* team = entity->team();
    PlayerComponent* player = entity->player();
    AIComponent* ai = entity->ai();
    if (!team || !player || !ai) return;
    
    CCArray* enemies = entity->entitiesWithinRange(decks[0].fight.Range*SPEEDRATIO,OPPOSITE_TEAM(team->team));
    if (enemies->count() > 0) {
        for(int i = BUILDING_NUM; i<BUILDING_NUM+SPRITE_NUM;i++)
		{
			if(decks[i].selection && values[0][i] > values[1][i] && player->coins > decks[i].price)
			{
				system->spawnMonsterForEntity(MonsterType(i),entity);
				break;
			}

		}
        system->changeStateForEntity(entity,AIStateDefend::create());
        
    }
    
}

