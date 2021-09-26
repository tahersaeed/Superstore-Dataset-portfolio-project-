# Superstore-Dataset-portfolio-project

=======
Portfolio project to convert Company's Excel sheet into a Relational Database using MySQL 

---

**Table *of* Contents:**
1. Create an Entity-Relationship Model (ERM) diagram
2. Create tables using MYSQL to fetch the data from EXCEl into Database
3. Import Data From an EXCEL sheet
---

### Create an Entity-Relationship Model (ERM) diagram using draw.io

Apply Normalization to the Conceptual design.

Converting ERMs to physical DBs.

Identify entities what Database needs, its attributes and the relationship between all entities.

Entities have been created as shown in the graph:

 * Customer  
 * Customer segment 
 * Orders 
 * Oreders details  
 * City 
 * State  
 * Region  
 * Category  
 * Sub-category 
 * Products 
 * Manufacturer 

---

### Create tables using MYSQL to fetch the data from EXCEl into Database

 > As an example:

```mysql
 CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_segment_id` int(11) DEFAULT NULL,
  `nOrders` int(11) DEFAULT NULL,
  `is_top_customer` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```
---
### Import Data From an EXCEL sheet
Importing data from EXCEL sheet using PHPmyadmin and then start the process of cleaning data: 

* Standrdize Date Format 
* Remove Duplicates 
* Delete unused columns 
---













