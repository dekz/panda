var FFI = require("node-ffi");

module.exports = libpianocrypt = new FFI.Library("./lib/pianocrypt/libPianoCrypt", {
    "PianoEncryptString": [ "string", [ "string" ] ],
    "PianoDecryptString": [ "string", [ "string" ] ]
});

