//
//  Function.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include "Function.h"

Evaluator::_Function::_Function(const string& name)
    : name(name)
{
}


void Evaluator::_Function::clean()
{
	for (auto& node : this->args)
	{
		node->clean();
		delete node;
	}
}