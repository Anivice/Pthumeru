cmake_minimum_required(VERSION 3.30)

project(Pthumeru C)

function(get_basename_without_md file_path output_var)
  # Extract just the filename (with extension) from the full path.
  get_filename_component(filename "${file_path}" NAME)

  # Remove the '.md' extension from the end of the filename if it exists.
  string(REGEX REPLACE "\\.md$" "" base "${filename}")

  # Return the processed basename to the caller.
  set(${output_var} "${base}" PARENT_SCOPE)
endfunction()

function(get_directory file_path output_var)
  # Extract the directory portion of the file path
  get_filename_component(dir "${file_path}" DIRECTORY)
  
  # Return the directory to the calling scope
  set(${output_var} "${dir}" PARENT_SCOPE)
endfunction()

function(add_pdf_target TARGET FILE DESTINATION REFERENCES)
    get_basename_without_md(${FILE} file_basename)
    add_custom_target(
            ${TARGET} ALL
            COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/convert.py
                    ${FILE}
                    ${DESTINATION}
                    ${REFERENCES}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Generating pdf for ${file_basename}.md to ${file_basename}.pdf ..."
            DEPENDS ${FILE}
            BYPRODUCTS ${DESTINATION}
    )
endfunction()

function(get_md_files output_var)
  # Recursively find all markdown files in the current source directory
  file(GLOB_RECURSE md_files "${CMAKE_CURRENT_SOURCE_DIR}/*.md")

  set(result_files "")
  foreach(file_path IN LISTS md_files)
    # Extract just the filename from the full path
    get_filename_component(filename "${file_path}" NAME)
    # Exclude README.md
    if(NOT filename STREQUAL "README.md")
      list(APPEND result_files "${file_path}")
    endif()
  endforeach()

  # Return the list to the calling scope
  set(${output_var} "${result_files}" PARENT_SCOPE)
endfunction()

get_md_files(md_files)

foreach(md_file IN LISTS md_files)
    set(md_file_basename)
    get_basename_without_md("${md_file}" md_file_basename)
    get_directory("${md_file}" md_file_dir)
    add_pdf_target(
        PDF_${md_file_basename} 
        ${md_file} 
        "${CMAKE_CURRENT_BINARY_DIR}/${md_file_basename}.pdf"
        "${md_file_dir}/references.bib")
    message(STATUS "Adding ${md_file}")
endforeach()

list(LENGTH md_files md_count)

message(STATUS "Added ${md_count} targets")
