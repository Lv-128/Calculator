//
//  UnaryFunction.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#ifndef __iOS_Calculator__UnaryFunction__
#define __iOS_Calculator__UnaryFunction__

#include "Function.h"

class Evaluator::_UnaryFunction
    : public Evaluator::_Function
{
public:
	_UnaryFunction(const string& name, Evaluator::_Node* arg);
    
	Evaluator::_Node* copy() const;
	string toString() const;
	double getValue(const vector<pair<string, double>>& args = (vector<pair<string, double>>())) const;
	Evaluator::_Node* optimized() const;
};

#endif /* defined(__iOS_Calculator__UnaryFunction__) */
