# Low Code: LP Core

## Manual Setup

### Setup

Clone the repositories and install the tools and dependencies.

```sh
git clone -b release/v5.3 https://github.com/espressif/esp-idf.git --recursive
cd esp-idf
export ESP_IDF_PATH=$(pwd)/esp-idf
./install.sh
. ./export.sh
cd ..
```

```sh
git clone -b main https://github.com/chiragatal/esp-amp.git --recursive
cd esp-amp
export ESP_AMP_PATH=$(pwd)/esp-amp
git submodule update --init --recursive
cd ..
```

```sh
git clone -b main https://github.com/chiragatal/esp-lowcode-matter.git --recursive
cd esp-lowcode-matter
git submodule update --init --recursive
./install.sh
. ./export.sh
cd ..
```

Change the below commands according to the product that you want to create.

### Pre-built Binaries

Flash the pre-built binaries to the device. This only needs to be done once for each device.

```sh
cd $LOW_CODE_PATH/pre_built_binaries
esptool.py erase_flash
esptool.py write_flash $(cat flash_args)
```

### Per device configuration

Generate and flash the required device certificates and the qr code for the device. This only needs to be done once for each device.
Open the generated QR code separately.

```sh
cd $LOW_CODE_PATH/tools/mfg
./mfg_low_code.sh $LOW_CODE_PATH/products/light
esptool.py write_flash 0xD000 $LOW_CODE_PATH/products/light/configuration/output/0123456789AB_esp_secure_cert.bin 0x1F2000 $LOW_CODE_PATH/products/light/configuration/output/0123456789AB_fctry.bin
```

### Build

```sh
cd $LOW_CODE_PATH/products/light
idf.py set-target esp32c6
idf.py build
```

### Flash

```sh
esptool.py write_flash 0x20C000 build/subcore_light.subcore.bin
```

### Monitor

```sh
python3 -m esp_idf_monitor
```
