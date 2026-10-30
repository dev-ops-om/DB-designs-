# 🚗 Comic-Con Parking System — Database Design

A database design for managing parking operations at large-scale convention venues like **Comic-Con**.

---

## 📌 Problem Overview

A typical convention like Comic-Con has thousands of attendees arriving in different vehicle types (cars, SUVs, motorcycles, EVs, and large crew/production trucks). Moreover, attendees have different credential tiers (General Public, VIPs, Exhibitors, Production Crew, and Media).

A simple parking system is not enough because:
1. **Physical Compatibility**: A heavy equipment truck or an EV needing a charger cannot park in a standard compact spot.
2. **Access Clearance**: Certain VIP or backstage bays are restricted to specific credential holders.
3. **Time-Bounded Access**: Exhibitors and media might only have access during specific days or hours.

This design solves these challenges by separating **physical vehicle fit** from **access permissions** using normalized tables and compatibility layers.

---

## 🗺️ Entity Relationship (ER) Diagram

![Comic-Con Parking System](./Comic-Con%20Parking%20System%20final.png)

---

## 🏛️ Entities & Structure

### 1. Spatial Structure
* **`parking_zones`**: High-level geographic sections (e.g., North Lot, Underground Deck, Backstage VIP).
* **`parking_levels`**: Floors or sublevels within a zone (e.g., Level 1, Basement B2).
* **`parking_spots`**: Individual parking stalls assigned to a level and category, with operational status (`available`, `occupied`, `maintenance`).

### 2. Vehicle & Access Categories
* **`vehicle_categories`**: Types of vehicles (Motorcycle, Sedan, SUV, EV, Production Truck).
* **`vehicles`**: Vehicle records with license plate number and category.
* **`parking_spot_categories`**: Stall types based on physical setup (Standard, EV Charging, Handicapped, Heavy Truck).
* **`access_categories`**: User privilege tiers (General Public, VIP Guest, Exhibitor, Crew/Staff).
* **`vehicle_access`**: Time-windowed access passes (`validFrom`, `validUntil`) granting a vehicle specific access credentials.

### 3. Compatibility Junction Tables
* **`spot_category_vehicle_compatibility`**: Defines which vehicle categories can physically park in which spot categories.
* **`spot_category_access_compatibility`**: Defines which credential tiers are allowed to occupy which spot categories.

### 4. Sessions & Ticketing
* **`parking_sessions`**: Tracks entry time, exit time, allocated spot, vehicle, and total calculated fee.
* **`tickets`**: Barcode/QR passes issued for an active parking session with validation status.

---

## 💡 Key Design Decisions

* **Dual Compatibility Separation**: Separates the physical constraint (*"Can this vehicle fit here?"*) from the security/privilege constraint (*"Is this vehicle allowed here?"*).
* **Time-Windowed Access**: `vehicle_access` includes `validFrom` and `validUntil` so exhibitor and crew parking passes automatically expire when their pass window ends.
* **Flexibility**: New spot types (e.g. VIP EV spot) or vehicle types can be introduced without altering existing table structures.
