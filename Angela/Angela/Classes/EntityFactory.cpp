#include "EntityFactory.h"
#include "AIStateMass.h"

USING_NS_CC;

EntityFactory::EntityFactory(EntityManager *entityManager,CCSpriteBatchNode *batchNode)
{
	_entityManager = entityManager;
	_batchNode = batchNode;
	_entityManager->retain();
	_batchNode->retain();
	// this->_world = _world;
	_particleNodes = CCDictionary::create();
	_particleNodes->retain();
}

void EntityFactory::AddBatchNode(CCNode* batchNode,std::string key)
{
	_particleNodes->setObject(batchNode,key);
}

CCParticleBatchNode* EntityFactory::GetBatchNode(std::string key)
{
	return ((CCParticleBatchNode*)_particleNodes->objectForKey(key));
}

EntityFactory::~EntityFactory()
{
	_entityManager->release();
	_batchNode->release();

	CCDictElement* elem;
	CCDICT_FOREACH(_particleNodes, elem)
	{
		_particleNodes->removeObjectForElememt(elem);
	}
	_particleNodes->release();
	
}

Entity* EntityFactory::createHumanPlayer()
{
    float _rate = 1;
    if(log(PAIDRATE)>0)
    {
       if(log(PAIDRATE)>PAIDRATE/10)
           _rate = 1+PAIDRATE/10;
        else
            _rate=1+log(PAIDRATE);
    }
     humanIndex = (int)(CCRANDOM_0_1()*5);
    CCSprite * sprite = CCSprite::createWithSpriteFrameName(airplanes[humanIndex]);
	sprite->setZOrder(-1);
	_batchNode->addChild(sprite);
	Deck* deck = &(decks[0]);

	Entity* entity = _entityManager->createEntity();
	_entityManager->addComponent(RenderComponent::create(sprite),entity);
	_entityManager->addComponent(HealthComponent::create(deck->fight.HitPoint*_rate,deck->fight.HitPoint*_rate),entity);
	_entityManager->addComponent(TeamComponent::create(1),entity);
	PlayerComponent* player = PlayerComponent::create();
    player->attacking = true;
    player->maxPeople += PAIDRATE;
    _entityManager->addComponent(player,entity);

	Damage *damage = new Damage();
	_entityManager->addComponent(GunComponent::create(deck,damage),entity);
	return entity;
}
		
Entity* EntityFactory::createAIPlayer()
{
    aiIndex =(int)(CCRANDOM_0_1()*5);
	CCSprite * sprite = CCSprite::createWithSpriteFrameName(airplanes[aiIndex]);
	sprite->setZOrder(-1);
	_batchNode->addChild(sprite);
	Deck* deck = &(decks[0]);

	Entity * entity = _entityManager->createEntity();
	_entityManager->addComponent(RenderComponent::create(sprite),entity);
    
	_entityManager->addComponent(HealthComponent::create(deck->fight.HitPoint,deck->fight.HitPoint),entity);
	_entityManager->addComponent(TeamComponent::create(2),entity);
	PlayerComponent* player = PlayerComponent::create();
    player->attacking = true;
    if(!pvp)
        player->maxPeople += g_level;
    _entityManager->addComponent(player,entity);
    _entityManager->addComponent(CommunicateComponent::create(), entity);
	
	Damage *damage = new Damage();
	_entityManager->addComponent(GunComponent::create(deck,damage),entity);
	_entityManager->addComponent(AIComponent::create(AIStateMass::create()),entity);
    
	return entity;

}
Entity* EntityFactory::createMonsterWithTeam(MonsterType monsterType,int team)
{

    
//	float _rate = team==1?(log(PAIDRATE)>PAIDRATE/10?1+PAIDRATE/10:1+log(PAIDRATE)):1;
    float _rate = 1;
    if(log(PAIDRATE)>0 && team==1)
    {
        if(log(PAIDRATE)>PAIDRATE/10)
            _rate = 1+PAIDRATE/10;
        else
            _rate=1+log(PAIDRATE);
    }
    if(!pvp&&team==2)
    {
        _rate = 1+g_level/10;
    }

	MonsterComponent* monster = MonsterComponent::create(monsterType,team);
	CCSprite * sprite = CCSprite::createWithSpriteFrameName(monster->monster->deck->atlas[team-1]);
	
	CCSpriteFrameCache* cache = CCSpriteFrameCache::sharedSpriteFrameCache();
	CCArray* animFrames = CCArray::createWithCapacity(15);
	animFrames->addObject(cache->spriteFrameByName( monster->monster->deck->atlas[team-1] ));
	for(int pic = 1;pic<4;pic++)
	{
		 const char* p =strchr(monster->monster->deck->atlas[team-1],(int)'.');
		 char szImageFileName[128] = {0};  
		 int index = p-monster->monster->deck->atlas[team-1];
		for(int i = 0;i<index;i++)
		{
			szImageFileName[i] = monster->monster->deck->atlas[team-1][i];
		}
		szImageFileName[index]='0'+pic;
		int len = strlen(monster->monster->deck->atlas[team-1]);
		for(int i=index;i<len;i++)
		{
			szImageFileName[i+1] = monster->monster->deck->atlas[team-1][i];
		}
		szImageFileName[len+1]='\0';
		 animFrames->addObject(cache->spriteFrameByName( szImageFileName));
	}
	
	CCAnimation* animation = CCAnimation::createWithSpriteFrames(animFrames, 0.1f);
	sprite->runAction(CCRepeatForever::create(CCAnimate::create(animation)));

	_batchNode->addChild(sprite);
	Deck* deck = monster->monster->deck;
	Entity * entity = _entityManager->createEntity();
    RenderComponent *render = RenderComponent::create(sprite);
	_entityManager->addComponent(render,entity);
    if(team==2)
    {
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        float randomOffset = CCRANDOM_X_Y(-winSize.height * 0.25, winSize.height * 0.25);
        render->node->setPosition ( ccp(winSize.width * 0.75, winSize.height * 0.5 + randomOffset));

    }
	_entityManager->addComponent(HealthComponent::create(deck->fight.HitPoint*_rate,deck->fight.HitPoint*_rate),entity);

	// Add to bottom of createQuirkMonster before the return
	_entityManager->addComponent(MoveComponent::create(ccp(200, 200),deck->fight.maxVelocity*_rate,deck->fight.maxVelocity*_rate),entity);
	_entityManager->addComponent(TeamComponent::create(team),entity);
	_entityManager->addComponent(SelectionComponent::create(),entity);
	Damage *damage = new Damage();
	if(deck->fight.melee)
		_entityManager->addComponent(MeleeComponent::create(deck,damage),entity);
	if(deck->fight.range)
		_entityManager->addComponent(GunComponent::create(deck,damage),entity);
	_entityManager->addComponent(monster,entity);
	values[team-1][(int)monsterType] += deck->price;

	return entity;

}

Entity* EntityFactory::createLaserWithTeam(int team)
{
	CCParticleSystemQuad *sprite = CCParticleSystemQuad::create(effects[EffectType5Color].name);
	sprite->setAutoRemoveOnFinish(true);
	effects[EffectType5Color].particle->addChild(sprite);

 	Deck* deck =  &decks[0];
	
	Entity * entity = _entityManager->createEntity();
	_entityManager->addComponent(RenderComponent::create(sprite),entity);
	_entityManager->addComponent(TeamComponent::create(team),entity);
	//_entityManager->addComponent(MeleeComponent::create(5,true,1.0,false,CCString::create("smallHit.wav"),false),entity);
	Damage *damage = new Damage();
	damage->destroySelf = true;
	_entityManager->addComponent(MeleeComponent::create(deck,damage),entity);
	
	_entityManager->addComponent(BulletComponent::create(),entity);
 	//_entityManager->addComponent(PhysicsComponent::create(entity,sprite,_world),entity);
   return entity;

}
Entity* EntityFactory::createItemWithTeam(ItemType itemType,int team)
{
	CCSprite * sprite =  CCSprite::createWithSpriteFrameName(items[(int)itemType]);
	_batchNode->addChild(sprite);
	Entity * entity = _entityManager->createEntity();
	_entityManager->addComponent(RenderComponent::create(sprite),entity);
	_entityManager->addComponent(TeamComponent::create(team),entity);
	_entityManager->addComponent(ItemComponent::create(),entity);
	ItemComponent* item = entity->item();
	item->itemType = itemType;
	switch(itemType){
	case ItemTypeAttackPoint:
		item->AttackPoint= 10*((int) CCRANDOM_X_Y(5,30));break;
	case ItemTypeFireSpeed:
		item->FireSpeed = CCRANDOM_X_Y(0,1);break;
	case ItemTypeMoveSpeed:
		item->MoveSpeed = 10*((int) CCRANDOM_X_Y(5,11));break;
	case ItemTypeGold:
		item->Gold =10*((int) CCRANDOM_X_Y(5,11));break;
	case ItemTypeMaxHitPoint:
		item->MaxHitPoint = 10*((int) CCRANDOM_X_Y(20,50));break;
	default:
		item->MoveSpeed = 10;break;
	}
	item->isConsumed = false;
	item->TargetTeam = 1;
	item->CollectTime = 5000;
	item->EffectiveTime = 5000;
	//CCLog("Item %d created",entity->_eid);
	entity->retain();
      return entity;
}
void EntityFactory::createEffect(EffectType effectType,CCPoint position)
{
	//CCLog("%d effect created",effectType);
	CCParticleSystemQuad *sprite = CCParticleSystemQuad::create(effects[int(effectType)].name);
	//sprite->setSpeed(1.0f);
	//sprite->setDuration(1.0f);
	sprite->setPosition(position);
	//effects[(int)effectType].particle->removeAllChildrenWithCleanup(true);
	effects[(int)effectType].particle->addChild(sprite);
	
}
