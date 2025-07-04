// Simple Date example for QuantLib JavaScript bindings
// This shows how the bindings will work once compiled

const QuantLib = require('../index');

// Example 1: Working with Dates
console.log('=== QuantLib Date Example ===\n');

// Create a date (15th January 2025)
const date = new QuantLib.Date(15, QuantLib.January, 2025);
console.log('Created date:', date.toString());

// Get date components
console.log('Day:', date.dayOfMonth());
console.log('Month:', date.month());
console.log('Year:', date.year());
console.log('Weekday:', date.weekday());

// Date arithmetic
date.addDays(30);
console.log('\nAfter adding 30 days:', date.toString());

// Static methods
const today = QuantLib.Date.todaysDate();
console.log('\nToday:', today.toString());

// Check if leap year
console.log('Is 2025 a leap year?', QuantLib.Date.isLeap(2025));
console.log('Is 2024 a leap year?', QuantLib.Date.isLeap(2024));

// Example 2: Working with Calendars
console.log('\n=== Calendar Example ===\n');

// Create TARGET calendar (Trans-European Automated Real-time Gross Settlement Express Transfer)
const calendar = new QuantLib.TARGET();

// Check business days
console.log('Is', date.toString(), 'a business day?', calendar.isBusinessDay(date));
console.log('Is', date.toString(), 'a holiday?', calendar.isHoliday(date));

// Advance by business days
const nextBusinessDay = calendar.advance(date, 1, QuantLib.Days);
console.log('Next business day:', nextBusinessDay.toString());

// Example 3: Memory Management
console.log('\n=== Memory Management ===\n');
console.log('IMPORTANT: Always call .delete() on QuantLib objects when done!');

// Clean up - CRITICAL for preventing memory leaks
date.delete();
today.delete();
calendar.delete();
nextBusinessDay.delete();

console.log('\nExample completed successfully!');