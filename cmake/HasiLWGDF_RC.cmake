function (compile_resources)
  set (INPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/res")
  set (OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/res")

  file (GLOB_RECURSE BINARIES "${INPUT_DIR}/*")

  if (BINARIES STREQUAL "")
    message (WARNING "No resources was found.")
    return ()
  endif ()

  set (HEADER_FILE "${OUTPUT_DIR}/CompiledResources.h")

  set (HEADER_CONTENT "/*\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    HasiLWGDF (Hasibix's Lightweight Game Development Framework)\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    A simple, cross-platform game engine made with C++.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    Supports multiple graphics APIs and built on top of open-source\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    resources.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    Copyright (c) 2023 Hasibix Hasib. All Rights Reserved.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    Thank you so much for using HasiLWGDF. Feel free to contribute our project.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    For more information, please visit https://github.com/HasiLWGDF/HasiLWGDF.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    This file is an resource compiled using HasiLWGDF toolchain.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    It is recommended NOT to modify this file. As doing such may result in compatibility\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    issues or even PERMANENT damage to your project or device.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    DO NOT MODIFY THIS FILE UNLESS IT IS NECESSARY TO DO SO.\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "*/\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "#pragma once\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "#include \"hasilwgdf/Resource.hpp\"\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "#include <stdint.h>\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "namespace Your::Game::Namespace::Goes::Here\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "{\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    class MyResources final\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    {\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    private:\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "        MyResources() = delete\;\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    public:\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "        static void registerAll()\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "        {\n")
  foreach (bin ${BINARIES})
    if (IS_DIRECTORY "${bin}")
      continue ()
    endif ()

    get_filename_component(FNAME ${bin} NAME_WE)
    get_filename_component(FORMAT ${bin} EXT)
    string(REGEX REPLACE "\\." "_" NAME_DASHED "${FNAME}${FORMAT}")
    string(REGEX REPLACE " " "_" NAME_DASHED "${NAME_DASHED}")
    string(REGEX REPLACE "-" "_" NAME_DASHED "${NAME_DASHED}")

    string(TOLOWER NAME_DASHED "${NAME_DASHED}")

    file (READ ${bin} HEX HEX)
    set (HEADER_CONTENT "${HEADER_CONTENT}" "            const unsigned char ${NAME_DASHED}[] = {\n")

    string(REGEX REPLACE "([0-9a-f][0-9a-f])" "0x\\1, " HEX "${HEX}")
    string(LENGTH "${HEX}" HEX_LEN)
    string(SUBSTRING "${HEX}" 1 ${HEX_LEN}-2 HEX)

    set (HEADER_CONTENT "${HEADER_CONTENT}" "                0${HEX}\n            }\;\n")
  endforeach ()

  set (HEADER_CONTENT "${HEADER_CONTENT}" "\n")

  foreach (bin ${BINARIES})
  if (IS_DIRECTORY "${bin}")
    continue ()
  endif ()

  get_filename_component(FNAME ${bin} NAME_WE)
  get_filename_component(FORMAT ${bin} EXT)
  set (FORMATENUM "")

  if(FORMAT STREQUAL ".jpg" OR FORMAT STREQUAL ".png" OR FORMAT STREQUAL ".gif" OR FORMAT STREQUAL ".bmp")
    set(FORMATENUM "Hasibix::HasiLWGDF::Core::Resource::ResourceType::IMAGE")
  elseif(FORMAT STREQUAL ".mp3" OR FORMAT STREQUAL ".wav" OR FORMAT STREQUAL ".ogg")
    set(FORMATENUM "Hasibix::HasiLWGDF::Core::Resource::ResourceType::AUDIO")
  elseif(FORMAT STREQUAL ".cfg" OR FORMAT STREQUAL ".ini" OR FORMAT STREQUAL ".xml" OR FORMAT STREQUAL ".json")
    set(FORMATENUM "Hasibix::HasiLWGDF::Core::Resource::ResourceType::CONFIG")
  elseif(FORMAT STREQUAL ".dat" OR FORMAT STREQUAL ".txt")
    set(FORMATENUM "Hasibix::HasiLWGDF::Core::Resource::ResourceType::DATA")
  elseif(FORMAT STREQUAL ".obj" OR FORMAT STREQUAL ".fbx")
    set(FORMATENUM "Hasibix::HasiLWGDF::Core::Resource::ResourceType::MESH")
  elseif(FORMAT STREQUAL ".mp4" OR FORMAT STREQUAL ".avi" OR FORMAT STREQUAL ".mov")
    set(FORMATENUM "Hasibix::HasiLWGDF::Core::Resource::ResourceType::VIDEO")
  else()
    set(FORMATENUM "Hasibix::HasiLWGDF::Core::Resource::ResourceType::UNKNOWN")
  endif()

  string(REGEX REPLACE "\\." "_" NAME_DASHED "${FNAME}${FORMAT}")
  string(REGEX REPLACE " " "_" NAME_DASHED "${NAME_DASHED}")
  string(REGEX REPLACE "-" "_" NAME_DASHED "${NAME_DASHED}")

  file(RELATIVE_PATH relativePath ${INPUT_DIR} ${bin})
  get_filename_component(IDENTIFIER ${relativePath} DIRECTORY)
  string(REPLACE "/" "." IDENTIFIER ${IDENTIFIER})

  string(TOLOWER NAME_DASHED "${NAME_DASHED}")
  string(TOLOWER IDENTIFIER "${IDENTIFIER}")

  set (HEADER_CONTENT "${HEADER_CONTENT}" "            Hasibix::HasiLWGDF::Core::Resource::create(\"${IDENTIFIER}\", \"${NAME_DASHED}\", ${FORMATENUM}, ${NAME_DASHED})\;\n")
endforeach ()

  set (HEADER_CONTENT "${HEADER_CONTENT}" "        }\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "    }\;\n")
  set (HEADER_CONTENT "${HEADER_CONTENT}" "}\n")
  file (WRITE ${HEADER_FILE} ${HEADER_CONTENT})
endfunction ()
