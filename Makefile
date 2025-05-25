include .makes/init.mk
include $(MAKES)/ys.mk

ifeq (,$(wildcard $(YS)))
_ := $(shell set -x && $(install-ys))
endif

DISTROS = $(shell ys -e 'use: make-dockerfile' -e 'say: make-dockerfile/distros:keys:joins')
IMAGES := $(foreach distro,$(DISTROS),image-$(distro))
TESTS := $(foreach distro,$(DISTROS),test-$(distro))

build: $(IMAGES)

test: $(TESTS)

clean::
	$(RM) Dockerfile

$(IMAGES):
	pwd
	ys Dockerfile.ys $(subst image-,,$(@)) > Dockerfile
	docker build -t $@ .
	$(RM) Dockerfile

test-%: image-%
	@echo "Testing $(subst test-,,$(@)) image..."
	$(call TEST_CMD,image-$(subst test-,,$(@)))

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
