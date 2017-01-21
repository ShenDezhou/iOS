#include "MeleeSystem.h"
#include "SimpleAudioEngine.h"
USING_NS_CC;

MeleeSystem::MeleeSystem(EntityManager *entityManager,EntityFactory *entityFactory)
{
	init(entityManager,entityFactory);
}
void MeleeSystem::update(float dt) {
       
    CCArray * entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("MeleeComponent");
    CCObject* object = NULL;
    CCARRAY_FOREACH(entities, object)
    {
        Entity* entity = (Entity*) object;
		
        RenderComponent* render = entity->render();
        MeleeComponent* melee = entity->melee();
        TeamComponent* team = entity->team();
        if (!render || !melee || !team) continue;
        
        bool aoeDamageCaused = false;
        CCArray * enemies = entity->getAllEntitiesOnTeam(OPPOSITE_TEAM(team->team),"RenderComponent");
        CCObject* temp = NULL;
        CCARRAY_FOREACH(enemies, temp){
            Entity* enemy = (Entity*) temp;
	        RenderComponent * enemyRender = enemy->render();
            HealthComponent * enemyHealth = enemy->health();
	     
            if (!enemyRender || !enemyHealth) continue;

			float distance = ccpDistance(render->node->getPosition(), enemyRender->node->getPosition());
			MonsterComponent* monsterCom = entity->monster();
            if (render->node->boundingBox().intersectsRect(enemyRender->node->boundingBox())
				||monsterCom && abs(distance) < monsterCom->monster->deck->fight.Range) {
                if (GetTickCount() - melee->_damage->lastDamageTime > melee->deck->fight.FireRate * 1000) {
                    CCPoint edge = ccp((render->node->getPosition().x+enemyRender->node->getPosition().x)/2,
						(render->node->getPosition().y+enemyRender->node->getPosition().y)/2);
					//make slow enemy
					MoveComponent* move = (MoveComponent*) enemy->move();
					if(move)
						move->velocity = ccpNormalize(move->velocity) ; 
#if SOUND
                    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect(melee->deck->sound);
#endif
					
            

					//MonsterComponent* enemyMonster = enemy->monster();
					//if(enemyMonster)
					//{
					//	CCPoint currrent = enemyRender->node->getPosition();
					//	//float scale = enemyRender->node->getScale();
					//	CCScaleTo* a = CCScaleBy::create(0.1f,1.5f);
					//	int ran = rand()%2;
					//	CCRotateTo* b = CCRotateTo::create(0.1f,ran?15:-15);
					//	//CCRotateTo* c = CCRotateTo::create(0.1f,-30);
					//	CCRotateTo* d = CCRotateTo::create(0.1f,0);
					//	CCScaleTo* e = CCScaleTo::create(0.1f,1.0f);
					//	CCSequence* sequence = CCSequence::create(a,b,d,e,NULL);
					//	enemyRender->node->runAction(sequence);
					//			
					//}

					MonsterComponent* monster = entity->monster();
					if(monster)
					{
						entityFactory->createEffect(EffectType((int)monster->monsterType +4),edge);
					}
					if (melee->deck->fight.aoe) {
		                        aoeDamageCaused = true;
		                    } else {
		                        melee->_damage->lastDamageTime = GetTickCount();
		                    }
		                    enemyHealth->curHP -= (int)(melee->deck->fight.Damage*(1+CCRANDOM_MINUS1_1()*0.1));
					char temp[64];
					sprintf(temp, "%d", (int)(melee->deck->fight.Damage*(1+CCRANDOM_MINUS1_1()*0.1)));
                    
                    CCLabelTTF* hitLabel =CCLabelTTF::create(temp, fontname, fontSizeBig, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
                    hitLabel->setColor(ccc3(255,0,0));

					//CCLabelBMFont* hitLabel = CCLabelBMFont::create(temp,"Courier_red.fnt");
					hitLabel->setPosition(ccpAdd(enemyRender->node->getPosition(),ccp(0,enemyRender->node->getContentSize().height/2)));
					entityFactory->_batchNode->getParent()->addChild(hitLabel);
					CCScaleTo* scaleFrom = CCScaleTo::create(0.1f,1.5f);
					CCDelayTime* delay = CCDelayTime::create(0.1f);
					CCScaleTo* scaleTo = CCScaleTo::create(0.1f,1.0f);
					CCFiniteTimeAction* actionMoveDone = CCCallFuncN::create(this,callfuncN_selector(MeleeSystem::clean));

					CCSequence* sequence = CCSequence::create(scaleFrom,delay,scaleTo,delay,actionMoveDone,NULL);

					hitLabel->runAction(sequence);

                    if (enemyHealth->curHP < 0) {
                        enemyHealth->curHP = 0;
						if(team->team==1)
						{
							if(CCRANDOM_X_Y(0,3)<1)
							{
								Entity* entity = this->entityFactory->createItemWithTeam(ItemType((int)CCRANDOM_X_Y(0,11)),1);
								RenderComponent* render = (RenderComponent*)entity->render();
								render->node->setPosition (enemyRender->node->getPosition());
							}
						}
                    }
                    if (melee->_damage->destroySelf) {
                        render->node->removeFromParentAndCleanup(true);
                        //CCLog("Removing entity:%d, I am a bullet.",entity->_eid);
                        this->entityManager->removeEntity(entity);
                    }
                }
            }
        }
        
        if (aoeDamageCaused) {
            melee->_damage->lastDamageTime = GetTickCount();
            CCLog("AOEed");
        }
        
    
    }
}
