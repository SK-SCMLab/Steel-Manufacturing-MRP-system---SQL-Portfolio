/* BILL OF MATERIALS (BOM) tables */

-- Products table
CREATE TABLE products(
	product_id INTEGER PRIMARY KEY AUTOINCREMENT,
	product_name TEXT NOT NULL,
	description TEXT
);
SELECT * FROM products;


-- Materials table
CREATE TABLE materials(
	material_id INTEGER PRIMARY KEY AUTOINCREMENT,
	material_name TEXT NOT NULL,
	unit TEXT NOT NULL
);
SELECT * FROM materials;

-- BOM table
CREATE TABLE bom(
	bom_id INTEGER PRIMARY KEY AUTOINCREMENT,
	product_id INTEGER NOT NULL,
	assembly_level INTEGER DEFAULT 1,
	FOREIGN KEY (product_id) REFERENCES products(product_id)
);
SELECT * FROM bom;

-- BOM items table
CREATE TABLE bom_items(
	bom_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
	bom_id INTEGER NOT NULL,
	material_id INTEGER NOT NULL,
	qty REAL NOT NULL,
	FOREIGN KEY (bom_id) REFERENCES bom(bom_id),
	FOREIGN KEY (material_id) REFERENCES materials(material_id)
);
SELECT * FROM bom_items;

-- DATA
INSERT INTO products(product_name, description) VALUES
('Steel Plate', 'Flat rolled steel plate for structural use'),
('Steel bar', 'Hot rolled steel bar'),
('Steel coil', 'Rolled steel in coil form');

INSERT INTO materials(material_name, unit) VALUES
('Iron ore', 'ton'),
('Coking coal', 'ton'),
('Limestone', 'ton'),
('Scrap steel', 'ton');

-- Each product has one BOM at assembly_level 1
INSERT INTO bom(product_id, assembly_level) VALUES
(1, 1), -- Steel plate
(2, 1), -- Steel bar
(3, 1); -- Steel coil

-- BOM items: what materials and how much are used per unit product
-- Example: For steel plate needs 1.5t Iron Ore, 0.8t Coking Coal, 0.1t Limestone

INSERT INTO bom_items(bom_id, material_id, qty) VALUES
(1, 1, 1.5), -- Steel plate, Iron Ore
(1, 2, 0.8), -- Steel Plate, Coking Coal
(1, 3, 0.1), -- Steel Plate, Limestone
(2, 1, 1.0), -- Steel bar, Iron Ore
(2, 2, 0.6), -- Steel bar, Coking Coal
(2, 4, 0.2), -- Steel Bar, Scrap Steel
(3, 1, 2.0), -- Steel Coil, Iron Ore
(3, 2, 1.0); -- Steel Coil, Coking Coal

/*SUPPLIER & PROCUREMENT TABLES*/

-- Suppliers
CREATE TABLE suppliers (
	supplier_id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	contact_info TEXT,
	rating INTEGER
);

SELECT * FROM suppliers;

-- Purchase orders
CREATE TABLE purchase_orders(
	po_id INTEGER PRIMARY KEY AUTOINCREMENT,
	supplier_id INTEGER NOT NULL,
	order_date DATE,
	status TEXT,
	FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id)
);
SELECT * FROM purchase_orders;

-- Purchase Order items
CREATE TABLE purchase_order_items(
	po_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
	po_id INTEGER NOT NULL,
	material_id INTEGER NOT NULL,
	qty REAL NOT NULL,
	price REAL,
	delivery_date DATE,
	FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id),
	FOREIGN KEY (material_id) REFERENCES materials (material_id)
);
SELECT * FROM purchase_order_items;

-- DATA
INSERT INTO suppliers (name, contact_info, rating) VALUES
('Iron Ore', 'iron@supplier.com', 5),
('Coal co', 'coal@supplier.com', 4),
('Limestone Ltd', 'lime@supplier.com', 4),
('Scrap masters', 'scrap@supplier.com', 5);

INSERT INTO purchase_orders(supplier_id, order_date, status) VALUES
(1, '2025-07-01', 'Ordered'),
(2, '2025-07-02', 'Delivered'),
(3, '2025-07-03', 'Ordered'),
(4, '2025-07-04', 'Pending');

INSERT INTO purchase_order_items(po_id, material_id, qty, price, delivery_date) VALUES
(1, 1, 120, 5000, '2025-07-10'), -- Iron Ore
(2, 2, 80, 3500, '2025-07-05'), -- Coking Coal
(3, 3, 50, 1000, '2025-07-09'), -- Limestone
(4, 4, 60, 5800, NULL); -- Scrap Steel

/*INVENTORY TABLES*/

-- Inventory Table
CREATE TABLE inventory(
	inventory_id INTEGER PRIMARY KEY AUTOINCREMENT,
	material_id INTEGER NOT NULL,
	location TEXT NOT NULL,
	qty_on_hand REAL NOT NULL,
	FOREIGN KEY (material_id) REFERENCES materials(material_id)
);
SELECT * FROM inventory;

-- Inventory Movements Table
CREATE TABLE inventory_movements(
	movement_id INTEGER PRIMARY KEY AUTOINCREMENT,
	inventory_id INTEGER NOT NULL,
	type TEXT NOT NULL, -- IN Or OUT
	qty REAL NOT NULL,
	ref_type TEXT, -- e.g. 'PO', 'Order'
	ref_id INTEGER,
	date DATE,
	FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);
SELECT * FROM inventory_movements;

-- DATA
INSERT INTO inventory(material_id, location, qty_on_hand) VALUES
(1, 'YARD A', 200),
(2, 'YARD B', 120),
(3, 'SILO C', 50),
(4, 'YARD D', 75);

INSERT INTO inventory_movements(inventory_id, type, qty, ref_type, ref_id, date) VALUES
(1, 'IN', 120, 'PO', 1, '2025-07-10'),
(2, 'IN', 80, 'PO', 2, '2025-07-05'),
(3, 'IN', 50, 'PO', 3, '2025-07-09'),
(4, 'IN', 60, 'PO', 4, '2025-07-11'),
(1, 'OUT', 30, 'ORDER', 1, '2025-07-12');

/*ORDERS & STATUSES TABLE*/

-- Customer Orders table
CREATE TABLE customer_orders(
	order_id INTEGER PRIMARY KEY AUTOINCREMENT,
	customer_name TEXT NOT NULL,
	order_date DATE,
	status TEXT
);
SELECT * FROM customer_orders;

-- Customer Order Items table
CREATE TABLE customer_order_items(
	order_item_id INTEGER PRIMARY KEY AUTOINCREMENT, 
	order_id INTEGER NOT NULL,
	product_id INTEGER NOT NULL,
	qty REAL NOT NULL,
	FOREIGN KEY (order_id) REFERENCES customer_orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id)
);
SELECT * FROM customer_order_items;

-- Order status log table
CREATE TABLE order_status_log(
	status_id INTEGER PRIMARY KEY AUTOINCREMENT,
	order_id INTEGER NOT NULL,
	timestamp DATE,
	status_note TEXT,
	FOREIGN KEY (order_id) REFERENCES customer_orders(order_id)
);
SELECT * FROM order_status_log;

-- DATA
INSERT INTO customer_orders(customer_name, order_date, status) VALUES
('Acme Construction', '2025-07-08', 'Processing'),
('Megabuild', '2025-07-10', 'Shipped');

INSERT INTO customer_order_items(order_id, product_id, qty) VALUES
(1, 1, 50), -- Steel Plate
(1, 2, 30), -- Steel Bar
(2, 3, 20); -- Steel Coil

INSERT INTO order_status_log(order_id, timestamp, status_note) VALUES
(1, '2025-07-08', 'Order Received'),
(1, '2025-07-09', 'Materials allocated'),
(2, '2025-07-11', 'Shipped');

/*USE CASE SCENARIOS*/

-- BOM Explosion: List all Materials for a Product & Quality
-- List all base materials and total qty needed for 'Steel Plate', qty = 20
SELECT 
	m.material_name,
	b.qty * 20 AS total_required,
	m.unit
FROM bom_items b
JOIN bom ON b.bom_id = bom.bom_id
JOIN materials m ON b.material_id = m.material_id
WHERE bom.product_id = 1;

WITH RECURSIVE bom_explosion(parent_bom_id, material_id, qty_per, total_qty) AS
(
	--Anchor: top-level BOM for a product
	SELECT b.bom_id, bomi.material_id, bomi.qty, bomi.qty * @order_qty
	FROM bom b
	JOIN bom_items bomi ON b.bom_id = bomi.bom_id
	WHERE b.product_id = @order_qty
	
	UNION ALL
	-- If a material itself is a product within a BOM, expand further
	SELECT b2.bom_id, bomi2.material_id, bomi2.qty, be.total_qty * bomi2.qty
	FROM bom_explosion be
	JOIN bom b2 ON be.material_id = b2.product_id
	JOIN bom_items bomi2 ON b2.bom_id = bomi2.bom_id
)
SELECT m.material_name, sum(total_qty) AS total_required, m.unit
FROM bom_explosion be
JOIN materials m ON be.material_id = m.material_id
GROUP BY m.material_id, m.unit;

-- CALCULATE MATERIAL SHORTAGES
SELECT
	m.material_name,
	i.qty_on_hand,
	CASE m.material_id
		WHEN 1 THEN 100 --- Iron Order Reorder point
		WHEN 2 THEN 60 --- Coking Coal
		WHEN 3 THEN 30 --- Limestone
		WHEN 4 THEN 50 --- Scrap Steel
	END AS reorder_point,
	(CASE
		WHEN i.qty_on_hand < (CASE m.material_id
			WHEN 1 THEN 100
			WHEN 2 THEN 60
			WHEN 3 THEN 30
			WHEN 4 THEN 50
	END)
	THEN 'Reorder needed'
	ELSE 'OK'
	END) AS status
FROM inventory i
JOIN materials m ON i.material_id = m.material_id; 

-- List only items needing reorder
SELECT m.material_id, m.material_name, i.qty_on_hand
FROM inventory i
JOIN materials m ON i.material_id = m.material_id
WHERE i.qty_on_hand <
	CASE m.material_id
	WHEN 1 THEN 100
	WHEN 2 THEN 60
	WHEN 3 THEN 30
	WHEN 4 THEN 50
END;

-- SUPPLIER PERFORMANCE DASHBOARD
SELECT 
	s.name AS supplier,
	s.rating,
	COUNT(po.po_id) AS total_pos,
	AVG(
		CASE
			WHEN poi.delivery_date IS NOT NULL
			THEN julianday(poi.delivery_date) - julianday(po.order_date)
			ELSE NULL
		END
		) AS avg_delivery_days,
		SUM(CASE WHEN po.status = 'Delivered' THEN 1 ELSE 0 END) AS
	total_pos_delivered
	FROM suppliers s
	LEFT JOIN purchase_orders po ON s.supplier_id = po.supplier_id
	LEFT JOIN purchase_order_items poi ON po.po_id = poi.po_id
	GROUP BY s.supplier_id, s.name, s.rating;

-- ORDER FULFILLMENT PIPELINE
SELECT
	co.order_id,
	co.customer_name,
	co.order_date,
	co.status AS current_status,
	GROUP_CONCAT(p.product_name || 'x' || coi.qty) AS items_ordered,
	osl.timestamp AS last_status_update,
	osl.status_note AS last_status,
	(
		SELECT osl2.timestamp
		FROM order_status_log osl2
		WHERE osl2.order_id = co.order_id AND osl2.status_note LIKE '%Shipped%'
		ORDER BY osl2.timestamp DESC
		LIMIT 1
	) AS shipped_date
	FROM customer_orders co
	LEFT JOIN customer_order_items coi ON co.order_id = coi.order_id
	LEFT JOIN products p ON coi.product_id = p.product_id
	LEFT JOIN (
		SELECT olog.order_id, MAX(olog.timestamp) AS timestamp, olog.status_note
		FROM order_status_log olog
		GROUP BY olog.order_id
	) osl ON osl.order_id = co.order_id
	GROUP BY co.order_id;