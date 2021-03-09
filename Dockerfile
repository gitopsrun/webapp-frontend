FROM stefanprodan/podinfo-base as builder

ARG VERSION=unknown
ARG GITCOMMIT=unknown

WORKDIR /podinfo

ADD https://github.com/stefanprodan/podinfo/archive/master.tar.gz .

RUN tar xzf master.tar.gz --strip 1

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w \
  -X github.com/stefanprodan/podinfo/pkg/version.GITCOMMIT=${GITCOMMIT} \
  -X github.com/stefanprodan/podinfo/pkg/version.VERSION=${VERSION}" \
  -a -o bin/podinfo cmd/podinfo/*

FROM alpine:3.13

RUN addgroup -S app \
    && adduser -S -g app app \
    && apk --no-cache add \
    curl openssl netcat-openbsd

WORKDIR /home/app

COPY --from=builder /podinfo/bin/podinfo .
COPY --from=builder /podinfo/ui ./ui

RUN chown -R app:app ./

USER app

RUN ./podinfo -v

CMD ["./podinfo"]
