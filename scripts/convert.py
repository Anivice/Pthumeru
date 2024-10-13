#!/usr/bin/env python3

import markdown2
import pdfkit
import sys
import threading
import time


def my_thread_function():
    while True:
        print(".", end="", flush=True)
        time.sleep(0.1)


def convert_markdown_to_pdf(md_file_path, output_pdf_path):
    # Read the markdown file
    with open(md_file_path, 'r', encoding='utf-8') as md_file:
        markdown_content = md_file.read()

    # Convert markdown to HTML
    html_content = markdown2.markdown(markdown_content)

    # Convert HTML to PDF
    pdfkit.from_string(html_content, output_pdf_path)


def main():
    my_thread = threading.Thread(target=my_thread_function, daemon=True)
    my_thread.start()

    # Check if the right number of arguments were provided
    if len(sys.argv) < 3:
        print("Usage: ", sys.argv[0], " <INPUT FILE> <OUTPUT FILE>")
        sys.exit(0)

    # Get argv[1] and argv[2]
    arg1 = sys.argv[1]
    arg2 = sys.argv[2]

    convert_markdown_to_pdf(arg1, arg2)


if __name__ == "__main__":
    main()

