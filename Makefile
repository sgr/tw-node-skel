FROM_IMAGE=armhf/node:6.10-slim
TO_IMAGE=sgr0502/tw-node-skel
BUILD_API_SH=./scripts/build-api-on-docker.sh
APIDIR=./api
TWAPI=$(APIDIR)/twApi.so
SDKSRC=C_SDK.zip
SDKURL=http://tpg-twxdevzone.s3.amazonaws.com/files/media/SDK_Files/$(SDKSRC)

.PHONY: all image shell clean distclean uninstall

all: image

$(SDKSRC):
	curl -O $(SDKURL)

# build ThingWorx C API -> $(APIDIR)/twApi.so
$(TWAPI): $(SDKSRC)
	@if [ ! -d $(APIDIR) ]; \
        	then echo "mkdir -p $(APIDIR)"; mkdir -p $(APIDIR); \
        fi
	docker run -it --rm -v "$(PWD)":/build -w /build $(FROM_IMAGE) $(BUILD_API_SH)

image: $(TWAPI)
	docker-compose create

shell: image
	docker run --rm -it $(TO_IMAGE) /bin/bash

uninstall:
	-docker-compose down --rm all
	
clean:
	rm -fr $(APIDIR)

distclean: clean
	rm -f $(SDKSRC)

