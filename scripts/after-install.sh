#!/bin/sh

# This file is used by deb, rpm and BSD packages.
# FPM adds this as the after-install script.
# Edit this file as needed for your application.
# This file is only installed if FORMULA is set to service.

OS="$(uname -s)"

if [ "${OS}" = "Linux" ]; then
  # Make a user and group for this app, but only if it does not already exist.
  id unpoller >/dev/null 2>&1  || \
    useradd --system --user-group --no-create-home --home-dir /tmp --shell /bin/false unpoller
elif [ "${OS}" = "OpenBSD" ]; then
  id unpoller >/dev/null 2>&1  || \
    useradd  -g =uid -d /tmp -s /bin/false unpoller
elif [ "${OS}" = "FreeBSD" ]; then
  id unpoller >/dev/null 2>&1  || \
    pw useradd unpoller -d /tmp -w no -s /bin/false
else
  echo "Unknown OS: ${OS}, please add system user unpoller manually."
fi

if [ -x "/bin/systemctl" ]; then
  # Reload and restart - this starts the application as user nobody.
  /bin/systemctl daemon-reload
  /bin/systemctl enable unpoller
  /bin/systemctl restart unpoller
fi
