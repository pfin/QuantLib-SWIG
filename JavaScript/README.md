# QuantLib JavaScript/Node.js Bindings

This directory contains the JavaScript/Node.js bindings for QuantLib using SWIG.

## Requirements
- SWIG 4.0+ with JavaScript support
- Node.js 16+ 
- node-gyp for building native modules
- QuantLib 1.38+ installed

## Building
```bash
# Generate SWIG wrapper
cd ..
swig -javascript -node -c++ -o JavaScript/quantlib_wrap.cxx SWIG/quantlib.i

# Build Node.js module
cd JavaScript
node-gyp configure
node-gyp build
```

## Usage
```javascript
const QuantLib = require('./build/Release/QuantLib');

// Create a date
const date = new QuantLib.Date(15, QuantLib.January, 2025);
console.log(date.toString());

// Create a calendar
const calendar = new QuantLib.TARGET();
console.log(calendar.isBusinessDay(date));

// Clean up
date.delete();
calendar.delete();
```

## Memory Management
SWIG JavaScript bindings require manual memory management. Always call `.delete()` on objects when done.

## TypeScript Support
TypeScript definitions are generated in `quantlib.d.ts`.