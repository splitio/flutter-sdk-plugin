# 1.2.1 (Jan 28, 2026)
* Bug fix: corrected asset path for loading the Browser SDK.

# 1.2.1-rc.1 (Jan 28, 2026)

# 1.2.0 (Jan 28, 2026)
* Added new configuration for Fallback Treatments, which allows setting a treatment value and optional config to be returned in place of "control", either globally or by flag. Read more in our docs.
* Updated Android SDK to `5.4.2`, iOS SDK to `3.6.0`, and Browser SDK to `1.6.1`

# 1.2.0-rc.1 (Jan 28, 2026)

# 1.1.0 (Jan 16, 2026)
* Added Web support via the `splitio_web` package, the Web implementation of `splitio` based on the Split Browser SDK `1.6.0`.

# 1.1.0-rc.1 (Jan 15, 2026)

# 1.0.0 (Aug 14, 2025)
* Updated Android SDK to `5.3.1` & iOS SDK to `3.3.2`
* Added support for rule-based segments. These segments determine membership at runtime by evaluating their configured rules against the user attributes provided to the SDK.
* Added support for feature flag prerequisites. This allows customers to define dependency conditions between flags, which are evaluated before any allowlists or targeting rules.
* Added two new configuration options to control the behavior of the persisted rollout plan cache. Use `rolloutCacheConfiguration` in the config.
* Added a new optional argument to the client `getTreatment` methods to allow passing additional evaluation options, such as a map of properties to append to the generated impressions sent to Split backend. Read more in our docs.
* Added support for the new impressions tracking toggle available on feature flags, both respecting the setting and including the new field being returned on SplitView type objects. Read more in our docs.

# 1.0.0-rc.1 (Aug 14, 2025)

# 0.2.0 (Nov 6, 2024)
* Added support for targeting rules based on large segments.
* BREAKING CHANGE (for Split Proxy users):
  * Dropped support for Split Proxy below version `5.9.0`.
* Updated iOS SDK to `3.0.0` & Android SDK to `5.0.0`.

# 0.2.0-rc.1 (Nov 6, 2024)

# 0.1.10 (Oct 18, 2024)
* Added certificate pinning functionality. This feature allows you to pin a certificate to the SDK, ensuring that the SDK only communicates with servers that present this certificate. Read more in our documentation.
* Updated iOS SDK to `2.26.1` & Android SDK to `4.2.2`

# 0.1.10-rc.1 (Oct 17, 2024)

# 0.1.9+1 (Jun 7, 2024)
* Updated Android SDK to `4.1.1`

# 0.1.9 (May 22, 2024)
* Added support for targeting rules based on semantic versions (https://semver.org/).
* Added special impression label "targeting rule type unsupported by sdk" when the matcher type is not supported by the SDK, which returns 'control' treatment.
* Updated iOS SDK to `2.25.0` & Android SDK to `4.1.0`

# 0.1.9-rc.1 (May 22, 2024)

# 0.1.8 (Feb 7, 2024)
* Updated iOS SDK to `2.24.3` & Android SDK to `4.0.0`

# 0.1.7+1-rc.2 (Feb 7, 2024)

# 0.1.7+1-rc.1 (Feb 7, 2024)

# 0.1.7 (Nov 9, 2023)
* Added support for Flag Sets, which enables grouping feature flags and interacting with the group rather than individually (more details in our documentation):
  * Added new variations of the get treatment methods to support evaluating flags in given flag set/s.
    * getTreatmentsByFlagSet and getTreatmentsByFlagSets
    * getTreatmentWithConfigByFlagSets and getTreatmentsWithConfigByFlagSets
  * Added a new optional Split Filter configuration option. This allows the SDK and Split services to only synchronize the flags in the specified flag sets, avoiding unused or unwanted flags from being synced on the SDK instance, bringing all the benefits from a reduced payload.
  * Added `defaultTreatment` property to the `SplitView` object returned by the `split` and `splits` methods of the SDK manager.
* Updated iOS SDK to `2.23.0`
* Updated Android SDK to `3.4.0`

# 0.1.7-rc.1 (Nov 9, 2023)

# 0.1.6 (Aug 15, 2023)

* Added `readyTimeout` configuration option. If the SDK is not ready after the amount of time (in seconds) specified by this option, the `whenTimeout` future of the client will be completed. Defaults to 10 seconds. A negative value means no timeout.

# 0.1.6-rc.1 (Aug 15, 2023)

# 0.1.5 (Jul 19, 2023)

* Updated iOS SDK to `2.21.0` & Android SDK to `3.3.0`

# 0.1.5-rc.1 (Jul 19, 2023)

# 0.1.4 (May 23, 2023)

* Added `setUserConsent` method.
* Added `getUserConsent` method.

# 0.1.4-rc.1 (May 23, 2023)

# 0.1.3 (May 18, 2023)

* Updated iOS SDK to `2.20.1` & Android SDK to `3.2.1`
* Added support for new configuration options:
    * `impressionsMode`
    * `syncEnabled`
    * `logLevel`
    * `userConsent`
    * `encryptionEnabled`
* Deprecated `enableDebug` configuration in favor of `logLevel`.

# 0.1.3-rc.1 (May 18, 2023)

# 0.1.2+2 (Dec 7, 2022)

Added consumer ProGuard rules for Android.

# 0.1.2+1 (Sep 14, 2022)

Added exports for models.

# 0.1.2 (Sep 13, 2022)

* Migrated to federated structure.
* Added support for Impression Listener.
* Added support for Sync Configuration.
* Added support for SDK event listeners.
* Added support for manager methods.
* Added support for linking native factory.

# 0.1.1 (Aug 19, 2022)

Minor fixes.

# 0.1.0 (Aug 3, 2022)

Initial release.

* Added support for SDK instantiation.
* Added support for multiple clients.
* Added support for evaluation.
* Added support for tracking events.
