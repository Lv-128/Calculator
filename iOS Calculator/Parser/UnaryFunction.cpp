//
//  UnaryFunction.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include "Constant.h"
#include "Number.h"
#include "UnaryFunction.h"

Evaluator::_UnaryFunction::_UnaryFunction(const string& name, Evaluator::_Node* arg)
    : Evaluator::_Function(name)
{
	this->args.push_back(arg);
	arg->parent = this;
}


Evaluator::_Node* Evaluator::_UnaryFunction::copy() const
{
	return new Evaluator::_UnaryFunction(this->name, args[0]->copy());
}


string Evaluator::_UnaryFunction::toString() const
{
	return (this->name == "negate" ? "-" : this->name) + " " + this->args[0]->toString();
}


double Evaluator::_UnaryFunction::getValue(const vector<pair<string, double>>& args) const
{
	return Evaluator::_mapUnaryFunctions[this->name](this->args[0]->getValue(args));
}


Evaluator::_Node* Evaluator::_UnaryFunction::optimized() const
{
	Evaluator::_Node* arg = this->args[0]->optimized();
	if (typeid(Evaluator::_Number) == typeid(*arg) || typeid(Evaluator::_Constant) == typeid(*arg))
	{
		Evaluator::_Node* node = new Evaluator::_Number(Evaluator::_mapUnaryFunctions[this->name](arg->getValue()));
		arg->clean();
		delete arg;
		return node;
	}
	else
	{
		return new Evaluator::_UnaryFunction(this->name, arg);
	}
}
