PASCAL := fpc
TARGET := md5

.PHONY:	.FORCE
.FORCE:

all:	build

build:	clean $(TARGET)

$(TARGET):
	$(PASCAL) $@.pas

clean:
	@rm -rf ./$(TARGET).o
	@rm -rf ./$(TARGET)

run:	build
	./$(TARGET)