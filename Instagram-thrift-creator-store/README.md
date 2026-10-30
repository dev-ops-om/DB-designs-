# 👗 Instagram Thrift & Creator Store — Database Design

A relational database design tailored for Instagram thrift stores, vintage curators, and independent creator merchandise brands.

---

## 📌 Problem Overview

Selling through Instagram has evolved from basic DM negotiations into structured digital storefronts. However, thrift and creator businesses have unique inventory models that standard e-commerce schemas struggle to represent:

1. **Dual Product Archetypes**:
   * **1-of-1 Thrifted / Vintage Items**: Unique, single-quantity pieces. Each piece has distinct grading (`condition`: Brand New, Vintage 9/10, Distressed), individual sizing, and a single-unit lifecycle (`availability_status`: available, reserved, sold).
   * **Handmade & Batch Creator Drops**: Hand-crafted items (e.g., custom jewelry, crochet tops, screen-printed totes) that have batch stock (`quantity_available`) and lead times (`production_time_days`).
2. **Order Fulfillment Tracking**: Managing order confirmations, itemized cart breakdowns (`order_items`), upfront payment tracking (UPI, Card, COD), and package shipments with courier tracking numbers.
3. **Store Admin & Customer Separation**: Dedicated creator admin management (`users`) with authentication tokens separate from guest or registered shoppers (`customers`).

---

## 🗺️ Entity Relationship (ER) Diagram

![Instagram Thrift Creator Store](./Instagram%20Thrift%20Creator%20Store.png)

---

## 🏛️ Entities & Structure

### 1. User & Customer Management
* **`users`**: Platform administrators and store owners with authentication credentials, role permissions, and token verification.
* **`customers`**: Shoppers placing orders (`customer_name`, `email`, `phone`, `address`).

### 2. Product Catalog & Class-Table Inheritance
* **`product_categories`**: Catalog groupings (e.g., Jackets, Graphic Tees, Handmade Jewelry, Denim).
* **`products`** *(Base Table)*: Common product attributes (`product_name`, `description`, `price`, `category_id`).
* **`thrift_products`** *(Specialized Sub-type)*: 1-of-1 vintage items requiring specific descriptors (`size`, `color`, `condition`, `availability_status`).
* **`handmade_products`** *(Specialized Sub-type)*: Made-to-order or batch-crafted goods requiring inventory counts (`quantity_available`) and manufacturing lead times (`production_time_days`).

### 3. Orders & Line Items
* **`orders`**: Transaction header recording customer reference, order timestamp, total price, and progression status (`pending`, `confirmed`, `shipped`, `delivered`).
* **`order_items`**: Line items linking each ordered product, quantity purchased, and the locked `unit_price` at the moment of sale.

### 4. Payments & Fulfillment
* **`payments`**: Payment processing log (`payment_method`, `payment_status`, `payment_date`) linked to the order.
* **`shipments`**: Logistics record capturing courier dispatch, `tracking_number`, `shipping_status`, and delivery dates.

---

## 💡 Key Design Decisions

* **Class-Table Inheritance (Sub-Typing)**: Rather than stuffing nullable fields into a bloated generic table, `products` acts as a shared base, while `thrift_products` and `handmade_products` store archetype-specific attributes with shared primary keys (`product_id`).
* **Single-Unit Concurrency Protection**: For thrift items, `availability_status` cleanly differentiates between items that are browseable, temporarily reserved during checkout, or sold out.
* **Historical Price Snapshotting**: `order_items` stores `unit_price` at checkout time, ensuring that future price updates on products never mutate past order records.
