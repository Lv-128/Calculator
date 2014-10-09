//
//  BinaryFunction.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#ifndef __iOS_Calculator__BinaryFunction__
#define __iOS_Calculator__BinaryFunction__

#include "Function.h"

class Evaluator::_BinaryFunction
    : public Evaluator::_Function
{
public:
	_BinaryFunction(const string& name, Evaluator::_Node* arg1, Evaluator::_Node* arg2);
    
	Evaluator::_Node* copy() const;
	string toString() const;
	double getValue(const vector<pair<string, double>>& args = (vector<pair<string, double>>())) const;
	Evaluator::_Node* optimized() const;
};

#endif /* defined(__iOS_Calculator__BinaryFunction__) */
