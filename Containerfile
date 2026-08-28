FROM ubuntu:26.04 AS source

RUN apt-get update && \
    apt-get install -y --no-install-recommends xz-utils

ADD --checksum=sha256:7f53a0863ed6d32407bc72053b966e39d5b64813f2592bd9c741504c01c0e7f3 https://github.com/kovidgoyal/calibre/releases/download/v9.14.0/calibre-9.14.0-x86_64.txz /tmp/app.txz

RUN mkdir -p /out && \
    tar -xJf /tmp/app.txz -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/calibre"

COPY --from=source /out /opt/calibre

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libegl1 libgl1 libopengl0 libxkbcommon-x11-0 tzdata xdg-utils && \
    ln -sf /opt/calibre/calibre /usr/bin/calibre && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/calibre.png
COPY calibre.desktop /usr/share/applications/calibre.desktop
