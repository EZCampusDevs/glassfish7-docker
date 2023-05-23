
all: build

clean:
	rm glassfish.zip || true
	rm -rf glassfish || true

build:
	./install.sh
	docker build -t glassfish7 .

run: build
	docker run -it --rm -p 8080:8080 -p 4848:4848 glassfish7
