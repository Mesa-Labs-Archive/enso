![Banner](img/banner.png?raw=true)
=====

This repo contains ensō sources for managing device-specific bins/libs/generic files (first boot /system script) or features (TODO on-the-fly java class).

You may need to install Python 2.7 for the script to be created.


Supported devices list:
=====
<details>

### Exynos 8895 family (S8/Note8) [hadesTreble]:
## What's working so far:
* Audio
* Boot (M20 needs extra SecExternalDisplay native methods)
* Gatekeeper
* HWC
* RIL (needs S9's vendor.samsung.hardware.radio framework)
* Wi-Fi (needs S9's vendor.samsung.hardware.wifi framework)
## What needs to be done:
* Better audio fix (Volume is buggy)
* Samsung Camera FC
* Everything else not tested

</details>
