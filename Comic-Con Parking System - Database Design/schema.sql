-- =============================================================================
-- Comic-Con Parking System - Database Schema (PostgreSQL / Relational SQL)
-- Design Series by Om Shirbhate (dev-ops-om)
-- =============================================================================

-- 1. Parking Zones (High-level spatial partitions: North Lot, VIP Pavilion, Basement Garage)
CREATE TABLE IF NOT EXISTS parking_zones (
    zone_id SERIAL PRIMARY KEY,
    zone_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 2. Parking Levels (Vertical or sub-sectional partitioning within a zone)
CREATE TABLE IF NOT EXISTS parking_levels (
    level_id SERIAL PRIMARY KEY,
    zone_id INT NOT NULL REFERENCES parking_zones(zone_id) ON DELETE CASCADE,
    level_name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_zone_level UNIQUE (zone_id, level_name)
);

-- 3. Parking Spot Categories (Physical attributes: Standard, Compact, EV Charging, Handicapped, Oversized)
CREATE TABLE IF NOT EXISTS parking_spot_categories (
    spot_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 4. Vehicle Categories (Vehicle classifications: Two-Wheeler, Sedan, SUV, EV, Heavy Production Truck, Bus)
CREATE TABLE IF NOT EXISTS vehicle_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 5. Access Categories (Convention clearance: General Public, VIP Celebrity, Crew/Staff, Exhibitor, Media/Press)
CREATE TABLE IF NOT EXISTS access_categories (
    access_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 6. Vehicles (Registered vehicle profiles)
CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    registration_no VARCHAR(50) NOT NULL UNIQUE,
    category_id INT NOT NULL REFERENCES vehicle_categories(category_id) ON DELETE RESTRICT
);

-- 7. Spot Category - Vehicle Compatibility (Junction: which vehicle types can physically fit into which spot types)
CREATE TABLE IF NOT EXISTS spot_category_vehicle_compatibility (
    compatibility_id SERIAL PRIMARY KEY,
    spot_category_id INT NOT NULL REFERENCES parking_spot_categories(spot_category_id) ON DELETE CASCADE,
    vehicle_category_id INT NOT NULL REFERENCES vehicle_categories(category_id) ON DELETE CASCADE,
    CONSTRAINT uq_spot_vehicle_compat UNIQUE (spot_category_id, vehicle_category_id)
);

-- 8. Spot Category - Access Compatibility (Junction: which access tiers are permitted in which spot categories)
CREATE TABLE IF NOT EXISTS spot_category_access_compatibility (
    access_compatibility_id SERIAL PRIMARY KEY,
    spot_category_id INT NOT NULL REFERENCES parking_spot_categories(spot_category_id) ON DELETE CASCADE,
    access_category_id INT NOT NULL REFERENCES access_categories(access_category_id) ON DELETE CASCADE,
    CONSTRAINT uq_spot_access_compat UNIQUE (spot_category_id, access_category_id)
);

-- 9. Vehicle Access (Temporary or multi-day convention access passes granted to a vehicle)
CREATE TABLE IF NOT EXISTS vehicle_access (
    vehicle_access_id SERIAL PRIMARY KEY,
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    access_category_id INT NOT NULL REFERENCES access_categories(access_category_id) ON DELETE RESTRICT,
    valid_from TIMESTAMP WITH TIME ZONE NOT NULL,
    valid_until TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT chk_valid_window CHECK (valid_until > valid_from)
);

-- 10. Parking Spots (Individual physical parking spaces)
CREATE TABLE IF NOT EXISTS parking_spots (
    spot_id SERIAL PRIMARY KEY,
    level_id INT NOT NULL REFERENCES parking_levels(level_id) ON DELETE CASCADE,
    spot_category_id INT NOT NULL REFERENCES parking_spot_categories(spot_category_id) ON DELETE RESTRICT,
    spot_number VARCHAR(50) NOT NULL,
    operational_status VARCHAR(50) NOT NULL DEFAULT 'available', -- 'available', 'occupied', 'maintenance', 'reserved'
    CONSTRAINT uq_level_spot_number UNIQUE (level_id, spot_number)
);

-- 11. Parking Sessions (Lifecycle of an entry-to-exit parking stay)
CREATE TABLE IF NOT EXISTS parking_sessions (
    session_id SERIAL PRIMARY KEY,
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id) ON DELETE RESTRICT,
    spot_id INT NOT NULL REFERENCES parking_spots(spot_id) ON DELETE RESTRICT,
    rate_id INT DEFAULT 1,
    entry_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    exit_time TIMESTAMP WITH TIME ZONE,
    session_status VARCHAR(50) NOT NULL DEFAULT 'active', -- 'active', 'completed', 'cancelled'
    total_fee NUMERIC(10, 2) DEFAULT 0.00,
    CONSTRAINT chk_session_times CHECK (exit_time IS NULL OR exit_time >= entry_time)
);

-- 12. Tickets (Barcode/RFID paper or digital gate passes associated with a parking session)
CREATE TABLE IF NOT EXISTS tickets (
    ticket_id SERIAL PRIMARY KEY,
    session_id INT NOT NULL REFERENCES parking_sessions(session_id) ON DELETE CASCADE,
    ticket_number VARCHAR(100) NOT NULL UNIQUE,
    issued_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    ticket_status VARCHAR(50) NOT NULL DEFAULT 'active' -- 'active', 'validated', 'expired', 'lost'
);

-- =============================================================================
-- Performance Optimization & Indexes
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_parking_spots_level ON parking_spots(level_id);
CREATE INDEX IF NOT EXISTS idx_parking_spots_status ON parking_spots(operational_status);
CREATE INDEX IF NOT EXISTS idx_parking_sessions_vehicle ON parking_sessions(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_parking_sessions_spot ON parking_sessions(spot_id);
CREATE INDEX IF NOT EXISTS idx_parking_sessions_status ON parking_sessions(session_status);
CREATE INDEX IF NOT EXISTS idx_tickets_session ON tickets(session_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_access_vehicle ON vehicle_access(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_access_window ON vehicle_access(valid_from, valid_until);

-- =============================================================================
-- Sample Seed Data (Comic-Con Weekend Event Simulation)
-- =============================================================================

INSERT INTO parking_zones (zone_name, description) VALUES
('Hall A - Main Arena Ground', 'Primary open-air lot closest to exhibition gates'),
('Underground Garage Level B', 'Covered multi-level structure with EV chargers'),
('VIP Backstage Enclosure', 'Secured entry lot reserved for celebrity talent and press vans');

INSERT INTO parking_levels (zone_id, level_name) VALUES
(1, 'Ground Surface'),
(2, 'Basement Level B1'),
(2, 'Basement Level B2'),
(3, 'VIP Green Room Bay');

INSERT INTO parking_spot_categories (category_name, description) VALUES
('Standard Bay', 'Regular car parking stall (dimensions: 2.5m x 5.0m)'),
('EV Charging Spot', 'Equipped with 22kW AC Type-2 / CCS Fast charging'),
('Accessible / Handicap', 'Extra wide with direct ramp clearance to hall elevators'),
('Heavy Crew / Production Rig', 'Reinforced long bay for equipment trucks and broadcast trailers');

INSERT INTO vehicle_categories (category_name, description) VALUES
('Two-Wheeler / Motorcycle', 'Bikes and scooters'),
('Passenger Car / Sedan / Hatchback', 'Standard passenger vehicles'),
('SUV / Large Passenger', 'Full-size SUVs and minivans'),
('Electric Vehicle (EV)', 'Requires charging plug access'),
('Production Truck / Equipment Van', 'High-cube vans and articulated production trucks');

INSERT INTO access_categories (category_name, description) VALUES
('General Public', 'Standard ticket holders paying hourly event rates'),
('VIP Talent & Guests', 'Complimentary reserved bay for artists, cosplayers, and actors'),
('Production Crew & Logistics', 'Operations crew, light/sound engineers, security staff'),
('Exhibitor / Stall Owner', 'Merchandise and booth vendors requiring frequent loading access');

-- Spot Category - Vehicle Compatibility Rules
INSERT INTO spot_category_vehicle_compatibility (spot_category_id, vehicle_category_id) VALUES
(1, 2), -- Standard Bay accommodates Passenger Cars
(1, 3), -- Standard Bay accommodates SUVs
(2, 4), -- EV Spot accommodates Electric Vehicles
(3, 2), -- Accessible Bay accommodates Passenger Cars
(3, 3), -- Accessible Bay accommodates SUVs
(4, 5); -- Production Rig Bay accommodates Heavy Trucks

-- Spot Category - Access Compatibility Rules
INSERT INTO spot_category_access_compatibility (spot_category_id, access_category_id) VALUES
(1, 1), -- Standard Bay available to General Public
(1, 4), -- Standard Bay available to Exhibitors
(2, 1), -- EV Spot available to General Public
(2, 2), -- EV Spot available to VIP
(3, 1), -- Accessible Bay available to General Public
(4, 3); -- Production Rig Bay restricted to Production Crew
