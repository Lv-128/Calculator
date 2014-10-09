//
//  Variable.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include "Variable.h"

using std::runtime_error;

Evaluator::_Var::_Var(const std::string& name)
    : name(name)
{
}


Evaluator::_Node* Evaluator::_Var::copy() const
{
	return new Evaluator::_Var(this->name);
}


string Evaluator::_Var::toString() const
{
	return this->name;
}


double Evaluator::_Var::getValue(const vector<pair<string, double>>& args) const
{
	auto it = find_if(args.begin(), args.end(), [&](const pair<string, double>& pair) { return pair.first == this->name; });
	
    if (it != args.end())
	{
		return it->second;
	}
	else
	{
        // Too few arguments to evaluate
		throw runtime_error("Invalid expression");
	}
    
	return 0;
}