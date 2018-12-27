function(semver_parse VERSION_STRING RETURN_NAME)

  # Semver regular expression.
  #
  # Extracted parts from regex. This regex is created by @DavidFichtmueller and comes from a semver GitHub issue.
  # Source: https://github.com/semver/semver/issues/232#issuecomment-405596809
  #  |  major   |  |  minor   |  |  patch   ||                                         pre-release                                         ||                 build                  |
  # ^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$
  # Separated parts of the regular expression.
  #  major      : (0|[1-9]\d*)
  #  minor      : (0|[1-9]\d*)
  #  patch      : (0|[1-9]\d*)
  #  pre-release: (?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?
  #  build      : (?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?

  # major
  # minor
  # patch
  # Changes:
  # - Replace unsupported `\d` with `[0-9]`.
  set(semver_major_regex "(0|[1-9][0-9]*)")
  set(semver_minor_regex "${semver_major_regex}")
  set(semver_patch_regex "${semver_major_regex}")

  # pre-release
  # Regex: (?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?
  # Changes:
  # - Change unsupported non-capturing groups to capturing groups.
  # - Replace unsupported `\d` with `[0-9]`.
  # - Escape special characters.
  set(semver_pre_release_regex
    "(-((0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?")

  # pre-release (validation only)
  # Regex: (?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?
  # Changes:
  # - Same as semver_pre_release_regex.
  # - Remove capturing group around the section match, excluding the minus sign.
  set(semver_pre_release_validation_regex
    "(-(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*)?")

  # build
  # Regex: (?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?
  # Changes:
  # - Change non-capturing groups to capturing groups.
  # - Escape special characters.
  set(semver_build_regex      "(\\+([0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*))?")

  # build (validation only)
  # Changes:
  # - Same as semver_build_regex
  # - Remove capture group around section match, excluding the plus sign.
  set(semver_build_validation_regex "(\\+[0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*)?")

  # Combined regular expressions
  set(semver_basic_versions_regex "${semver_major_regex}\\.${semver_minor_regex}\\.${semver_patch_regex}")
  set(semver_regex "^${semver_basic_versions_regex}${semver_pre_release_validation_regex}${semver_build_validation_regex}$")
  set(semver_pre_release_build_regex "${semver_pre_release_regex}${semver_build_regex}")
  set(semver_pre_release_match_group 2)
  set(semver_build_match_group 7)


  # - Match the basic version and validate both the basic version and the pre-release and build.
  string(REGEX MATCH "^${semver_regex}$" match "${VERSION_STRING}")
  if (NOT match)
    set(_IS_VALID false PARENT_SCOPE)
    return()
  endif ()

  set(basic_version_length 0)
  if (${CMAKE_MATCH_COUNT} GREATER_EQUAL 1)
    set(version_major "${CMAKE_MATCH_1}")
    string(LENGTH "${version_major}" temp)
    math(EXPR basic_version_length "${basic_version_length}+${temp}")
    set(${RETURN_NAME}_VERSION_MAJOR ${version_major} PARENT_SCOPE)
  endif ()
  if (${CMAKE_MATCH_COUNT} GREATER_EQUAL 3)
    set(version_minor "${CMAKE_MATCH_2}")
    string(LENGTH "${version_minor}" temp)
    math(EXPR basic_version_length "${basic_version_length}+${temp}")
    set(${RETURN_NAME}_VERSION_MINOR ${version_minor} PARENT_SCOPE)
  endif ()
  if (${CMAKE_MATCH_COUNT} GREATER_EQUAL 3)
    set(version_patch "${CMAKE_MATCH_3}")
    string(LENGTH "${version_patch}" temp)
    math(EXPR basic_version_length "${basic_version_length}+${temp}")
    set(${RETURN_NAME}_VERSION_PATCH ${version_patch} PARENT_SCOPE)
  endif ()


  # - Return if no pre-release and/or build are present in the version string.
  if (${CMAKE_MATCH_COUNT} LESS 4)
    set(_IS_VALID true PARENT_SCOPE)
    return()
  endif ()


  # - Remove the basic version and match the pre-release and build versions.
  # - Add two for the dots in the basic version.
  math(EXPR basic_version_length "${basic_version_length} + 2")
  string(SUBSTRING "${VERSION_STRING}" "${basic_version_length}" -1 pre_release_build_version_string)

  # - Match the pre-release and build versions.
  string(REGEX MATCH "^${semver_pre_release_build_regex}$" match "${pre_release_build_version_string}")

  if (NOT match)
    set(_IS_VALID false PARENT_SCOPE)
    return()
  endif ()

  if (${CMAKE_MATCH_COUNT} GREATER_EQUAL ${semver_pre_release_match_group})
    set(version_pre_release "${CMAKE_MATCH_${semver_pre_release_match_group}}")
    set(${RETURN_NAME}_VERSION_PRE_RELEASE ${version_pre_release} PARENT_SCOPE)
  endif ()
  if (${CMAKE_MATCH_COUNT} GREATER_EQUAL ${semver_build_match_group})
    set(version_build "${CMAKE_MATCH_${semver_build_match_group}}")
    set(${RETURN_NAME}_VERSION_BUILD ${version_build} PARENT_SCOPE)
  endif ()

  set(_IS_VALID true PARENT_SCOPE)

endfunction()
