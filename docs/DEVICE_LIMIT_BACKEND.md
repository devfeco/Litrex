# Backend Device Limit Implementation Guide

This guide outlines the backend changes required to implement the single device login policy.

## Database Changes

Add a `device_id` column to the `users` table to store the ID of the currently active device.

```sql
ALTER TABLE users ADD COLUMN device_id VARCHAR(255) DEFAULT NULL;
```

## Logic Implementation

### 1. Login Endpoint (`auth/login.php`)

When a user logs in, the backend must respond based on the policy (Login from new device handling).

**Request Parameters:**
- `email`
- `password`
- `device_id` (New parameter)

**Logic:**
1.  Authenticate the user with `email` and `password`.
2.  If authentication fails, return error.
3.  If authentication succeeds:
    *   **Option A (Auto Logout Previous):** Update the `device_id` in the database with the new `device_id`. This effectively invalidates the old session if you check `device_id` on other requests.
    *   **Option B (Block New Login):** Check if `users.device_id` is not null AND `users.device_id` != `incoming_device_id`.
        *   If different, return an error: "Account is active on another device."
        *   (Optional) Provide a "Force Login" flag to allow the user to override this (switching to Option A logic).

**Recommended Implementation (Auto Logout Previous):**
Always update the `device_id` on successful login.

```php
// Pseudo-code for login.php
$device_id = $_POST['device_id'];

// ... verify credentials ...

// Update device_id
$stmt = $pdo->prepare("UPDATE users SET device_id = ? WHERE id = ?");
$stmt->execute([$device_id, $user_id]);

// ... return token ...
```

### 2. Session/Token Verification (Middleware or Common Include)

On every protected API request, you should verify if the device making the request is valid. This prevents the "old" device from continuing to use the app if a new device has logged in.

**This requires the client to send the `device_id` (or include it in the token claim) with every request, OR simply relying on the fact that if Option A is chosen, the old `device_id` in the DB won't match if we were tracking sessions strictly.**

However, a simpler active check for "Single Device" usually works like this:
1.  Client sends `device_id` in headers or body for critical actions.
2.  Server checks `SELECT device_id FROM users WHERE id = ?`.
3.  If `db_device_id` != `request_device_id`, return `401 Unauthorized` with a message "Logged in on another device".

**Alternative (Simpler for REST APIs):**
If you are using JWTs, you might invalidate the old token. But standard JWTs are stateless.
The `device_id` in the database is the "source of truth".

**Suggested Endpoint `auth/check_device.php` (Optional but good for polling):**
The app can periodically call this or check it on app resume.
```php
// check_device.php
$user_id = $auth_user_id;
$current_device_id = $_POST['device_id'];

$stmt = $pdo->prepare("SELECT device_id FROM users WHERE id = ?");
$stmt->execute([$user_id]);
$stored_device_id = $stmt->fetchColumn();

if ($stored_device_id !== $current_device_id) {
    http_response_code(401);
    echo json_encode(['message' => 'Session expired. Logged in on another device.']);
} else {
    echo json_encode(['status' => 'valid']);
}
```

## Summary of Flutter Changes (Already handling)

1.  **Login:** Send `device_id`.
2.  **App Start/Resume:** Check if the current local `device_id` matches the one needed (or handle 401 errors gracefully).
