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
EOF

# Build and install iio-sensor-proxy
git clone https://github.com/harrisonvanderbyl/iio-sensor-proxy
cd iio-sensor-proxy
meson _build -Dssc-support=enabled -Dprefix=/usr
sudo ninja -v -C _build install
cd ..
rm -rf iio-sensor-proxy

# iio-sensor-proxy service (starts after hexagonrpc)
sudo tee /etc/systemd/system/iio-sensor-proxy.service << 'EOF'
[Unit]
Description=IIO Sensor Proxy Service
After=network.target hexagonrpc.service
Requires=hexagonrpc.service

[Service]
ExecStart=/usr/libexec/iio-sensor-proxy
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable hexagonrpc.service iio-sensor-proxy.service
sudo udevadm control --reload-rules