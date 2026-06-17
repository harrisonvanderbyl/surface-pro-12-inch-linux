
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


echo "Copying UCM files to /usr/share/alsa/ucm2/"
cd ..
# if the directory already exists, remove it first
if [ -d "alsa-ucm-conf" ]; then
    echo "Directory alsa-ucm-conf already exists. Removing it first."
    rm -rf alsa-ucm-conf
fi
git clone https://github.com/harrisonvanderbyl/alsa-ucm-conf
cd alsa-ucm-conf
sudo cp -r ./ucm2/* /usr/share/alsa/ucm2/

cd ..
echo "Cleaning up"
sudo rm -rf ./audioreach-topology
sudo rm -rf ./alsa-ucm-conf
