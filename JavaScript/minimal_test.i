%module MinimalTest

%{
#include <string>
#include <ctime>
%}

%include "std_string.i"

// Simple class that doesn't require QuantLib
class TestDate {
private:
    int day_;
    int month_;
    int year_;
    
public:
    TestDate() : day_(1), month_(1), year_(2025) {}
    TestDate(int d, int m, int y) : day_(d), month_(m), year_(y) {}
    
    int day() const { return day_; }
    int month() const { return month_; }
    int year() const { return year_; }
    
    std::string toString() const {
        char buffer[11];
        snprintf(buffer, sizeof(buffer), "%04d-%02d-%02d", year_, month_, day_);
        return std::string(buffer);
    }
    
    void addDays(int days) {
        // Simplified - just for testing
        day_ += days;
        while (day_ > 30) {
            day_ -= 30;
            month_++;
            if (month_ > 12) {
                month_ = 1;
                year_++;
            }
        }
    }
};

// Test boost::shared_ptr handling
%{
#include <boost/shared_ptr.hpp>

boost::shared_ptr<TestDate> createDate(int d, int m, int y) {
    return boost::make_shared<TestDate>(d, m, y);
}

std::string formatDate(boost::shared_ptr<TestDate> date) {
    return date ? date->toString() : "null";
}
%}

boost::shared_ptr<TestDate> createDate(int d, int m, int y);
std::string formatDate(boost::shared_ptr<TestDate> date);