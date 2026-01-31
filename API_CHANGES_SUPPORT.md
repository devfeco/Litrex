# API Changes for Help & Support

This document outlines the API changes required to support the new Help & Support feature in the mobile application.

## 1. Send Support Message Endpoint

**Endpoint:** `POST /api/support/send_message.php`

**Description:** 
This endpoint is used to submit a support inquiry or feedback from the application to the backend. The backend should store this message in a database or forward it via email to the support team.

**Headers:**
- `Content-Type`: `application/x-www-form-urlencoded` or `multipart/form-data`
- `Authorization`: Bearer Token (Optional, but recommended if the user is logged in to link the ticket to their account)

**Request Parameters:**
| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| `subject` | String | Yes      | The subject or topic of the inquiry. |
| `message` | String | Yes      | The detailed message content. |
| `name`    | String | No       | The name of the user (automatically sent if logged in). |
| `email`   | String | No       | The email address of the user (automatically sent if logged in). |

**Example Request:**
```http
POST /api/support/send_message.php HTTP/1.1
Host: yourdomain.com
Content-Type: application/x-www-form-urlencoded

subject=Login Issue&message=I cannot login to my account.&name=John Doe&email=john@example.com
```

**Response (Success - 200 OK):**
```json
{
  "status": true,
  "message": "Your message has been sent successfully."
}
```

**Response (Error - 400 Bad Request):**
```json
{
  "status": false,
  "message": "Subject and message are required."
}
```

## 2. Database Suggestions (Optional)

If you plan to store these messages in the database, consider creating a `support_tickets` or `contact_messages` table:

```sql
CREATE TABLE `support_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `status` enum('pending', 'read', 'replied') DEFAULT 'pending',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
```
