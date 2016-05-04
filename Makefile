.PHONY: increase_minor_version

increase_minor_version:
	perl -pe 's/^(VERSION=(\d+\.)*)(\d+)(.*)$$/$$1.($$3+1).$$4/e' < packaging/env.list > packaging/env.list.tmp
	mv -f packaging/env.list.tmp packaging/env.list
