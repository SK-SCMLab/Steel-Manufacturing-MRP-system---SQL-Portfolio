
# 🪭 Steel-Manufacturing-MRP-system---SQL-Portfolio
This SQL repository is structured to guide collaborators through the design, schema, features and usage of the MRP solution

---

## 🎃 Overview
This project demonstrates a comprehensive SQL-driven Material Requirements Planning (MRP) system tailored for steelmaking plants. It covers procurement, usage and inventory management, and features dedicated modules for: 
- Bill of Materials (BOM)
- Supplier tracking
- Order status

---

## 🫥 Business Context
Steel plants require tight coordination between raw materials procurement, process usage, and final inventory to maximize efficiency and profitability. Effective MRP ensures optimal inventory, timely procurement, high-quality supplier relationships, and trasparents production status

---

## 🚣🏼‍♂️ Project Features
### BOM Management
Define multi-level assemblies for steel products including required raw materials and quantities

### Procurement Module
Monitor purchase orders, supplier details, statuses, expected deliveries, and historical performances

### Inventory management
Track raw material, work-in-progress, and finished goods inventory in real-time

### Order Tracking
Link customer orders to material requirements, stock availability and fulfillment pipeline

---

## 🏊🏼 Database schema design
### 1. Bill of Materials
|*Table*|*Key Fields*|
|-------|------------|
|products|product_id(PK), product_name, description|
|bom|bom_id(PK), product_id(FK), assembly_level|
|bom_items|bom_item_id(PK), bom_id(FK), material_id(FK), qty|
|materials|material_id(PK), material_name, unit|

### 2. Supplier & Procurement
|*Table*|*Key fields*|
|-------|------------|
|suppliers|supplier_id(PK), name, contact_info, rating|
|purchase_orders|po_id(PK), supplier_id(FK), order_date, status|
|purchase_order_items|po_item_id(PK), po_id(FK), material_id(FK), qty, price, delivery_date|

### 3. Inventory
|*Table*|*Key fields*|
|-------|------------|
|inventory|inventory_id(PK), material_id(FK), location, qty_on_hand|
|inventory_movements|movement_id(PK), inventory_id(FK), type(IN/OUT), qty, ref_type, ref_id, date|

### 4. Orders & Status
|*Table*|*Key fields*|
|-------|------------|
|customer_orders|order_id(PK), customer_name, order_date, status|
|customer_order_items|order_item_id(PK), order_id(FK), product_id(FK), qty|
|order_status_log|status_id(PK), order_id(FK), timestamp, status_note|

---

## 🚵🏼‍♀️ Case study
### Assumptions
- For BOM explosion, only one level BOMs are used (your schema does not model recursive, multi-level child BOMs, but the query is written in a way that could expand for nested BOMs if added)
- For shortages, a simple reorder point is used (assumed or hardcoded per material)
- Delivery dates and order stages are based on your provided data

### 1. Generate BOM explosion
Recursively list all materials needed for a given product and quantity

### 2. Calculate material shortages
Cross compare BOM(material needs) vs. inventory; trigger purchase orders when below reorder point

### 3. Supplier Performance Dashboard
Average daily time, rating, and PO fulfillment status

### 4. Order Fulfillment pipeline
Show each order's production/completion stage, material readiness, and estimated ship date

---

## 🤹🏼 SQL Queries
- SELECT()
- FROM()
- WHERE()
- JOIN()
- LEFT JOIN()
- AS()
- WITH RECURSIVE()
- NOT NULL()
- PRIMARY KEY()
- FOREIGN KEY()
- REFERENCES()
- CASE()
- END()
- DATE()
- TEXT()
- INSERT INTO()
- VALUES()
- GROUP BY()
- ON()
- DESC()
- AUTOINCREMENT()
- CREATE()

---

## 🧖🏼 Requirements
- DBeaver application
- Fundamentals of Database Management Systems

---

*"The inventory goes down the elevator every night" - Fairfax cone*
