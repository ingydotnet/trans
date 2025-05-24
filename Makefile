SHELL := bash

DISTROS := $(wildcard Dockerfile.*)
DISTROS := $(DISTROS:Dockerfile.%=%)

IMAGES := $(foreach distro,$(DISTROS),image-$(distro))
TESTS := $(foreach distro,$(DISTROS),test-$(distro))

# Test command that uses all installed packages
define TEST_CMD
docker run -it --rm $1 \
    /bin/bash -c '\
    (echo && set -x && ag --version) && \
    (echo && set -x && bash --version) && \
    (echo && set -x && curl --version) && \
    (echo && set -x && git --version) && \
    (echo && set -x && jq --version) && \
    (echo && set -x && make --version) && \
    (echo && set -x && python3 --version) && \
    (echo && set -x && which unzip) && \
    (echo && set -x && which zip) && \
    true'
endef
export TEST_CMD

default:

build: $(IMAGES)

test: $(TESTS)

$(IMAGES):
	docker build -t $@ -f Dockerfile.$(subst image-,,$(@)) .

test-%: image-%
	@echo "Testing $(subst test-,,$(@)) image..."
	$(call TEST_CMD,image-$(subst test-,,$(@)))
