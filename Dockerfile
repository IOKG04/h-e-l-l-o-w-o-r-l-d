FROM alpine:latest

RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "@community https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk update
RUN apk add g++
RUN apk add nim
RUN apk add zig
RUN apk add bash
RUN apk add make
RUN apk add pcre
RUN apk add cmd:pip
RUN apk add cmd:deno
RUN apk add cmd:python3.12
RUN apk add cmd:python3.12-config # python3.12 headers

RUN deno install jsr:@std/jsonc@^1.0.1

WORKDIR /code
