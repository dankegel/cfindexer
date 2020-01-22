check:
	./canonicalize-nc.sh < nc-names-dirty.txt > nc-names.tmp
	diff -u nc-names-clean.txt nc-names.tmp
	rm nc-names.tmp

deps:
	pip3 install --user requests bs4
