FROM alpine:3

RUN	apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

COPY fetch_github_asset.sh /fetch_github_asset.sh

ENTRYPOINT ["/fetch_github_asset.sh"]
