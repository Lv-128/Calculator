//
//  Evaluator.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#ifndef __iOS_Calculator__Evaluator__
#define __iOS_Calculator__Evaluator__

#include <functional>
#include <iostream>
#include <map>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

using std::function;
using std::istream;
using std::map;
using std::ostream;
using std::pair;
using std::string;
using std::vector;

class Evaluator
{
public:
    
    Evaluator();
    Evaluator(const string& expr);
    
    Evaluator(const Evaluator& eval);
    Evaluator& operator=(const Evaluator& eval);
    
    Evaluator(Evaluator&& eval);
    Evaluator& operator=(Evaluator&& eval);
    
    ~Evaluator();
    
    double evaluate(const vector<pair<string, double>>& args = (vector<pair<string, double>>())) const;
    
    virtual Evaluator& parse(const string& str);
    
    virtual string to_string() const;
    
    double operator()(const vector<pair<string, double>>& args = (vector<pair<string, double>>())) const;
    
    friend istream& operator>>(istream& is, Evaluator& eval);
    friend ostream& operator<<(ostream& os, const Evaluator& eval);
    
private:
    
    class _Node;
    class _Function;
    class _UnaryFunction;
    class _BinaryFunction;
    class _Constant;
    class _Number;
    class _Var;
    
private:
    
    static map<string, function<double(double, double)>> _mapBinaryFunctions;
    static map<string, function<double(double)>> _mapUnaryFunctions;
    static map<string, double> _mapConstants;
    
    static double _ConvertStrToDouble(const string& str);
    static string _ConvertDoubleToStr(double val);
    
    static bool _IsParenthesis(const string& token);
    static bool _IsFunction(const string& token);
    static bool _IsBinaryFunction(const string& token);
    static bool _IsUnaryFunction(const string& token);
    static bool _IsConstant(const string& token);
    static bool _IsNumber(const string& token);
    static int _GetPriority(const string& token);
    
    static vector<string> _GetExpressionTokens(const string& expr);
    static vector<string> _InfixToRPN(vector<string> tokens);
    
    static _Node* _MakeTree(const vector<string>& RPN);
    static _Node* _Parse(const string& str);
    
private:
    
    _Node* _tree;
    
    void _Clean();
};

#endif /* defined(__iOS_Calculator__Evaluator__) */
