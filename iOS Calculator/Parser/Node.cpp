//
//  Node.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include "Node.h"

Evaluator::_Node::_Node()
    : parent(NULL)
{
}

Evaluator::_Node::~_Node()
{
}

Evaluator::_Node* Evaluator::_Node::optimized() const
{
	return this->copy();
}


void Evaluator::_Node::clean()
{
}
