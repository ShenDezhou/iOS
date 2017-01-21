#include "System.h"

USING_NS_CC;

void System::init(EntityManager *entityManager,EntityFactory* entityFactory){
	this->entityManager = entityManager;
	this->entityManager->retain();
	this->entityFactory = entityFactory;
	this->entityFactory->retain();
}
 System::~System()
{
	this->entityManager->release();
	this->entityFactory->release();
}	
 