%module QuantLibDate

%{
#include <ql/time/date.hpp>
#include <ql/time/calendar.hpp>
#include <ql/time/daycounter.hpp>
using namespace QuantLib;
%}

// Include std_string for JavaScript
%include "std_string.i"

// Basic types
typedef int Integer;
typedef int Natural;
typedef long BigInteger;
typedef long BigNatural;

// Month enum
enum Month {
    January   = 1,
    February  = 2,
    March     = 3,
    April     = 4,
    May       = 5,
    June      = 6,
    July      = 7,
    August    = 8,
    September = 9,
    October   = 10,
    November  = 11,
    December  = 12
};

// Weekday enum  
enum Weekday {
    Sunday    = 1,
    Monday    = 2,
    Tuesday   = 3,
    Wednesday = 4,
    Thursday  = 5,
    Friday    = 6,
    Saturday  = 7
};

// Date class
class Date {
public:
    Date();
    Date(BigInteger serialNumber);
    Date(Day d, Month m, Year y);
    
    Weekday weekday() const;
    Day dayOfMonth() const;
    Month month() const;
    Year year() const;
    
    Date& operator++();
    Date& operator--();
    Date& operator+=(BigInteger days);
    Date& operator-=(BigInteger days);
    
    std::string toString() const;
    
    static Date minDate();
    static Date maxDate();
    static Date todaysDate();
    static bool isLeap(Year y);
};

// Simple calendar
class Calendar {
public:
    bool isBusinessDay(const Date& d) const;
    bool isHoliday(const Date& d) const;
    bool isWeekend(Weekday w) const;
};

// TARGET calendar
class TARGET : public Calendar {
public:
    TARGET();
};