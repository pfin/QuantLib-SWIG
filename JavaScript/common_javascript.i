/*
 JavaScript-specific common.i
 Adapted from QuantLib-SWIG common.i for JavaScript bindings
*/

#ifndef quantlib_common_javascript_i
#define quantlib_common_javascript_i

%{
    namespace QuantLib { namespace ext {} }
    namespace ext = QuantLib::ext;
%}
#define SWIG_SHARED_PTR_NAMESPACE ext

// JavaScript-specific includes
%include "exception.i"
%include "std_string.i"
%include "std_vector.i"

// Include our custom JavaScript boost_shared_ptr handling
%include "boost_shared_ptr.i"

%define QL_TYPECHECK_BOOL       7210    %enddef

%{
#if defined(NDEBUG)
#define BOOST_DISABLE_ASSERTS 1
#endif

#include <boost/algorithm/string/case_conv.hpp>
%}

// JavaScript-specific type mappings
%typemap(in) ext::optional<bool> %{
    if ($input->IsNull() || $input->IsUndefined()) {
        $1 = ext::nullopt;
    } else if ($input->IsBoolean()) {
        $1 = Nan::To<bool>($input).FromJust();
    } else {
        SWIG_exception(SWIG_TypeError, "expecting optional<bool>");
    }
%}

%typemap(out) ext::optional<bool> %{
    if ($1) {
        $result = Nan::New(*$1);
    } else {
        $result = Nan::Null();
    }
%}

// Handle std::string for JavaScript
%typemap(in) const std::string& (std::string temp) %{
    Nan::Utf8String str($input);
    temp = std::string(*str);
    $1 = &temp;
%}

%typemap(out) std::string %{
    $result = Nan::New($1.c_str()).ToLocalChecked();
%}

%typemap(out) const std::string& %{
    $result = Nan::New($1->c_str()).ToLocalChecked();
%}

// Rename operators for JavaScript
%rename(plus) operator+;
%rename(minus) operator-;
%rename(multiply) operator*;
%rename(divide) operator/;
%rename(equals) operator==;
%rename(notEquals) operator!=;
%rename(lessThan) operator<;
%rename(lessEquals) operator<=;
%rename(greaterThan) operator>;
%rename(greaterEquals) operator>=;
%rename(increment) operator++;
%rename(decrement) operator--;
%rename(plusEquals) operator+=;
%rename(minusEquals) operator-=;

// JavaScript memory management helpers
%feature("javascript", "delete") "true";

%fragment("SWIG_delete", "header") %{
static void SWIG_delete(void* obj) {
    // This will be called when JavaScript calls .delete()
    // The actual deletion is handled by SWIG's type system
}
%}

#endif