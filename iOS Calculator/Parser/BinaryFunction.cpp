//
//  BinaryFunction.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include "BinaryFunction.h"
#include "Constant.h"
#include "Number.h"
#include "UnaryFunction.h"

Evaluator::_BinaryFunction::_BinaryFunction(const string& name, Evaluator::_Node* arg1, Evaluator::_Node* arg2)
    : Evaluator::_Function(name)
{
	this->args.push_back(arg1);
	arg1->parent = this;
	this->args.push_back(arg2);
	arg2->parent = this;
}


Evaluator::_Node* Evaluator::_BinaryFunction::copy() const
{
	return new Evaluator::_BinaryFunction(this->name, args[0]->copy(), args[1]->copy());
}


string Evaluator::_BinaryFunction::toString() const
{
	return "(" + this->args[0]->toString() + " " + this->name + " " + this->args[1]->toString() + ")";
}


double Evaluator::_BinaryFunction::getValue(const vector<pair<string, double>>& args) const
{
	return Evaluator::_mapBinaryFunctions[this->name](this->args[0]->getValue(args), this->args[1]->getValue(args));
}


Evaluator::_Node* Evaluator::_BinaryFunction::optimized() const
{
	Evaluator::_Node* arg1 = this->args[0]->optimized();
	Evaluator::_Node* arg2 = this->args[1]->optimized();
	Evaluator::_Node* res = NULL;
	if ((typeid(Evaluator::_Number) == typeid(*arg1) || typeid(Evaluator::_Constant) == typeid(*arg1)) &&
		(typeid(Evaluator::_Number) == typeid(*arg2) || typeid(Evaluator::_Constant) == typeid(*arg2)))
	{
		res = new Evaluator::_Number(Evaluator::_mapBinaryFunctions[this->name](arg1->getValue(), arg2->getValue()));
		arg1->clean();
		delete arg1;
		arg2->clean();
		delete arg2;
	}
	else if (this->name == "+")
	{
		if (typeid(*arg1) == typeid(Evaluator::_Number) && arg1->getValue() == 0.0)
		{
			res = arg2;
			arg1->clean();
			delete arg1;
		}
		else if (typeid(*arg2) == typeid(Evaluator::_Number) && arg2->getValue() == 0.0)
		{
			res = arg1;
			arg2->clean();
			delete arg2;
		}
		else
		{
			res = new Evaluator::_BinaryFunction(this->name, arg1, arg2);
		}
	}
	else if (this->name == "-")
	{
		if (typeid(*arg1) == typeid(Evaluator::_Number) && arg1->getValue() == 0.0)
		{
			arg1->clean();
			delete arg1;
			Evaluator::_Node* node = new Evaluator::_UnaryFunction("negate", arg2);
			res = node->optimized();
			node->clean();
			delete node;
		}
		else if (typeid(*arg2) == typeid(Evaluator::_Number) && arg2->getValue() == 0.0)
		{
			res = arg1;
			arg2->clean();
			delete arg2;
		}
		else
		{
			res = new Evaluator::_BinaryFunction(this->name, arg1, arg2);
		}
	}
	else if (this->name == "*")
	{
		if ((typeid(*arg1) == typeid(Evaluator::_Number) && arg1->getValue() == 0.0) ||
			(typeid(*arg2) == typeid(Evaluator::_Number) && arg2->getValue() == 0.0))
		{
			res = new Evaluator::_Number(0.0);
			arg1->clean();
			delete arg1;
			arg2->clean();
			delete arg2;
		}
		else if (typeid(*arg1) == typeid(Evaluator::_Number) && arg1->getValue() == 1.0)
		{
			res = arg2;
			arg1->clean();
			delete arg1;
		}
		else if (typeid(*arg2) == typeid(Evaluator::_Number) && arg2->getValue() == 1.0)
		{
			res = arg1;
			arg2->clean();
			delete arg2;
		}
		else
		{
			res = new Evaluator::_BinaryFunction(this->name, arg1, arg2);
		}
	}
	else if (this->name == "/")
	{
		if (typeid(*arg2) == typeid(Evaluator::_Number) && arg2->getValue() == 1.0)
		{
			res = arg1;
			arg2->clean();
			delete arg2;
		}
		else
		{
			res = new Evaluator::_BinaryFunction(this->name, arg1, arg2);
		}
	}
	else if (this->name == "^")
	{
		if (typeid(*arg1) == typeid(Evaluator::_Number) && arg1->getValue() == 1.0)
		{
			res = new Evaluator::_Number(1.0);
			arg1->clean();
			delete arg1;
			arg2->clean();
			delete arg2;
		}
		else if (typeid(*arg2) == typeid(Evaluator::_Number) && arg2->getValue() == 1.0)
		{
			res = arg1;
			arg2->clean();
			delete arg2;
		}
		else
		{
			res = new Evaluator::_BinaryFunction(this->name, arg1, arg2);
		}
	}
	else
	{
		res = new Evaluator::_BinaryFunction(this->name, arg1, arg2);
	}
	return res;
}
