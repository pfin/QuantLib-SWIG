/* QuantLib JavaScript bindings
 * Adapted for JavaScript/Node.js from QuantLib-SWIG
 */

%module QuantLib

// JavaScript specific configuration
%include "exception.i"

%exception {
    try {
        $action
    } catch (std::out_of_range& e) {
        SWIG_exception(SWIG_IndexError, e.what());
    } catch (std::exception& e) {
        SWIG_exception(SWIG_RuntimeError, e.what());
    } catch (...) {
        SWIG_exception(SWIG_UnknownError, "unknown error");
    }
}

// Include C++ STL support
%include "std_string.i"
%include "std_vector.i"

// Basic typedefs
%{
#include <ql/types.hpp>
using namespace QuantLib;
%}

typedef double Real;
typedef int Integer;
typedef unsigned int Natural;
typedef long BigInteger;
typedef unsigned long BigNatural;
typedef unsigned int Size;
typedef double Rate;
typedef double Spread;
typedef double Volatility;
typedef int Year;
typedef int Day;

// Handle boost::shared_ptr for JavaScript
// JavaScript doesn't have automatic shared_ptr support, so we expose raw pointers
// and handle memory management explicitly
%{
#include <boost/shared_ptr.hpp>
%}

// Define a macro to handle shared_ptr wrapping for JavaScript
%define JAVASCRIPT_SHARED_PTR(TYPE)
%typemap(out) boost::shared_ptr<TYPE> {
    // Convert shared_ptr to raw pointer for JavaScript
    $result = SWIG_NewPointerObj($1.get(), $descriptor(TYPE*), 0);
}
%typemap(in) boost::shared_ptr<TYPE> {
    // Convert JavaScript object to shared_ptr
    TYPE* raw_ptr;
    int res = SWIG_ConvertPtr($input, (void**)&raw_ptr, $descriptor(TYPE*), 0);
    if (!SWIG_IsOK(res)) {
        SWIG_exception_fail(SWIG_ArgError(res), "in method '$symname', argument $argnum of type 'boost::shared_ptr<TYPE>'");
    }
    $1 = boost::shared_ptr<TYPE>(raw_ptr);
}
%enddef

// Include core QuantLib headers
%{
#include <ql/quantlib.hpp>
%}

// Date and time
%include "date.i"
%include "calendars.i"
%include "daycounters.i"

// Interest rates
%include "interestrate.i"

// Indexes
%include "indexes.i"

// Term structures
%include "termstructures.i"
%include "yieldcurve.i"

// Rate helpers
%include "ratehelpers.i"

// Instruments
%include "instruments.i"
%include "bonds.i"
%include "swaps.i"

// Options
%include "options.i"

// Math
%include "interpolation.i"

// Rename operators for JavaScript
%rename(plus) operator+;
%rename(minus) operator-;
%rename(multiply) operator*;
%rename(divide) operator/;
%rename(equals) operator==;
%rename(notEquals) operator!=;

// Memory management note for JavaScript
%pragma(javascript) jscode=%{
// IMPORTANT: QuantLib objects must be manually deleted in JavaScript
// Call obj.delete() when done with any QuantLib object to prevent memory leaks
%}