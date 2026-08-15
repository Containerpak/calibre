FROM ubuntu:26.04 AS source

RUN apt-get update && \
    apt-get install -y --no-install-recommends xz-utils

ADD --checksum=sha256:d664fe74953463f1b679945a5460234b61cbf539da48fc78f2111ff8d9503cc0 https://github.com/kovidgoyal/calibre/releases/download/v9.13.0/calibre-9.13.0-x86_64.txz /tmp/app.txz

RUN mkdir -p /out && \
    tar -xJf /tmp/app.txz -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/calibre"

COPY --from=source /out /opt/calibre

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libegl1 libgl1 libopengl0 libxkbcommon-x11-0 xdg-utils && \
    ln -sf /opt/calibre/calibre /usr/bin/calibre && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/calibre.png
COPY calibre.desktop /usr/share/applications/calibre.desktop
