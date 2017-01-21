#include "AISystem.h"

#include "Entity.h"
#include "EntityManager.h"
#include "EntityFactory.h"
#include "SimpleAudioEngine.h"
#include "AIState.h"
#include "Constant.h"

USING_NS_CC;

AISystem::AISystem(EntityManager *entityManager,EntityFactory* entityFactory)
{
	init(entityManager,entityFactory);
}

void AISystem::update(float dt)
{
    
    CCArray* entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("AIComponent");
    if (entities->count() == 0) return;
    
    Entity* aiEntity = (Entity*)entities->objectAtIndex(0);
    TeamComponent* aiTeam = aiEntity->team();
    AIComponent* ai = aiEntity->ai();
    if (!aiTeam || !ai) return;
  
    ai->state->updateEntity(aiEntity,this);
}

void AISystem::changeStateForEntity(Entity *entity,AIState* state) {
	AIComponent* ai = entity->ai();
    if (!ai) return;
	
	
    ai->state->exit();
    ai->state->release();
	ai->state = state;
    ai->state->retain();
	ai->state->enter();
}
void AISystem::spawnMonsterForEntity(MonsterType monsterType,Entity *entity)
{
    
	if(GetTickCount() - lastCreateTime[int(monsterType)] < decks[int(monsterType)].buildtime * 1000)
		return;
    PlayerComponent* player = entity->player();
  	if(!handleEconomic(player,&decks[(int)monsterType])) return;
#if SOUND
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("spawn.wav");
#endif
	TeamComponent* team = entity->team();
	values[team->team-1][(int)monsterType] += decks[(int)monsterType].price;

    Entity* monster = this->entityFactory->createMonsterWithTeam(monsterType,2);
    RenderComponent* render = monster->render();
    if (render) {
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        float randomOffset = CCRANDOM_X_Y(-winSize.height * 0.25, winSize.height * 0.25);
        render->node->setPosition ( ccp(winSize.width * 0.75, winSize.height * 0.5 + randomOffset));
    }
	lastCreateTime[int(monsterType)] = GetTickCount();
	
}

bool AISystem::handleEconomic(PlayerComponent* player,Deck* deck)
{
    if (!player) return false;
    if (player->coins < deck->price ||player->people + deck->fight.FoodCap > player->maxPeople) return false;
	//if(player->people + monster->people > player->maxPeople) return false;
    player->coins -=  deck->price;
	player->people += deck->fight.FoodCap;
	player->RefreshOverload();
	return true;
}