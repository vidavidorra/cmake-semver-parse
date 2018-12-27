cmake_minimum_required(VERSION 3.7)
project(SemverParseImport)

string(TIMESTAMP DATETIME "%a, %m %b %Y %H:%M:%S (%s UTC)")
message("-- ${DATETIME}")

include("../../SemverParse.cmake")
