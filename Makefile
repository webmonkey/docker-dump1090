build:
	docker build -t webmonkeyuk/docker-dump1090 .


run:
	docker run --rm -it \
    	--device=/dev/bus/usb:/dev/bus/usb \
		webmonkeyuk/docker-dump1090
