#include "HealthSystem.h"

 
USING_NS_CC;
HealthSystem::HealthSystem(EntityManager *entityManager,EntityFactory* entityFactory)
{
	init(entityManager,entityFactory);
	//this->_world = _world;
}
void HealthSystem::update(float dt) {
 

    CCArray * entities =this->entityManager->getAllEntitiesPosessingComponentOfClass("HealthComponent");
	for(UINT i = 0;i<entities->count();i++){
		Entity* entity = (Entity* )entities->objectAtIndex(i);
		entity->retain();
        // 2
        HealthComponent * health = (HealthComponent *)this->entityManager->getComponentOfClass("HealthComponent",entity);
        RenderComponent * render = (RenderComponent *)this->entityManager->getComponentOfClass("RenderComponent",entity);
 
        // 3
        if (!health->alive) return;
        if (health->maxHP  == 0) return;
        if (health->curHP <= 0) {
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("boom.wav");
            health->alive = false;
 
            // 4
            if (render) {            
                render->node->runAction(
                 CCSequence::create(
                  //CCFadeOut::create(0.5),
                   CCCallFuncND::create(this,callfuncND_selector(HealthSystem::clean),entity),NULL));
            } else {
            	  //CCLog("Removing entity:%d",entity->_eid);
				  this->entityManager->removeEntity(entity);

            }
        }
    }    
}
void HealthSystem::draw() {    
	CCArray* entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("HealthComponent");
 	for(UINT i=0;i<entities->count();++i){
		Entity* entity =(Entity* )  entities->objectAtIndex(i);
	        HealthComponent* health = (HealthComponent *)this->entityManager->getComponentOfClass("HealthComponent",entity);
	        RenderComponent* render = (RenderComponent *)this->entityManager->getComponentOfClass("RenderComponent",entity);     
		 //MeleeComponent* melee = (MeleeComponent*)this->entityManager->getComponentOfClass("MeleeComponent",entity);     
	        
		if ( !health || !render) continue;
	 
	        int sX = render->node->getPosition().x - render->node->getContentSize().width*0.35;
	        int eX = render->node->getPosition().x + render->node->getContentSize().width*0.35;
	        int actualY = render->node->getPosition().y + render->node->getContentSize().height*0.55;
	 
	        //static int maxColor = 200;
	        //static int colorBuffer = 0x99;
			float percentage = ((float) health->curHP) / ((float) health->maxHP);
			//CCLog("Health %d,%d",health->curHP, health->maxHP);
	        int actualX = ((eX-sX) * percentage) + sX;
	        //int amtRed = colorBuffer;
	        //int amtGreen = percentage*0xff;

			glLineWidth(1);
	        ccDrawColor4B(189,230,63,255);
	        ccDrawLine(ccp(sX-1, actualY), ccp(sX, actualY));

	        glLineWidth(3);
	        ccDrawColor4B(189,230,63,255);
	        ccDrawLine(ccp(sX, actualY), ccp(actualX, actualY));
        
			if(actualX<eX)
			{
				//amtRed = maxColor + colorBuffer;
				glLineWidth(3);
				ccDrawColor4B(182,59,64,255);
				ccDrawLine(ccp(actualX, actualY), ccp(eX, actualY));
 
				glLineWidth(1);
				ccDrawColor4B(182,59,64,255);
				ccDrawLine(ccp(eX, actualY), ccp(eX+1, actualY));
			}
			else
			{
				glLineWidth(1);
				ccDrawColor4B(189,230,63,255);
				ccDrawLine(ccp(eX, actualY), ccp(eX+1, actualY));
			}
     }
}
void HealthSystem::clean(CCNode* node,void* entity)
{
	//entityFactory->createExplosion(((Entity*)entity)->team()->team,node->getPosition());
	entityFactory->createEffect(EffectTypeExplosion,node->getPosition());
	node->removeFromParentAndCleanup(true);
	Entity* _entity = ((Entity*)entity);
	TeamComponent* team = _entity->team();
	MonsterComponent* monster = _entity->monster();
	if(monster)
	{
		values[team->team-1][(int)monster->monsterType] -= monster->monster->deck->price;
		//CCLog("%d team: %d stat",team->team,values[team->team-1][(int)monster->monsterType]);
	}
	CCArray* entities = entityManager->getAllEntitiesPosessingComponentOfClass("PlayerComponent");
	CCObject* object = NULL;
	CCARRAY_FOREACH(entities,object){    
		Entity* _entity = (Entity*) object;
       	 TeamComponent* team = _entity->team();
		if(((Entity*)entity)->team()->team == team->team)
		{
			PlayerComponent* player =_entity->player();
			MonsterComponent* monster = ((Entity*)entity)->monster();
			if(player &&monster)
			{
				player->people -= monster->monster->deck->fight.FoodCap;	
				player->RefreshOverload();
			}
			break;
		}
	}


	this->entityManager->removeEntity((Entity*)entity);

}