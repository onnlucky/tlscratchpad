run:
	gtl scratchpad.tl
	#gtl run.tl

tlScratchpad.app/Contents/MacOS/tlScratchpad: *.tl Makefile
	mkdir -p tlScratchpad.app/Contents/MacOS/
	cp -r *.tl tlScratchpad.app/Contents/MacOS/
	echo "#!`which gtl`" > tlScratchpad.app/Contents/MacOS/tlScratchpad
	cat scratchpad.tl >> tlScratchpad.app/Contents/MacOS/tlScratchpad
	chmod 755 tlScratchpad.app/Contents/MacOS/tlScratchpad

app: tlScratchpad.app/Contents/MacOS/tlScratchpad

install: app
	cp -r tlScratchpad.app /Applications

clean:
	rm -rf tlScratchpad.app/Contents/MacOS/

.PHONY: app install clean
