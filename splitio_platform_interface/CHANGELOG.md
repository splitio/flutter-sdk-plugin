# 1.5.0-rc.2 (Oct 17, 2024)

# 1.5.0-rc.1 (Oct 17, 2024)

# 1.4.0 (Nov 9, 2023)
* Added support for Flag Sets, which enables grouping feature flags and interacting with the group rather than individually (more details in our documentation):
  * Added new variations of the get treatment methods to support evaluating flags in given flag set/s.
    * getTreatmentsByFlagSet and getTreatmentsByFlagSets
    * getTreatmentWithConfigByFlagSets and getTreatmentsWithConfigByFlagSets
  * Added a new optional Split Filter configuration option. This allows the SDK and Split services to only synchronize the flags in the specified flag sets, avoiding unused or unwanted flags from being synced on the SDK instance, bringing all the benefits from a reduced payload.
  * Added `defaultTreatment` property to the `SplitView` object returned by the `split` and `splits` methods of the SDK manager.

# 1.4.0-rc.1 (Nov 9, 2023)

# 1.3.0 (Aug 15, 2023)

* Added `readyTimeout` configuration option.

# 1.3.0-rc.1 (Aug 15, 2023)

# 1.2.0 (May 23, 2023)

* Added `setUserConsent` method.
* Added `getUserConsent` method.

# 1.2.0-rc.1 (May 23, 2023)

# 1.1.0 (May 18, 2023)
* Added support for new configuration options:
    * `impressionsMode`
    * `syncEnabled`
    * `logLevel`
    * `userConsent`
    * `encryptionEnabled`
* Deprecated `enableDebug` configuration in favor of `logLevel`.

# 1.1.0-rc.1 (May 18, 2023)

# 1.0.0 (Aug 13, 2022)

Initial release.
