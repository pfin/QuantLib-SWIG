{
  "targets": [
    {
      "target_name": "QuantLib",
      "sources": [ "quantlib_wrap.cxx" ],
      "include_dirs": [
        "/usr/local/include",
        "/usr/include"
      ],
      "libraries": [
        "-lQuantLib"
      ],
      "cflags!": [ "-fno-exceptions" ],
      "cflags_cc!": [ "-fno-exceptions" ],
      "conditions": [
        ["OS=='mac'", {
          "xcode_settings": {
            "GCC_ENABLE_CPP_EXCEPTIONS": "YES",
            "CLANG_CXX_LIBRARY": "libc++",
            "CLANG_CXX_LANGUAGE_STANDARD": "c++11",
            "MACOSX_DEPLOYMENT_TARGET": "10.7"
          }
        }],
        ["OS=='win'", {
          "defines": [
            "NOMINMAX"
          ],
          "msvs_settings": {
            "VCCLCompilerTool": {
              "ExceptionHandling": 1
            }
          }
        }]
      ]
    }
  ]
}