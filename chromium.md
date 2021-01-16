# Setting up Chromium

I try to avoid using Google Chrome, but I use Chromium if I need to test how
Chrome will render a page.

There are a few annoyances that I had to figure out the last time I installed
Chromium, on macOS via Homebrew.

## Unwanted Keychain Access when starting Chromium

1. Remove any "Chrome Safe Storage" or "Chromium Safe Storage" items from
   Keychain Access. (This will probably only be an issue if you've previously
   installed these browsers).

## Remove "Google API keys are missing" banner

1. Add the following to `/Applications/Chromium.app/Contents/Info.plist`. If the
   `LSEnvironment` key already exists, add these three key/string pairs to the
   existing entry.

   ```xml
   <key>LSEnvironment</key>
   <dict>
       <key>GOOGLE_API_KEY</key>
       <string>no</string>
       <key>GOOGLE_DEFAULT_CLIENT_ID</key>
       <string>no</string>
       <key>GOOGLE_DEFAULT_CLIENT_SECRET</key>
       <string>no</string>
   </dict>
   ```

   [source](https://stackoverflow.com/a/24274934)

1. Force macOS to re-read all plist configuration files

   ```shell
   /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -seed
   ```

   [source](https://stackoverflow.com/a/16189257)

## Firewall - Deny Incoming Connections

Every time I launch Chromium, it will display the following message. Even if I
click "Deny" every time, the next time I launch it, the message will re-appear.

> Do you want the application “Chromium.app” to accept incoming network
> connections?
