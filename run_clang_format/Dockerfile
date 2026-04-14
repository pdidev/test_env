FROM alpine:3.20

ENV LANG=C.UTF-8

RUN apk add --no-cache \
        clang17-extra-tools \
        clang18-extra-tools \
        python3 \
 && mkdir /src

COPY run-clang-format/run-clang-format.py /usr/bin/run-clang-format

RUN chmod 755 /usr/bin/run-clang-format

ENTRYPOINT ["/usr/bin/run-clang-format", "--clang-format-executable", "/usr/lib/llvm18/bin/clang-format"]
WORKDIR /src
