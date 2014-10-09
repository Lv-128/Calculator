//
//  Constant.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include "Constant.h"

Evaluator::_Constant::_Constant(const std::string& name)
: name(name)
{
}


Evaluator::_Node* Evaluator::_Constant::copy() const
{
	return new Evaluator::_Constant(this->name);
}


string Evaluator::_Constant::toString() const
{
	return this->name;
}


double Evaluator::_Constant::getValue(const vector<pair<string, double>>& args) const
{
	return _mapConstants[this->name];
}