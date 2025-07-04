{
  "targets": [
    {
      "target_name": "QuantLibDate",
      "sources": [ "test_date_wrap.cxx" ],
      "include_dirs": [
        "/usr/local/include",
        "/usr/include"
      ],
      "libraries": [
        "-lQuantLib"
      ],
      "cflags!": [ "-fno-exceptions" ],
      "cflags_cc!": [ "-fno-exceptions" ],
      "cflags": [ "-std=c++11" ],
      "cflags_cc": [ "-std=c++11" ]
    }
  ]
}