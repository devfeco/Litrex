# API Changes for Dynamic Ad Configuration

To support full dynamic configuration of AdMob and Facebook Audience Network ads (including Native and Adaptive Banner ads) from the admin panel, the `adsconfiguration` object in the **`dashboard.php`** response needs to be updated.

## New Fields Required in `adsconfiguration`

Please add the following keys to the JSON response of `dashboard.php` under the `adsconfiguration` section:

### AdMob Native & Adaptive
*   **`"admob_native_id"`**: (String) The AdMob Unit ID for Native Ads on Android.
*   **`"admob_native_id_ios"`**: (String) The AdMob Unit ID for Native Ads on iOS.
*   **`"admob_adaptive_banner_id"`**: (String) The AdMob Unit ID for the Adaptive Banner on Android (used in Home Screen).
*   **`"admob_adaptive_banner_id_ios"`**: (String) The AdMob Unit ID for the Adaptive Banner on iOS.

### Facebook Native
*   **`"facebook_native_id"`**: (String) The Facebook Placement ID for Native Ads on Android.
*   **`"facebook_native_id_ios"`**: (String) The Facebook Placement ID for Native Ads on iOS.

---

## Example JSON Response

```json
{
  "adsconfiguration": {
    "ads_type": "admob",
    "admob_banner_id": "ca-app-pub-...",
    "admob_interstitial_id": "ca-app-pub-...",
    "admob_banner_id_ios": "ca-app-pub-...",
    "admob_interstitial_id_ios": "ca-app-pub-...",
    
    "admob_native_id": "ca-app-pub-...",
    "admob_native_id_ios": "ca-app-pub-...",
    "admob_adaptive_banner_id": "ca-app-pub-...",
    "admob_adaptive_banner_id_ios": "ca-app-pub-...",
    
    "facebook_banner_id": "YOUR_FB_ID",
    "facebook_interstitial_id": "YOUR_FB_ID",
    "facebook_banner_id_ios": "YOUR_FB_ID_IOS",
    "facebook_interstitial_id_ios": "YOUR_FB_ID_IOS",
    
    "facebook_native_id": "YOUR_FB_ID",
    "facebook_native_id_ios": "YOUR_FB_ID_IOS",
    
    "interstitial_ads_interval": "1",
    "banner_ad_book_list": "1",
    "banner_ad_category_list": "1",
    ...
  }
}
```

## Backend Implementation Note
1.  Add columns to the `settings` or `ads_config` table in the database to store these new IDs.
2.  Update the admin panel UI to allow entering these IDs.
3.  Update the `dashboard.php` API endpoint to fetch these values and include them in the response.
