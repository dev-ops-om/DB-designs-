# 🗄️ Database Design Series

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Designs Count](https://img.shields.io/badge/Designs-1%20Completed%20%7C%205%20Upcoming-orange.svg)](#-database-design-index)
[![Standard](https://img.shields.io/badge/Standard-3NF%20Relational%20Design-brightgreen.svg)](#)
[![Author](https://img.shields.io/badge/Author-Om%20Shirbhate-purple.svg)](https://github.com/dev-ops-om)

A curated collection of production-grade, real-world **Database Designs, Schemas, and ER Diagrams**.

Rather than simple academic exercises, every design in this series tackles complex real-world edge cases: **concurrency control**, **multi-tier access policies**, **spatial compatibility matrices**, **auditability**, and **high-throughput transaction lifecycles**.

---

## 📚 Database Design Index

| # | System Design | Domain | Primary Challenge Addressed | Status |
|:---:|:---|:---|:---|:---:|
| **01** | [**Comic-Con Parking System**](./Comic-Con%20Parking%20System%20-%20Database%20Design/README.md) | Logistics / Event Venues | Dual compatibility (spatial fit + credential clearance), multi-zone hierarchies & session ticketing | **Completed** ✅ |
| **02** | **Multi-Vendor E-Commerce Platform** | Retail / Marketplaces | SKU variant matrices, inventory reservation, order escrow & split payouts | *Coming Soon* 🚀 |
| **03** | **Hospital & Emergency EHR System** | Healthcare | Shift rosters, doctor scheduling, patient electronic health records & bed allocation | *Coming Soon* 🚀 |
| **04** | **Ride-Sharing & Fleet Dispatch** | Mobility / On-Demand | Geospatial driver matching, dynamic surge pricing & live ride state-machines | *Coming Soon* 🚀 |
| **05** | **Event Ticketing & Cinema Concurrency** | Entertainment / Booking | Pessimistic row-level locking (`FOR UPDATE`), temporary seat holds & zero double-booking | *Coming Soon* 🚀 |
| **06** | **Cloud Kitchen & Food Delivery Aggregator** | Food Tech | Multi-outlet menu customizations, delivery fleet routing & real-time order tracking | *Coming Soon* 🚀 |

---

## 🎯 Spotlight: Design 01 — Comic-Con Parking System

The first design in the series models a large-scale convention parking facility with high vehicle variance and access restrictions:

* 🏢 **Spatial Hierarchy**: `parking_zones` ➡️ `parking_levels` ➡️ `parking_spots`.
* ⚡ **Physical Compatibility**: Resolves whether an EV, SUV, or large production truck can fit in a given bay via `spot_category_vehicle_compatibility`.
* 🛡️ **Access Control Layer**: Enforces convention clearance (VIP, Exhibitor, Crew, General Public) with time-window validity via `spot_category_access_compatibility` and `vehicle_access`.
* 🎟️ **Ticketing Lifecycle**: Tracks active entry-to-exit stays and barcode ticket records via `parking_sessions` and `tickets`.

👉 **[Read the Full Documentation, ER Diagram & SQL Schema](./Comic-Con%20Parking%20System%20-%20Database%20Design/README.md)**

---

## 📐 Design Philosophy & Best Practices

Across every schema in this repository, the following core principles are strictly maintained:

1. **Third Normal Form (3NF) Baseline**: Eliminates update, insert, and delete anomalies by ensuring non-key attributes are fully dependent only on primary keys.
2. **Junction Tables for Many-to-Many Relationships**: Complex constraints (like vehicle size fit vs security clearance) are separated into dedicated junction tables with composite unique constraints.
3. **Explicit Integrity Constraints**:
   - Foreign Keys with explicit `ON DELETE CASCADE` or `ON DELETE RESTRICT` semantics.
   - `CHECK` constraints on date windows (`valid_until > valid_from`) and financial totals (`total_fee >= 0`).
   - `UNIQUE` composite constraints to prevent duplicate allocations.
4. **Index Strategy**: High-cardinality search fields, foreign keys, and operational state columns are indexed for high query performance.
5. **Self-Contained Executable DDL**: Every folder includes a ready-to-run `schema.sql` script with sample seed data for instant testing in PostgreSQL or MySQL.

---

## 🚀 How to Use This Repository

Each system design lives in its own dedicated folder containing:
* `README.md` — Detailed problem statement, architectural breakdown, entity dictionary, and query examples.
* `*.png` — High-resolution ER diagram.
* `schema.sql` — Complete SQL DDL script ready to execute.

### Testing any schema locally:
```bash
# Clone the repository
git clone https://github.com/dev-ops-om/DB-designs-.git
cd DB-designs-

# Run the Comic-Con parking schema in PostgreSQL
psql -U postgres -d postgres -f "Comic-Con Parking System - Database Design/schema.sql"
```

---

## 👨‍💻 Author

**Om Shirbhate**  
* GitHub: [@dev-ops-om](https://github.com/dev-ops-om)  
* Passionate about scalable backend systems, database engineering, and clean architecture.

---

## 📄 License

This repository is distributed under the MIT License. Feel free to use, study, and build upon these database designs.
