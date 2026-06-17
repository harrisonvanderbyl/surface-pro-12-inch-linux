
echo "Cloning and installing AudioReach topology"
#if the directory already exists, remove it first
if [ -d "audioreach-topology" ]; then
    echo "Directory audioreach-topology already exists. Removing it first."
    rm -rf audioreach-topology
fi
git clone https://github.com/linux-msm/audioreach-topology
cd audioreach-topology
export FW_LOCATION=/lib/firmware
cmake .
make
sudo make install


cd ..
echo "Just ensure have alsa-ucm-conf (1.2.15.3-1ubuntu1.2)"
