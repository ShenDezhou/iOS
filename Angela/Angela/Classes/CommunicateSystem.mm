#include "CommunicateSystem.h"

#include "Entity.h"
#include "EntityManager.h"
#include "EntityFactory.h"
#include "SimpleAudioEngine.h"
#include "Constant.h"
#include "ServerScene.h"

USING_NS_CC;

CommunicateSystem::CommunicateSystem(EntityManager *entityManager,EntityFactory* entityFactory)
{
	init(entityManager,entityFactory);
}

void CommunicateSystem::update(float dt)
{
    
    CCArray* entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("CommunicateComponent");
    if (entities->count() == 0) return;
    

		Entity* entity = (Entity* )entities->objectAtIndex(0);
		entity->retain();
        CommunicateComponent* com = entity->communicate();
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(com->recvData, pObject)  
        {  
             CCString* cmd = (CCString*)pObject;  
             if(!cmd)  
                break;  
            const char* pcmd = cmd->getCString();
			switch(pcmd[0])
			{
				case 0x71:
                {
                    PlayerComponent* player = entity->player();
                    player->people += decks[(int)pcmd[2]].fight.FoodCap;
                    player->RefreshOverload();
					entityFactory->createMonsterWithTeam(MonsterType(pcmd[2]), OPPOSITE_TEAM(pcmd[1]));
					break;
				}
                case 0x72:
				{
					CCArray * monsters = entity->getAllEntitiesOnTeam(OPPOSITE_TEAM(pcmd[1]),"MonsterComponent");
					
					for(UINT i=0;i<monsters->count();i++){ 
						Entity* monsterEntity =(Entity* ) monsters->objectAtIndex(i);
						MonsterComponent* monster = (MonsterComponent*) monsterEntity->monster();
		                RenderComponent *render = (RenderComponent*) monsterEntity->render();
						switch((ItemType)pcmd[2]){	
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
			 		//this->entityManager->removeEntity(entity);

				}
					break;
				case 0x73:
					{
					   CCArray* entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("PlayerComponent");
					    //for (Entity * entity in entities) {
					     for(UINT i=0; i < entities->count();i++){   
						 	Entity* entity = (Entity*)entities->objectAtIndex(i);
					        PlayerComponent* player = entity->player();
					        TeamComponent* team = entity->team();
					        RenderComponent* render = entity->render();
					        // use hand to collect gold
							if(team->team==OPPOSITE_TEAM(pcmd[1]))
							{
								player->attacking = pcmd[2]==2;
							}
					    }

					}
							
					break;
                case 0x74:
                {
                    CCArray* entities = this->entityManager->getAllEntitiesPosessingComponentOfClass("PlayerComponent");
                    //for (Entity * entity in entities) {
                    for(UINT i=0; i < entities->count();i++){
                        Entity* entity = (Entity*)entities->objectAtIndex(i);
                        HealthComponent* health = entity->health();
                        TeamComponent* team = entity->team();
                        RenderComponent* render = entity->render();
                        // use hand to collect gold
                        if(team->team==pcmd[1])
                        {
                            health->curHP = ((int)pcmd[2])<<4;
                        }
                    }
                    
                }
                    
					break;
			}
        } 
		com->recvData->removeAllObjects();

}

void CommunicateSystem::notice(const char* notice,CCPoint position)
{
    CCLabelTTF* hitLabel =CCLabelTTF::create(notice, fontname, fontSizeBig, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
    hitLabel->setColor(ccc3(255,0,0));
    hitLabel->setPosition(position);
    this->entityFactory->_batchNode->getParent()->addChild(hitLabel);
    
    CCScaleTo* scaleFrom = CCScaleTo::create(0.1f,1.5f);
    CCDelayTime* delay = CCDelayTime::create(0.1f);
    CCScaleTo* scaleTo = CCScaleTo::create(0.1f,1.0f);
    CCFiniteTimeAction* actionMoveDone = CCCallFuncN::create(this,callfuncN_selector(CommunicateSystem::clean));
    
    CCSequence* sequence = CCSequence::create(scaleFrom,delay,scaleTo,delay,actionMoveDone,NULL);
    
    hitLabel->runAction(sequence);
    
    
}
