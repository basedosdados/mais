PHONY: create-env update-env

REPO=$(shell basename $(CURDIR))

create-env:
	python3 -m venv .$(REPO);
	. .$(REPO)/bin/activate; \
			pip3 install --upgrade  -r python-package/requirements-dev.txt; \
			python python-package/setup.py develop;

update-env:
	. .$(REPO)/bin/activate; \
	pip3 install --upgrade -r python-package/requirements-dev.txt;

attach-kernel:
	python -m ipykernel install --user --name=$(REPO);
