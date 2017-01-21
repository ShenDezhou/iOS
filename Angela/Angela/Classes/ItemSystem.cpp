#include "ItemSystem.h"

USING_NS_CC;
ItemSystem::ItemSystem(EntityManager *entityManager,EntityFactory* entityFactory)
{

	init(entityManager,entityFactory);
    counter=0;
}
void ItemSystem::notice(const char* notice,CCPoint position)
{
    CCLabelTTF* hitLabel =CCLabelTTF::create(notice, fontname, fontSizeBig, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
    hitLabel->setColor(ccc3(255,0,0));
    hitLabel->setPosition(position);
    this->entityFactory->_batchNode->getParent()->addChild(hitLabel);
    
    CCScaleTo* scaleFrom = CCScaleTo::create(0.1f,1.5f);
    CCDelayTime* delay = CCDelayTime::create(0.1f);
    CCScaleTo* scaleTo = CCScaleTo::create(0.1f,1.0f);
    CCFiniteTimeAction* actionMoveDone = CCCallFuncN::create(this,callfuncN_selector(ItemSystem::clean));
    
    CCSequence* sequence = CCSequence::create(scaleFrom,delay,scaleTo,delay,actionMoveDone,NULL);
    
    hitLabel->runAction(sequence);
    
    
}

void ItemSystem::update(float dt)
{
	counter+=dt;
	if(counter>3)
	{
		Entity* entity = this->entityFactory->createItemWithTeam(ItemTypeGold,1);
		RenderComponent* render = (RenderComponent*)entity->render();
		 CCSize winSize = CCDirector::sharedDirector()->getWinSize();
		 CCPoint newPosition = ccp( CCRANDOM_X_Y(0, winSize.width * 0.5),CCRANDOM_X_Y(winSize.height*0.2, winSize.height*0.8));
        newPosition.x = MAX(MIN(newPosition.x, winSize.width - render->node->getContentSize().width/2),  render->node->getContentSize().width/2);
		newPosition.y = MAX(MIN(newPosition.y, winSize.height - render->node->getContentSize().height/2), render->node->getContentSize().height/2);
		render->node->setPosition (ccp(newPosition.x, winSize.height));

		CCMoveTo* moveDown=CCMoveTo::create(float(newPosition.y)/winSize.height*2, newPosition);  

		render->node->runAction(moveDown);
		counter=0;
	}


    CCArray * entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("ItemComponent");
    CCObject* object = NULL;
    CCARRAY_FOREACH(entities, object)
    {
    	 Entity* entity = (Entity*) object;
	
		 ItemComponent* item = entity->item();
		 if(item->isConsumed && GetTickCount() -item->createTime  > item->EffectiveTime)
		 {
			 
			//CCLog("item %d removed",entity->_eid);
			CCArray * monsters = entity->getAllEntitiesOnTeam(item->TargetTeam,"MonsterComponent");
			
			for(UINT i=0;i<monsters->count();i++){ 
				Entity* monsterEntity =(Entity* ) monsters->objectAtIndex(i);
				MonsterComponent* monster = (MonsterComponent*) monsterEntity->monster();
                RenderComponent *render = (RenderComponent*) monsterEntity->render();
                //monster->monster->_deck = monster->monster->_storedDeck;
				switch(item->itemType){	
				case ItemTypeAttackPoint:
                    {
                        std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("AT2");
                        
                        notice(stateWord.c_str(),render->node->getPosition());
                        

					monster->monster->_deck.fight.Damage = monster->monster->_storedDeck.fight.Damage;
					break;
                    }
				case ItemTypeMoveSpeed:
                    {   std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("VM2");
                        
                        notice(stateWord.c_str(),render->node->getPosition());
                        

					monster->monster->_deck.fight.maxVelocity = monster->monster->_storedDeck.fight.maxVelocity;
					break;
                    }
				case ItemTypeFireSpeed:
                    {   std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("VF2");
                        
                        notice(stateWord.c_str(),render->node->getPosition());
                        
					monster->monster->_deck.fight.FireRate = monster->monster->_storedDeck.fight.FireRate;
					break;
                    }
				default:
					//monster->monster->_deck.fight.maxVelocity = monster->monster->_storedDeck.fight.maxVelocity;
					break;
				}

			}
			 
			//RenderComponent* render = (RenderComponent*)entity->render();
			//render->node->removeFromParentAndCleanup(true);
	 		this->entityManager->removeEntity(entity);
		 }
		 if(!item->isConsumed && GetTickCount() -item->createTime  > item->CollectTime)
		 {
			RenderComponent* render = (RenderComponent*)entity->render();
			render->node->removeFromParentAndCleanup(true);
	 		this->entityManager->removeEntity(entity);
		 }
		 //

	/* CCArray * enemies = entity->getAllEntitiesOnTeam(item->EffectiveTeam,"RenderComponent");
        CCObject* temp = NULL;
        CCARRAY_FOREACH(enemies, temp){
            Entity* enemy = (Entity*) temp;
	     RenderComponent * enemyRender = enemy->render();
            HealthComponent * enemyHealth = enemy->health();
	     MonsterComponent* monsterCom = entity->monster();
            if (!enemyRender || !enemyHealth ||!monsterCom) continue;


		monsterCom->monster->deck->fight.FireRate  /= 1+ item->FireSpeed;
		if(item->isConsumed)
			
        	}
        	*/
    }
}
