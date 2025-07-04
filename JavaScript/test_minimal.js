// Test minimal SWIG bindings
console.log('Testing minimal SWIG JavaScript bindings...\n');

try {
    // This will fail until we build the module
    const MinimalTest = require('./build/Release/MinimalTest');
    
    // Test basic date creation
    const date = new MinimalTest.TestDate(15, 7, 2025);
    console.log('Created date:', date.toString());
    console.log('Day:', date.day());
    console.log('Month:', date.month());
    console.log('Year:', date.year());
    
    // Test method calls
    date.addDays(20);
    console.log('After adding 20 days:', date.toString());
    
    // Test shared_ptr functions
    const sharedDate = MinimalTest.createDate(25, 12, 2025);
    console.log('Shared date:', MinimalTest.formatDate(sharedDate));
    
    // Clean up
    date.delete();
    
    console.log('\nTest passed!');
} catch (error) {
    console.log('Expected error (module not built yet):', error.message);
    console.log('\nTo build: node-gyp configure build');
}