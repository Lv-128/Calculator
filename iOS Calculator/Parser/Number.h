//
//  Number.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#ifndef __iOS_Calculator__Number__
#define __iOS_Calculator__Number__

#include "Node.h"

class Evaluator::_Number
    : public Evaluator::_Node
{
public:
	double value;
    
	_Number(double value);
    
	Evaluator::_Node* copy() const;
	string toString() const;
	double getValue(const vector<pair<string, double>> &args = (vector<pair<string, double>>())) const;
};

#endif /* defined(__iOS_Calculator__Number__) */
