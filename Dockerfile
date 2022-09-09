ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION} as base

RUN apk upgrade --no-cache --available \
	&& apk add --no-cache \
		# Bash \
		bash \
		# Browsers \
		chromium \
		firefox \
		# Node dependencies \
		g++ \
		gcc \
		git \
		make \
		nodejs \
		npm \
		tini \
		yarn \
		# Testcafe \
		dbus \
		eudev \
		fluxbox \
		libevent \
		procps \
		ttf-freefont \
		tzdata \
		xvfb \
		xwininfo \
		# Allure dependencies \
		ca-certificates \
		curl \
		tzdata \
		unzip \
	&& update-ca-certificates \
	&& apk add --update coreutils && rm -rf /var/cache/apk/*   \ 
	&& apk add --no-cache --update \ 
		openjdk11 \
		nss \
	&& rm -rf /var/cache/apk/*	

# Install testcafe & clean
RUN npm install -g testcafe \
	&& npm cache clean --force \
	&& rm -rf /tmp/* \
	# Add testcafe as a user \
	&& mkdir -p /testcafe \
	&& adduser -D testcafe \
	&& chown -R testcafe:testcafe /testcafe

# Run Chrome as non-privileged
USER testcafe
WORKDIR /testcafe

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/
