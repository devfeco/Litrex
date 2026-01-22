# Premium Feature & In-App Purchase Implementation Guide

This guide outlines the steps to implement and configure the Premium feature using Google In-App Billing in your Flutter application and the necessary backend changes.

## 1. Backend Implementation (PHP)

You need to update your MySQL database and PHP API to handle user subscription status.

### Database Changes
Run the following SQL query to update your `users` table (or whatever table stores user data):

```sql
ALTER TABLE `users`
ADD COLUMN `is_premium` TINYINT(1) DEFAULT 0,
ADD COLUMN `premium_expiry_date` DATETIME NULL,
ADD COLUMN `subscription_id` VARCHAR(255) NULL; -- To store Google Purchase Token or Order ID
```

### API Endpoints

You need to create or update an endpoint to verify purchases and update the user's status.

**Endpoint:** `OST_premium_status.php` (Example)
**Method:** `POST`

**Request Body:**
```json
{
  "user_id": 123,
  "purchase_token": "token_from_google",
  "product_id": "premium_1_month",
  "package_name": "com.litrex.ebook"
}
```

**Logic:**
1. Verify the `purchase_token` with Google Play Developer API (Optional but recommended for security).
2. If valid, calculate the expiry date based on `product_id` (e.g., +1 month or +3 months).
3. Update the `users` table:
   - Set `is_premium = 1`
   - Set `premium_expiry_date = [calculated_date]`
   - Set `subscription_id = [purchase_token]`
4. Return success response with new user profile data.

## 2. Google Play Console Setup

To test In-App Purchases, you must set them up in the Google Play Console.

1.  **Create a Merchant Account:** link it to your developer account.
2.  **Create Application:** If not already created.
3.  **Monetize > Products > Subscriptions:**
    *   Create a subscription.
    *   **Base Plan 1:** Monthly (e.g., ID: `premium_monthly`, Price: $4.99)
    *   **Base Plan 2:** 3 Months (e.g., ID: `premium_quarterly`, Price: $12.99)
4.  **License Testing:**
    *   Go to **Setup > License Testing**.
    *   Add your tester email addresses (the accounts logged in on your test devices).
    *   This allows you to "buy" items without being charged real money (test cards).

## 3. Flutter Integration Details

The `PremiumScreen.dart` has been created with the following logic:

*   **UI:** Displays two packages (1 Month & 3 Months) with benefits.
*   **Logic:**
    *   Uses `in_app_purchase` package.
    *   Listens to purchase updates (`_listenToPurchaseUpdated`).
    *   When a user clicks "Buy":
        *   Initiates purchase flow with Google.
        *   On success, calls your backend API (`enablePremiumOnBackend`) to update the database.

### Important Note on Testing
*   In-App Purchases **DO NOT WORK** on the iOS Simulator or Android Emulator unless you have Google Play Store installed and logged in with a tester account.
*   You must use a **Real Device** or a specific emulator image with Google Play.
*   The app must be signed and uploaded to Internal Test Track (at least once draft) for IAP items to be fetched.

## 4. Next Steps for You

1.  **Backend:** Implement the database columns and the API endpoint to update the user status.
2.  **Google Console:** Create the subscription products matching the IDs used in `PremiumScreen.dart` (`premium_monthly`, `premium_quarterly`).
3.  **Testing:** Build a signed APK/AAB, verify on a real device.
