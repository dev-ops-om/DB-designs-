# 🛗 Smart Elevator Control Systems — Database Design

A relational database design for smart building automation, IoT elevator telemetry, destination dispatch control, and predictive maintenance management.

---

## 📌 Problem Overview

Modern high-rise commercial towers and residential complexes no longer use primitive up/down hall buttons. Modern buildings rely on **Destination Dispatch Systems (DDS)** and IoT sensors to minimize passenger wait times, optimize energy consumption, and manage fleet maintenance:

1. **Building Topology & Selective Floor Access**: In skyscrapers, different elevator cars serve different zones (e.g., low-rise cars, express shuttles, freight lifts, or rooftop access).
2. **Destination Dispatching**: Passengers enter their desired destination floor *before* boarding, enabling the dispatch algorithm to group passengers traveling to nearby floors into the same car.
3. **Live Car Telemetry**: Constantly tracking the real-time physical state of each elevator (current floor, travel direction, motion status).
4. **Ride Lifecycle & Wait Time Analytics**: Monitoring the journey from request initiation, assignment, pickup, to arrival at the target floor.
5. **Asset Maintenance & Safety**: Scheduling inspections, tracking breakdowns, and automatically removing elevators from the active dispatch pool during maintenance.

---

## 🗺️ Entity Relationship (ER) Diagram

![Smart Elevator Control Systems](./Smart%20Elevator%20Control%20Systems.png)

---

## 🏛️ Entities & Structure

### 1. Building Topology & Infrastructure
* **`buildings`**: Facilities housing elevator banks (`building_name`, `address`, `building_type`: *Commercial*, *Residential*, *Hospital*).
* **`elevator_shafts`**: Vertical hoistways within a building (`shaft_name`, `shaft_location`: *North Core*, *Express Bay*).
* **`floors`**: Individual vertical levels (`floor_number`, `floor_name`: *Basement 1*, *Lobby*, *Level 42*).

### 2. Elevator Fleet & Floor Coverage
* **`elevators`**: Physical elevator cars (`elevator_name`, `capacity`, `max_weight`, `installation_date`) housed in a specific shaft (`shaft_id`).
* **`elevator_floors`**: Junction table defining which floors a specific elevator can physically service (essential for high-rise express cars and freight lifts).

### 3. Live Telemetry & Operational State
* **`elevator_status`**: Real-time snapshot of an elevator car (`current_floor_id`, `direction`: *up*, *down*, *stationary*, `operational_status`: *idle*, *moving*, *maintenance*, *out_of_service*, `last_updated`).

### 4. Destination Dispatch & Ride Lifecycle
* **`users`**: Passengers making ride requests (`user_name`, `phone`).
* **`ride_requests`**: Passenger hall or app calls (`source_floor_id`, `destination_floor_id`, `request_time`, `request_status`).
* **`ride_assignments`**: Output of the dispatching algorithm assigning a specific elevator to a ride request (`assigned_at`, `assignment_status`).
* **`ride_logs`**: Historical performance record capturing timestamps (`actual_pickup_time`, `actual_drop_time`, `ride_status`) to analyze passenger wait and transit times.

### 5. Maintenance & Safety
* **`maintenance_records`**: Service logs and inspection schedules (`maintenance_type`, `description`, `start_date`, `end_date`, `maintenance_status`).

---

## 💡 Key Design Decisions

* **Floor Service Filtering via `elevator_floors`**: Rather than assuming every elevator can stop at every floor, the `elevator_floors` mapping allows the dispatch algorithm to immediately filter cars capable of serving both the source and destination floors.
* **Separation of Request, Assignment, and Execution**:
  - `ride_requests` records passenger intent.
  - `ride_assignments` pairs requests with elevator cars (allowing dynamic reassignment if a car gets overloaded).
  - `ride_logs` stores historical telemetry and duration metrics for traffic flow analytics.
* **Decoupled Real-Time State (`elevator_status`)**: Keeping live position and direction in a dedicated table allows high-frequency sensor updates without bloating the static elevator asset table.
