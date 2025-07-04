/* boost_shared_ptr.i for JavaScript
 * 
 * This file provides boost::shared_ptr support for SWIG JavaScript bindings.
 * Since JavaScript doesn't have automatic shared_ptr support like Python/Java,
 * we need to handle the conversions manually.
 */

%{
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
%}

// Tell SWIG about boost::shared_ptr template
namespace boost {
    template<class T> class shared_ptr {
    public:
        typedef T element_type;
        
        shared_ptr();
        shared_ptr(T *p);
        template<class Y> shared_ptr(const shared_ptr<Y>& r);
        
        T* get() const;
        T* operator->() const;
        T& operator*() const;
        
        void reset();
        void reset(T* p);
        
        long use_count() const;
        bool unique() const;
        
        operator bool() const;
    };
}

// Macro to handle shared_ptr for a specific type
%define SWIG_SHARED_PTR(NAMESPACE, TYPE)

// Tell SWIG to treat shared_ptr<TYPE> as TYPE* 
%typemap(out) boost::shared_ptr<NAMESPACE::TYPE> {
    NAMESPACE::TYPE *resultptr = $1.get();
    $result = SWIG_NewPointerObj(SWIG_as_voidptr(resultptr), 
                                  $descriptor(NAMESPACE::TYPE *), 0);
}

%typemap(out) boost::shared_ptr<NAMESPACE::TYPE>& {
    NAMESPACE::TYPE *resultptr = (*$1).get();
    $result = SWIG_NewPointerObj(SWIG_as_voidptr(resultptr), 
                                  $descriptor(NAMESPACE::TYPE *), 0);
}

%typemap(out) const boost::shared_ptr<NAMESPACE::TYPE>& {
    NAMESPACE::TYPE *resultptr = (*$1).get();
    $result = SWIG_NewPointerObj(SWIG_as_voidptr(resultptr), 
                                  $descriptor(NAMESPACE::TYPE *), 0);
}

// Convert JavaScript object to shared_ptr
%typemap(in) boost::shared_ptr<NAMESPACE::TYPE> (void* argp, int res) {
    res = SWIG_ConvertPtr($input, &argp, $descriptor(NAMESPACE::TYPE *), 0);
    if (!SWIG_IsOK(res)) {
        SWIG_exception_fail(SWIG_ArgError(res), 
            "in method '$symname', expecting boost::shared_ptr<" #NAMESPACE "::" #TYPE ">");
    }
    NAMESPACE::TYPE* ptr = reinterpret_cast<NAMESPACE::TYPE*>(argp);
    if (ptr) {
        $1 = boost::shared_ptr<NAMESPACE::TYPE>(ptr);
    }
}

%typemap(in) const boost::shared_ptr<NAMESPACE::TYPE>& (void* argp, int res, boost::shared_ptr<NAMESPACE::TYPE> temp) {
    res = SWIG_ConvertPtr($input, &argp, $descriptor(NAMESPACE::TYPE *), 0);
    if (!SWIG_IsOK(res)) {
        SWIG_exception_fail(SWIG_ArgError(res), 
            "in method '$symname', expecting boost::shared_ptr<" #NAMESPACE "::" #TYPE ">");
    }
    NAMESPACE::TYPE* ptr = reinterpret_cast<NAMESPACE::TYPE*>(argp);
    if (ptr) {
        temp = boost::shared_ptr<NAMESPACE::TYPE>(ptr);
        $1 = &temp;
    } else {
        $1 = nullptr;
    }
}

%typemap(in) boost::shared_ptr<NAMESPACE::TYPE>& = const boost::shared_ptr<NAMESPACE::TYPE>&;

// Type checking
%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) boost::shared_ptr<NAMESPACE::TYPE> {
    void* ptr;
    $1 = (SWIG_ConvertPtr($input, &ptr, $descriptor(NAMESPACE::TYPE *), 0) == SWIG_OK) ? 1 : 0;
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) const boost::shared_ptr<NAMESPACE::TYPE>&,
                                                         boost::shared_ptr<NAMESPACE::TYPE>& {
    void* ptr;
    $1 = (SWIG_ConvertPtr($input, &ptr, $descriptor(NAMESPACE::TYPE *), 0) == SWIG_OK) ? 1 : 0;
}

%enddef

// Simplified macro without namespace
%define SWIG_SHARED_PTR_SIMPLE(TYPE)
SWIG_SHARED_PTR(, TYPE)
%enddef