![Banner](img/banner.png?raw=true)
=====

This repo contains ensō sources for managing device-specific bins/libs/generic files (first boot /system script) or features (TODO on-the-fly java class).

You may need to install python3 for the script to be created:

```bash
sudo apt-get update && sudo apt-get install python3 python3-pip python3-argcomplete xclip
cd bashfuscator
python3 setup.py install --user
```

Supported devices list:
=====
<details>

### Exynos 8895 family (S8/Note8):
## What's working so far:
* Audio
* Gatekeeper
* HWC
* RIL (needs frameworks edit)
* Wi-Fi
## What needs to be done:
* Better RIL fix (no SIM found)
* Better audio fix (Volume is buggy)
* Fix laggy video playback
* Everything else not tested

</details>
