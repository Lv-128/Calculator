//
//  Number.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include "Number.h"

Evaluator::_Number::_Number(double value)
    : value(value)
{
}


Evaluator::_Node* Evaluator::_Number::copy() const
{
	return new Evaluator::_Number(this->value);
}


string Evaluator::_Number::toString() const
{
	return Evaluator::_ConvertDoubleToStr(this->value);
}


double Evaluator::_Number::getValue(const vector<pair<string, double>>& args) const
{
	return value;
}
