FROM ubuntu:26.04 AS source

ADD --checksum=sha256:3c2a11fba0f6b8bb332f0baf474ee1a43a65a41c4977dd9b3e548336b1084866 https://github.com/kovidgoyal/calibre/releases/download/v9.11.0/calibre-9.11.0-x86_64.txz /tmp/app.txz

RUN mkdir -p /out && \
    tar -xJf /tmp/app.txz -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/calibre"

COPY --from=source /out /opt/calibre

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libegl1 libgl1 libxkbcommon-x11-0 xdg-utils && \
    ln -sf /opt/calibre/calibre /usr/bin/calibre && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/calibre.png
COPY calibre.desktop /usr/share/applications/calibre.desktop
