# 🏥 Clinic Appointment & Diagnostics Platform — Database Design

A relational database design for outpatient medical clinics, multi-specialty healthcare centers, and diagnostic pathology labs.

---

## 📌 Problem Overview

Outpatient healthcare management requires bridging the gap between clinical scheduling and laboratory diagnostics. A clinic platform must handle:

1. **Doctor Discovery & Scheduling**: Managing doctor profiles under medical specialties and coordinating time-slot appointments with patients.
2. **Clinical Consultation Records**: Storing detailed clinical findings (symptoms, clinical diagnosis, prescriptions, and physician notes) linked to a specific visit.
3. **Integrated Diagnostic Lab Workflow**: Enabling doctors to order diagnostic lab tests directly during consultations and tracking their progression from sample collection to verified results.
4. **Diagnostic Reports**: Archiving final lab findings, pathology observations, and verification statuses.
5. **Billing & Payments**: Recording fee transactions for appointments and healthcare services.

---

## 🗺️ Entity Relationship (ER) Diagram

![Clinic Appointment and Diagnostics Platform](./Clinic%20Appointment%20and%20Diagnostics%20Platform.png)

---

## 🏛️ Entities & Structure

### 1. Master Medical Profiles
* **`specialties`**: Medical departments (e.g., Cardiology, Dermatology, Pediatrics, General Medicine).
* **`doctors`**: Healthcare practitioners (`doctor_name`, `phone`, `email`) assigned to a specific specialty (`specialty_id`).
* **`patients`**: Patient demographics and contact profiles (`patient_name`, `date_of_birth`, `gender`, `phone`, `email`, `address`).

### 2. Appointments & Clinical Consultations
* **`appointments`**: Scheduled consultation slots between a patient and a doctor (`appointment_date`, `appointment_time`, `appointment_status`).
* **`consultations`**: Medical records generated during the visit (`consultation_date`, `symptoms`, `diagnosis`, `prescription`, `notes`), linked 1-to-1 with the completed appointment.

### 3. Diagnostics Lab Workflow
* **`diagnostic_tests`**: Master catalog of available lab investigations (`test_name`, `description`, `test_price`) such as CBC, Lipid Profile, Ultrasound, or X-Ray.
* **`prescribed_tests`**: Individual tests ordered by the doctor during a consultation (`prescribed_date`, `test_status`: *prescribed*, *sample_collected*, *in_progress*, *completed*).
* **`reports`**: Clinical laboratory result documentation (`report_date`, `result_summary`, `report_status`: *preliminary*, *verified*, *final*).

### 4. Billing & Transactions
* **`payments`**: Financial payment log (`amount`, `payment_method`, `payment_status`, `payment_date`) tied to the appointment.

---

## 💡 Key Design Decisions

* **Separation of Scheduling and Medical Notes**: `appointments` manages calendar availability and booking statuses, while `consultations` stores confidential clinical diagnosis and prescriptions. This keeps scheduling queries fast and separates administrative workflows from sensitive health records.
* **Closed-Loop Diagnostic Tracking**: By connecting `consultations` ➡️ `prescribed_tests` ➡️ `reports`, doctors can trace every lab test back to the exact consultation where it was ordered, and review the resulting report directly from the patient's case history.
* **Independent Test Catalog**: `diagnostic_tests` acts as a centralized pricing and service catalog, allowing the clinic to update test rates or add new medical investigations without affecting past patient records.
