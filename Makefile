all:
	mkdir -p build && cd build && ../scripts/convert.bash

clean:
	rm -rf build
