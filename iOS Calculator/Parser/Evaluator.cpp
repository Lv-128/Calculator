//
//  Evaluator.cpp
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#include <cmath>
#include <stack>
#include "BinaryFunction.h"
#include "Constant.h"
#include "Number.h"
#include "UnaryFunction.h"
#include "Variable.h"

using std::binary_function;
using std::istringstream;
using std::ostringstream;
using std::pointer_to_unary_function;
using std::runtime_error;
using std::stack;

template <class T>
struct divides : std::binary_function<T, T, T>
{
    T operator()(const T& x, const T& y) const
    {
        if (y != 0) return x / y;
        else throw runtime_error("Zero division");
    }
};

//Private static fields:

map<string, function<double(double, double)>> Evaluator::_mapBinaryFunctions =
{
	{ "+", std::plus<double>() },
	{ "-", std::minus<double>() },
	{ "*", std::multiplies<double>() },
	{ "/", divides<double>() },
	{ "^", std::pointer_to_binary_function<double, double, double>(pow) }
};


map<string, function<double(double)>> Evaluator::_mapUnaryFunctions =
{
	{ "acos", pointer_to_unary_function<double, double>(acos) },
	{ "acosh", pointer_to_unary_function<double, double>(acosh) },
	{ "asin", pointer_to_unary_function<double, double>(asin) },
	{ "asinh", pointer_to_unary_function<double, double>(asinh) },
	{ "atan", pointer_to_unary_function<double, double>(atan) },
	{ "atanh", pointer_to_unary_function<double, double>(atanh) },
	{ "cos", pointer_to_unary_function<double, double>(cos) },
	{ "cosh", pointer_to_unary_function<double, double>(cosh) },
	{ "exp", pointer_to_unary_function<double, double>(exp) },
	{ "log", pointer_to_unary_function<double, double>(log) },
	{ "log10", pointer_to_unary_function<double, double>(log10) },
	{ "negate", std::negate<double>() },
	{ "sin", pointer_to_unary_function<double, double>(sin) },
	{ "sinh", pointer_to_unary_function<double, double>(sinh) },
	{ "sqrt", pointer_to_unary_function<double, double>(sqrt) },
	{ "tan", pointer_to_unary_function<double, double>(tan) },
	{ "tanh", pointer_to_unary_function<double, double>(tanh) }
};


map<string, double> Evaluator::_mapConstants =
{
	{ "E", 2.7182818284590451 },
	{ "PI", 3.1415926535897931 }
};


//Private static functions:


double Evaluator::_ConvertStrToDouble(const std::string& str)
{
	std::istringstream is;
	is.str(str);
	double val;
	is >> val;
	return val;
}


string Evaluator::_ConvertDoubleToStr(double val)
{
	ostringstream os;
	os << val;
	return os.str();
}


bool Evaluator::_IsParenthesis(const string& token)
{
	return token == "(" || token == ")";
};


bool Evaluator::_IsFunction(const string& token)
{
	return Evaluator::_mapBinaryFunctions.count(token) || Evaluator::_mapUnaryFunctions.count(token);
};


bool Evaluator::_IsBinaryFunction(const string& token)
{
	return Evaluator::_mapBinaryFunctions.count(token);
}


bool Evaluator::_IsUnaryFunction(const string& token)
{
	return Evaluator::_mapUnaryFunctions.count(token);
}


bool Evaluator::_IsConstant(const string& token)
{
	return Evaluator::_mapConstants.count(token);
}


bool Evaluator::_IsNumber(const string& token)
{
	char* endptr;
	::strtod(token.c_str(), &endptr);
	return !(*endptr);
}


int Evaluator::_GetPriority(const string& token)
{
	if (Evaluator::_IsParenthesis(token))
	{
		return 0;
	}
	else if (token == "+" || token == "-")
	{
		return 1;
	}
	else if (token == "*" || token == "/")
	{
		return 2;
	}
	else if (token == "^")
	{
		return 3;
	}
	else if (Evaluator::_IsUnaryFunction(token))
	{
		return 4;
	}
	else
	{
		return -1;
	}
}


vector<string> Evaluator::_GetExpressionTokens(const string& expr)
{
	vector<string> tokens;
	string str = "";
    
	for (int i = 0; i < expr.size(); ++i)
	{
		const string token(1, expr[i]);
        
		if (Evaluator::_IsFunction(token) || Evaluator::_IsParenthesis(token) || token == ",")
		{
			if (!str.empty())
			{
				tokens.push_back(str);
			}
			str = "";
			tokens.push_back(token);
		}
		else
		{
			// Append the numbers
			if (!token.empty() && token != " ")
			{
				str.append(token);
			}
			else
			{
				if (str != "")
				{
					tokens.push_back(str);
					str = "";
				}
			}
		}
	}
    
	if (str != "")
	{
		tokens.push_back(str);
	}
    
	return tokens;
}


vector<string> Evaluator::_InfixToRPN(vector<string> tokens)
{
	for (size_t i = 0; i < tokens.size(); ++i)
	{
		if (tokens[i] == "-" && (i == 0 || (tokens[i - 1] == "(" || Evaluator::_IsFunction(tokens[i - 1]))))
		{
			tokens[i] = "negate";
		}
	}
    
	vector<string> out;
    
	stack<string> stack;
    
	for (auto& token : tokens)
	{
		if (Evaluator::_IsUnaryFunction(token))
		{
			while (!stack.empty() && Evaluator::_GetPriority(token) < Evaluator::_GetPriority(stack.top()))
			{
				out.push_back(stack.top());
				stack.pop();
			}
			stack.push(token);
		}
		else if (Evaluator::_IsBinaryFunction(token))
		{
			while (!stack.empty() && Evaluator::_GetPriority(token) <= Evaluator::_GetPriority(stack.top()))
			{
				out.push_back(stack.top());
				stack.pop();
			}
			stack.push(token);
		}
		else if (token == "(")
		{
			stack.push(token);
		}
		else if (token == ")")
		{
			while (!stack.empty() && stack.top() != "(")
			{
				out.push_back(stack.top());
				stack.pop();
			}
			if (!stack.empty())
			{
				stack.pop();
			}
			else
			{
				throw runtime_error("Invalid expression");
			}
		}
		else if (token == ",")
		{
		}
		else
		{
			out.push_back(token);
		}
	}
    
	while (!stack.empty())
	{
		if (Evaluator::_IsParenthesis(stack.top()))
		{
			throw runtime_error("Invalid expression");
		}
		else
		{
			out.push_back(stack.top());
			stack.pop();
		}
	}
    
	return out;
}


Evaluator::_Node* Evaluator::_MakeTree(const vector<string>& RPN)
{
	stack<Evaluator::_Node*> stack;
    
	for (auto& token : RPN)
	{
		if (!Evaluator::_IsFunction(token))
		{
			if (_IsConstant(token))
			{
				stack.push(new Evaluator::_Constant(token));
			}
			else if (_IsNumber(token))
			{
				stack.push(new Evaluator::_Number(Evaluator::_ConvertStrToDouble(token)));
			}
			else
			{
				stack.push(new Evaluator::_Var(token));
			}
		}
		else if (Evaluator::_IsUnaryFunction(token))
		{
			if (!stack.empty())
			{
				Evaluator::_Node* arg = stack.top();
				stack.pop();
				stack.push(new Evaluator::_UnaryFunction(token, arg));
			}
			else
			{
				throw runtime_error("Invalid expression");
			}
		}
		else if (Evaluator::_IsBinaryFunction(token))
		{
			if (stack.size() > 1)
			{
				Evaluator::_Node* arg2 = stack.top();
				stack.pop();
				Evaluator::_Node* arg1 = stack.top();
				stack.pop();
				stack.push(new Evaluator::_BinaryFunction(token, arg1, arg2));
			}
			else
			{
				throw runtime_error("Invalid expression");
			}
		}
	}
    
	if (stack.size() == 1)
	{
		return stack.top();
	}
	else
	{
		throw runtime_error("Invalid expression");
	}
}



Evaluator::_Node* Evaluator::_Parse(const std::string& str)
{
	if (!str.empty())
	{
		vector<std::string> tokens = Evaluator::_GetExpressionTokens(str);
		vector<std::string> rpn = Evaluator::_InfixToRPN(tokens);
		Evaluator::_Node* node = Evaluator::_MakeTree(rpn);
        Evaluator::_Node* optimized = node->optimized();
		node->clean();
		delete node;
		return optimized;
	}
	else
	{
		return nullptr;
	}
}


//Private member functions:


void Evaluator::_Clean()
{
	if (this->_tree)
	{
		this->_tree->clean();
		delete this->_tree;
		this->_tree = nullptr;
	}
}


//Public members:


Evaluator::Evaluator()
    : _tree{nullptr}
{
}


Evaluator::Evaluator(const string& expr)
    : _tree{Evaluator::_Parse(expr)}
{
}


Evaluator::Evaluator(const Evaluator& eval)
    : _tree{eval._tree ? eval._tree->copy() : nullptr}
{
}


Evaluator& Evaluator::operator=(const Evaluator& eval)
{
	if (&eval != this)
	{
		this->_Clean();
		this->_tree = eval._tree ? eval._tree->copy() : nullptr;
	}
	return *this;
}


Evaluator::Evaluator(Evaluator&& eval)
: _tree(eval._tree)
{
	eval._tree = nullptr;
}


Evaluator& Evaluator::operator=(Evaluator&& eval)
{
	if (&eval != this)
	{
		this->_Clean();
		this->_tree = eval._tree;
		eval._tree = nullptr;
	}
	return *this;
}


Evaluator::~Evaluator()
{
	this->_Clean();
}


double Evaluator::evaluate(const vector<pair<string, double>>& args) const
{
	return this->_tree->getValue(args);
}


Evaluator& Evaluator::parse(const string& str)
{
	this->_Clean();
	this->_tree = Evaluator::_Parse(str);
	return *this;
}


string Evaluator::to_string() const
{
	if (this->_tree)
	{
		return _tree->toString();
	}
	else
	{
		return string();
	}
}


double Evaluator::operator()(const vector<pair<string, double>>& args) const
{
	return this->_tree->getValue(args);
}


istream& operator>>(istream& is, Evaluator& eval)
{
	string str;
	is >> str;
	eval.parse(str);
	return is;
};


ostream& operator<<(ostream& os, const Evaluator& eval)
{
	return os << eval.to_string();
}
