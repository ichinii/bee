# Setup for Android

For Godot documentation see [here](https://docs.godotengine.org/en/3.0/getting_started/workflow/export/exporting_for_android.html).

## Godot setup

In Editor > Editor Settings > Export > Android:
- Adb setzen auf `which adb` (bei mir wars /usr/sbin/adb)
- jarsigner setzen auf `which jarsigner` (bei mir wars /usr/sbin/jarsigner)
- Debug Keystore setzen auf Android Debug Keystore (bei mir wars ~/.android/debug.keystore)

## Android ndk setup

```bash
yaourt -S android-ndk
```

### error "no space left on device"
```bash
sudo mount --bind /home/<user>/tmp/ /tmp/
```
