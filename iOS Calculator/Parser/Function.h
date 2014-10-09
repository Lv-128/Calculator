//
//  Function.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#ifndef __iOS_Calculator__Function__
#define __iOS_Calculator__Function__

#include "Node.h"

class Evaluator::_Function
    : public Evaluator::_Node
{
public:
	string name;
	vector<_Node*> args;
    
	_Function(const string& name);
    
	void clean();
};

#endif /* defined(__iOS_Calculator__Function__) */
