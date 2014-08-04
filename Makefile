run:
	gtl scratchpad.tl

install:
	mkdir -p tlScratchpad.app/Contents/MacOS/
	cp scratchpad.tl tlScratchpad.app/Contents/MacOS/tlScratchpad

clean:
	rm -rf tlScratchpad.app/Contents/MacOS/
