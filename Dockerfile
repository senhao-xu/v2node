# Build go
FROM golang:1.26.0-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN GOEXPERIMENT=jsonv2 go mod download
RUN GOEXPERIMENT=jsonv2 go build -v -o v2node

# Release
FROM  alpine
# 安装必要的工具包
RUN  apk --update --no-cache add tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir -p /usr/local/v2node /etc/v2node
COPY --from=builder /app/v2node /usr/local/v2node/v2node
COPY script/v2node.sh /usr/bin/v2node
COPY script/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/v2node/v2node /usr/bin/v2node /usr/local/bin/docker-entrypoint.sh

ENV V2NODE_CONFIG=/etc/v2node/config.json

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["server"]
