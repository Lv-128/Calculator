//
//  Node.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#ifndef __iOS_Calculator__Node__
#define __iOS_Calculator__Node__

#include "Evaluator.h"

class Evaluator::_Node
{
public:
	Evaluator::_Node* parent;
    
	_Node();
    virtual ~_Node();
    
	virtual Evaluator::_Node* copy() const = 0;
	virtual string toString() const = 0;
	virtual double getValue(const vector<pair<string, double>>& args = (vector<pair<string, double>>())) const = 0;
	virtual Evaluator::_Node* optimized() const;
	virtual void clean();
};

#endif /* defined(__iOS_Calculator__Node__) */
