{
  "targets": [
    {
      "target_name": "MinimalTest",
      "sources": [ "minimal_test_wrap.cxx" ],
      "cflags!": [ "-fno-exceptions" ],
      "cflags_cc!": [ "-fno-exceptions" ],
      "cflags": [ "-std=c++17" ],
      "cflags_cc": [ "-std=c++17" ],
      "include_dirs": [
        "/usr/local/include",
        "/usr/include"
      ]
    }
  ]
}