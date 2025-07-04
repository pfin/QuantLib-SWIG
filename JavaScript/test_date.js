// Test script for QuantLib Date bindings
const QuantLibDate = require('./build/Release/QuantLibDate');

// Test Date creation
console.log('Testing QuantLib Date JavaScript bindings...\n');

// Create a date
const date = new QuantLibDate.Date(15, QuantLibDate.January, 2025);
console.log('Created date:', date.toString());

// Test date properties
console.log('Day of month:', date.dayOfMonth());
console.log('Month:', date.month());
console.log('Year:', date.year());
console.log('Weekday:', date.weekday());

// Test static methods
const today = QuantLibDate.Date.todaysDate();
console.log('\nToday\'s date:', today.toString());

// Test calendar
const calendar = new QuantLibDate.TARGET();
console.log('\nIs business day?', calendar.isBusinessDay(date));
console.log('Is holiday?', calendar.isHoliday(date));

// Clean up - CRITICAL for memory management
date.delete();
today.delete();
calendar.delete();

console.log('\nTest completed successfully!');