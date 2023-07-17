# food_app

# Steps to run
# 1. Install Flutter.

**For Windows:**
- Download Flutter SDK: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.10.6-stable.zip
- Extract the zip file and place the contained flutter in the desired installation location for the Flutter SDK (for example, C:\src\flutter).
- Update path:  If you wish to run Flutter commands in the regular Windows console, take these steps to add Flutter to the PATH environment variable:
    - From the Start search bar, enter ‘env’ and select Edit environment variables for your account.
Under User variables check if there is an entry called Path:
        - If the entry exists, append the full path to flutter\bin using ; as a separator from existing values.
        - If the entry doesn’t exist, create a new user variable named Path with the full path to flutter\bin as its value.
You have to close and reopen any existing console windows for these changes to take effect.
- Install Android Studio:
    - Download and install Android Studio.
    - Start Android Studio, and go through the ‘Android Studio Setup Wizard’. This installs the latest Android SDK, Android SDK Command-line Tools, and Android SDK Build-Tools, which are required by Flutter when developing for Android.
    - Run flutter doctor to confirm that Flutter has located your installation of Android Studio. If Flutter cannot locate it, run flutter config `--android-studio-dir=<directory>` to set the directory that Android Studio is installed to.


**For MacOS:**
- Download Flutter SDK:
    - Apple Silicon: https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.10.6-stable.zip
    - Intel: https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.10.6-stable.zip
- Extract the file in the desired location:
    ```
    cd ~/development
    unzip ~/Downloads/flutter_macos_3.10.6-stable.zip
    ```
- Add the flutter tool to your path:
    ```
    export PATH="$PATH:`pwd`/flutter/bin"
    ```

    To update path to run flutter from any terminal follow: https://docs.flutter.dev/get-started/install/macos#update-your-path

- Install Xcode
    - Install the latest stable version of Xcode (using web download or the Mac App Store).
    - Configure the Xcode command-line tools to use the newly-installed version of Xcode by running the following from the command line:
    ```
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

    sudo xcodebuild -runFirstLaunch
    ```


## 2. Install packages:
```
flutter pub get
```

## 3. Debug on Chrome
```
flutter run -d chrome
```

## 4. Screenshots
<img width="1112" alt="Screenshot 2023-07-17 at 10 16 05" src="https://github.com/haily835/food_app/assets/53532432/8e36735d-f544-4eb6-bfa7-fc6152a0c828">
<img width="1125" alt="Screenshot 2023-07-17 at 10 16 30" src="https://github.com/haily835/food_app/assets/53532432/808de0dd-bfa1-47c0-bd58-9892c6ed4ff1">
<img width="1148" alt="Screenshot 2023-07-17 at 10 16 55" src="https://github.com/haily835/food_app/assets/53532432/99e16ad3-d7ed-4f7d-a479-7f319e77fb23">
