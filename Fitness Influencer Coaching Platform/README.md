# 🏋️ Fitness Influencer Coaching Platform — Database Design

A relational database design for a fitness influencer/trainer coaching platform, managing personalized client training programs, periodic check-ins, biometric progress tracking, live 1-on-1 consultation sessions, and payments.

---

## 📌 Problem Overview

Modern fitness influencers and personal trainers manage remote coaching businesses that require more than simple static workout PDFs. They need a scalable system to:

1. **Manage Diverse Client Roster**: Track assigned clients, personal health profiles, and training preferences.
2. **Flexible Monetization**: Offer structured multi-week coaching packages (`coaching_plans`) with active subscription lifecycles, as well as pay-per-session bookings.
3. **Structured Check-In Workflows**: Routine client check-ins with subjective feedback (`client_report`) and trainer reviews (`trainer_notes`).
4. **Dynamic Biometric Progress Tracking**: Capture varying metrics (weight, body fat %, waist size, chest measurements) over time without altering table schemas for new metrics.
5. **Live Virtual Coaching**: Schedule and manage video consultations or workout review calls with calendar timestamps and meeting URLs.

---

## 🗺️ Entity Relationship (ER) Diagram

![Fitness Influencer Coaching Platform](./Fitness%20Influencer%20Coaching%20Platform.png)

---

## 🏛️ Entities & Structure

### 1. Core Profiles
* **`trainers`**: The coaching professionals/influencers (`full_name`, `email`, `specialization`, `experience_years`).
* **`clients`**: Individuals receiving coaching (`full_name`, `email`, `phone`, `date_of_birth`, `gender`), assigned to a primary trainer (`trainer_id`).

### 2. Plans & Subscriptions
* **`coaching_plans`**: Programs defined by trainers (`plan_name`, `description`, `duration_days`, `price`).
* **`subscriptions`**: Active or past enrollment of a client in a coaching plan (`start_date`, `end_date`, `status`).

### 3. Progress Tracking & Check-Ins
* **`check_ins`**: Periodic submissions by clients (`submitted_at`, `client_report`) reviewed by trainers (`trainer_notes`, `reviewed_at`, `status`).
* **`progress_records`**: Granular biometric data points associated with a check-in (`metric_name`, `metric_value`, `unit`, `recorded_at`), allowing flexible tracking of weight, body fat, waist circumference, etc.

### 4. Consultations & Payments
* **`sessions`**: Scheduled 1-on-1 virtual calls or reviews (`session_type`, `scheduled_at`, `duration_minutes`, `meeting_link`, `status`), linked to the client, trainer, and subscription.
* **`payments`**: Financial audit log (`amount`, `payment_method`, `payment_status`, `transaction_reference`, `paid_at`), linking optionally to a subscription plan or an individual session booking.

---

## 💡 Key Design Decisions

* **Flexible Metric Tracking**: Using `progress_records` tied to `check_ins` acts like a normalized metric log. Clients can log different measurements (weight, waist, arm size, body fat) without adding new columns to the database.
* **Unified Payment Handling**: The `payments` table cleanly links to either a recurring `subscription_id` or an ad-hoc `session_id`, supporting both subscription models and pay-per-session consulting.
* **Accountability & Review Loop**: `check_ins` tracks both submission and review timestamps (`submitted_at` vs `reviewed_at`), allowing the platform to measure trainer response times and client engagement.
