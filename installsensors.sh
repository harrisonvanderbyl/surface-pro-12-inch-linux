#!/bin/bash
set -e

sudo apt install libudev-dev libgudev-1.0-dev systemd-dev libpolkit-gobject-1-dev libgtk-3-dev

sudo cp -r ./usr/* /usr/

# Build and install hexagonrpc
git clone https://github.com/harrisonvanderbyl/hexagonrpc
cd hexagonrpc
meson setup build
ninja -C build
sudo ninja -C build install
cd ..
rm -rf hexagonrpc

# Hexagonrpc service
sudo tee /etc/systemd/system/hexagonrpc.service << 'EOF'
[Unit]
Description=HexagonRPC Service
After=network.target

[Service]
ExecStart=/usr/local/bin/hexagonrpcd -f /dev/fastrpc-adsp-secure -s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Udev rule for mount matrix
sudo tee /etc/udev/rules.d/61-sensor-surface-pro-12.rules << 'EOF'
ACTION=="add|change", SUBSYSTEM=="misc", KERNEL=="fastrpc-adsp-secure", \
  ENV{ACCEL_MOUNT_MATRIX}="-1, 0, 0; 0, -1, 0; 0, 0, 1"
# The fork's 80-iio-sensor-proxy.rules only tags ssc-light + ssc-compass;
# the ssc-accel driver exists but never probes without this tag.
SUBSYSTEM=="misc", KERNEL=="fastrpc-adsp*", ENV{IIO_SENSOR_PROXY_TYPE}+="ssc-accel"
EOF

# Build and install iio-sensor-proxy
# NOTE: prefix is /usr/local, not /usr. The stock Ubuntu iio-sensor-proxy deb
# owns the same paths under /usr, so an apt upgrade silently replaces this
# SSC-enabled build with one that has no SSC support -- accel, light and
# compass all go dead with no error anywhere. Building to /usr/local (like
# hexagonrpcd above) plus holding the deb keeps the sensors alive.
git clone https://github.com/harrisonvanderbyl/iio-sensor-proxy
cd iio-sensor-proxy
meson _build -Dssc-support=enabled -Dprefix=/usr/local
sudo ninja -v -C _build install
cd ..
rm -rf iio-sensor-proxy
sudo apt-mark hold iio-sensor-proxy

# iio-sensor-proxy service (starts after hexagonrpc)
sudo tee /etc/systemd/system/iio-sensor-proxy.service << 'EOF'
[Unit]
Description=IIO Sensor Proxy Service
After=network.target hexagonrpc.service
Requires=hexagonrpc.service

[Service]
ExecStart=/usr/local/libexec/iio-sensor-proxy
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable hexagonrpc.service iio-sensor-proxy.service
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=misc