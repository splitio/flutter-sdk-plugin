# 0.1.7-rc.1 (Nov 9, 2023)

# 0.1.6 (Aug 15, 2023)

* Added `readyTimeout` configuration option.

# 0.1.6-rc.1 (Aug 15, 2023)

# 0.1.5 (Jul 19, 2023)

* Updated iOS SDK to `2.21.0`, which includes:
  * Improved streaming architecture implementation to apply feature flag updates from the notification received which is now enhanced, improving efficiency and reliability of the whole update system.
  * Added logic to do a full check of feature flags immediately when the app comes back to foreground, limited to once per minute.
  * Updated SplitResult init to be public in order to improve testability.

# 0.1.5-rc.1 (Jul 19, 2023)

# 0.1.4 (May 23, 2023)

* Added `setUserConsent` method.
* Added `getUserConsent` method.

# 0.1.4-rc.1 (May 23, 2023)

# 0.1.3 (May 18, 2023)
* Updated iOS SDK to `2.20.1`
* Added support for new configuration options:
  * `impressionsMode`
  * `syncEnabled`
  * `logLevel`
  * `userConsent`
  * `encryptionEnabled`

# 0.1.3-rc.1 (May 18, 2023)

# 0.1.2 (Aug 13, 2022)

Splits from `splitio` as federated implementation.
