cmake_minimum_required(VERSION 2.8)
project(SimpleVersion)

include("../../SemverParse.cmake")
semver_parse("1.2.3" package_version)

if (NOT _IS_VALID)
  message(SEND_ERROR "semver_parse Could not parse version string")
endif()

if (NOT DEFINED package_version_VERSION_MAJOR)
  message(SEND_ERROR "semver_parse _VERSION_MAJOR should be defined")
endif()
if (NOT DEFINED package_version_VERSION_MINOR)
  message(SEND_ERROR "semver_parse _VERSION_MINOR should be defined")
endif()
if (NOT DEFINED package_version_VERSION_PATCH)
  message(SEND_ERROR "semver_parse _VERSION_PATCH should be defined")
endif()
if (DEFINED package_version_VERSION_PRE_RELEASE)
  message(SEND_ERROR "semver_parse _VERSION_PRE_RELEASE should not be defined")
endif()
if (DEFINED package_version_VERSION_BUILD)
  message(SEND_ERROR "semver_parse _VERSION_BUILD should not be defined")
endif()

if (NOT "${package_version_VERSION_MAJOR}" EQUAL "1")
  message(SEND_ERROR "Major version incorrectly parsed")
endif()
if (NOT "${package_version_VERSION_MINOR}" EQUAL "2")
  message(SEND_ERROR "Major version incorrectly parsed")
endif()
if (NOT "${package_version_VERSION_PATCH}" EQUAL "3")
  message(SEND_ERROR "Major version incorrectly parsed")
endif()

message("Parsed version:\n"
  " major: '${package_version_VERSION_MAJOR}'\n"
  " major: '${package_version_VERSION_MINOR}'\n"
  " major: '${package_version_VERSION_PATCH}'")
