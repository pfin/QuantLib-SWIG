const path = require('path');
const bindings = require('bindings');

// Load the native module
module.exports = bindings({
    bindings: 'QuantLib',
    module_root: path.resolve(__dirname)
});