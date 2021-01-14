.PHONY: test
test:
	prove -e 'raku -Ilib' t
