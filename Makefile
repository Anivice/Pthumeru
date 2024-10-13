dep:
	pip install markdown2 pdfkit
	sudo apt install wkhtmltopdf -y

all:
	mkdir -p build
	cd build
	../scripts/convert.bash

clean:
	rm -rf build
