CREATE TABLE car_makers
(
make_id int NOT NULL,
make_description varchar(200),
PRIMARY KEY (make_id)
);

CREATE TABLE cars
(
car_id int NOT NULL,
make_id int,
car_model varchar(200),
year_produced varchar(20),
color varchar(20),
date_acquired date,
requires_servicing varchar(20),
for_servicing varchar(20),
car_cost int,
price int,
is_sold varchar(20),
sell_date date,
PRIMARY KEY (car_id)
);

ALTER TABLE cars
ADD FOREIGN KEY (make_id) REFERENCES car_makers(make_id);

CREATE TABLE acquisition_type
(
type_id int NOT NULL,
type_description varchar(200),
PRIMARY KEY (type_id)
);

CREATE TABLE dealers
(
dealer_id int NOT NULL,
dealer_description varchar(20),
contact int,
PRIMARY KEY (dealer_id)
);

CREATE TABLE acquisition_invoices
(
acq_invoice_id int NOT NULL,
car_id int,
type_id int,
dealer_id int,
date_acquired date,
car_cost int,
is_trade varchar(20),
Is_approved varchar(20),
PRIMARY KEY (acq_invoice_id)
);
ALTER TABLE acquisition_invoices
ADD FOREIGN KEY (car_id) REFERENCES cars(car_id);
ALTER TABLE acquisition_invoices
ADD FOREIGN KEY (type_id) REFERENCES acquisition_type(type_id);
ALTER TABLE acquisition_invoices
ADD FOREIGN KEY (dealer_id) REFERENCES dealers(dealer_id);

CREATE TABLE job_description
(
job_id int NOT NULL,
job_description varchar(20),
starting_salary int,
PRIMARY KEY (job_id)
);

CREATE TABLE staff
(
staff_id int NOT NULL,
f_name varchar(20),
l_name varchar(20),
job_id int,
phone_number int,
email varchar(200),
address varchar(200),
start_date date,
is_current varchar(20),
PRIMARY KEY (staff_id)
);

ALTER TABLE staff
ADD FOREIGN KEY (job_id) REFERENCES job_description(job_id);


CREATE TABLE suppliers
(
supplier_id int NOT NULL,
supplier_description varchar(200),
contact int,
PRIMARY KEY (supplier_id)
);

CREATE TABLE inventory
(
part_id int NOT NULL,
part_description varchar(200),
quant_available int,
supplier_id int,
PRIMARY KEY (part_id)
);

ALTER TABLE inventory
ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);


CREATE TABLE PO_out
(
PO_id_out int NOT NULL,
purchase_date date,
supplier_id int,
preparer_id int,
part_id int,
quantity int,
part_price int,
purchase_total int,
est_delivery date,
PRIMARY KEY (PO_id_out)
);

ALTER TABLE PO_out
ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);
ALTER TABLE PO_out
ADD FOREIGN KEY (preparer_id) REFERENCES staff(staff_id);
ALTER TABLE PO_out
ADD FOREIGN KEY (part_id)  REFERENCES inventory(part_id);


CREATE TABLE PO_inventory_map
(
part_id int NOT NULL,
PO_id_out int NOT NULL,
PRIMARY KEY (part_id, PO_id_out)
);

ALTER TABLE PO_inventory_map
ADD FOREIGN KEY (part_id) REFERENCES inventory(part_id);
ALTER TABLE PO_inventory_map
ADD FOREIGN KEY (PO_id_out) REFERENCES PO_out(PO_id_out);


CREATE TABLE accounts_payable
(
AP_id int NOT NULL,
PO_id_out int,
acq_invoice_id int,
dealer_id int,
supplier_id int,
for_supplies varchar(20),
amount int,
pay_by_date date,
is_paid varchar(20),
PRIMARY KEY (AP_id)
);

ALTER TABLE accounts_payable
ADD FOREIGN KEY (PO_id_out) REFERENCES PO_out(PO_id_out);
ALTER TABLE accounts_payable
ADD FOREIGN KEY (acq_invoice_id) REFERENCES acquisition_invoices(acq_invoice_id);
ALTER TABLE accounts_payable
ADD FOREIGN KEY (dealer_id) REFERENCES dealers(dealer_id);
ALTER TABLE accounts_payable
ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);


CREATE TABLE customers
(
customer_id int NOT NULL,
f_name varchar(20),
l_name varchar(20),
phone_number int,
email varchar(200),
address varchar(200),
num_transactions int,
PRIMARY KEY (customer_id)
);


CREATE TABLE customer_preferences
(
preference_id int NOT NULL,
pref_description varchar(30),
PRIMARY KEY (preference_id)
);

ALTER TABLE customer_preferences
ADD FOREIGN KEY (preference_id) REFERENCES car_makers(make_id);

CREATE TABLE customer_preference_map
(
preference_id int NOT NULL,
customer_id int NOT NULL,
PRIMARY KEY (preference_id, customer_id)
);
ALTER TABLE customer_preference_map
ADD FOREIGN KEY (preference_id) REFERENCES customer_preferences(preference_id);
ALTER TABLE customer_preference_map
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);


CREATE TABLE PO_in
(
PO_id_in int NOT NULL,
customer_id int,
purchase_date date,
car_id int,
preparer_id int,
est_delivery date,
is_approved varchar(20),
PRIMARY KEY (PO_id_in)
);

ALTER TABLE PO_in
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE PO_in
ADD FOREIGN KEY (car_id) REFERENCES cars(car_id);
ALTER TABLE PO_in
ADD FOREIGN KEY (preparer_id) REFERENCES staff(staff_id);

CREATE TABLE inventory_sales_tracker
(
car_id int NOT NULL,
PO_id_in int NOT NULL,
PRIMARY KEY (car_id, PO_id_in)
);

ALTER TABLE inventory_sales_tracker
ADD FOREIGN KEY (car_id) REFERENCES cars(car_id);
ALTER TABLE inventory_sales_tracker
ADD FOREIGN KEY (PO_id_in) REFERENCES PO_in(PO_id_in);


CREATE TABLE sales_invoices
(
invoice_id int NOT NULL,
customer_id int,
PO_id_in int,
sale_date date,
price int,
PRIMARY KEY (invoice_id)
);

ALTER TABLE sales_invoices
ADD FOREIGN KEY (PO_id_in) REFERENCES PO_in(PO_id_in);
ALTER TABLE sales_invoices
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

CREATE TABLE accounts_receivable
(
invoice_id int NOT NULL,
customer_id int NOT NULL,
amount int,
pay_by_date date,
is_paid varchar(20),
PRIMARY KEY (invoice_id,customer_id)
);

ALTER TABLE accounts_receivable
ADD FOREIGN KEY (invoice_id) REFERENCES sales_invoices(invoice_id);
ALTER TABLE accounts_receivable
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

CREATE TABLE services
(
service_id int NOT NULL,
service_description varchar(200),
is_add_on varchar(20),
service_cost int,
service_price int,
PRIMARY KEY (service_id)
);

CREATE TABLE service_jobs
(
service_job_id int NOT NULL,
staff_id int,
car_id int,
start_date date,
end_date date,
is_current varchar(20),
PRIMARY KEY (service_job_id)
);

ALTER TABLE service_jobs
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id);
ALTER TABLE service_jobs
ADD FOREIGN KEY (car_id) REFERENCES cars(car_id);

CREATE TABLE service_invoices
(
service_invoice_id int NOT NULL,
service_id int,
customer_id int,
service_job_id int,
PRIMARY KEY (service_invoice_id)
);

ALTER TABLE service_invoices
ADD FOREIGN KEY (service_job_id) REFERENCES service_jobs(service_job_id);
ALTER TABLE service_invoices
ADD FOREIGN KEY (service_id) REFERENCES services(service_id);
ALTER TABLE service_invoices
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

CREATE TABLE inventory_service_map
(
part_id int NOT NULL,
service_job_id int NOT NULL,
quantity_used int,
PRIMARY KEY (service_job_id, part_id)
);

ALTER TABLE inventory_service_map
ADD FOREIGN KEY (service_job_id) REFERENCES  service_jobs(service_job_id);
ALTER TABLE inventory_service_map
ADD FOREIGN KEY (part_id) REFERENCES inventory(part_id);

CREATE TABLE customer_service_map
(
service_job_id int NOT NULL,
customer_id int NOT NULL,
PRIMARY KEY (service_job_id, customer_id)
);

ALTER TABLE customer_service_map
ADD FOREIGN KEY (service_job_id) REFERENCES service_jobs(service_job_id);
ALTER TABLE customer_service_map
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

CREATE TABLE payroll
(
payroll_id int NOT NULL,
staff_id int,
salary int,
salary_payment int,
period_start_date date,
period_end_date date,
PRIMARY KEY (payroll_id)
);

CREATE TABLE commission_tracker
(
staff_id int NOT NULL,
invoice_id int NOT NULL,
profit int,
commission int,
payroll_id int,
PRIMARY KEY (staff_id,invoice_id)
);
ALTER TABLE commission_tracker
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id);
ALTER TABLE commission_tracker
ADD FOREIGN KEY (invoice_id) REFERENCES sales_invoices(invoice_id);
ALTER TABLE commission_tracker
ADD FOREIGN KEY (payroll_id) REFERENCES payroll(payroll_id);

CREATE TABLE payroll_map
(
payroll_id int NOT NULL,
staff_id int NOT NULL,
PRIMARY KEY (payroll_id, staff_id)
);

ALTER TABLE payroll_map
ADD FOREIGN KEY (payroll_id) REFERENCES payroll(payroll_id);
ALTER TABLE payroll_map
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id);

/*CAR MAKERS*/

INSERT INTO car_makers (make_id, make_description) VALUES ('1','Chevrolet');
INSERT INTO car_makers (make_id, make_description) VALUES ('2','Dodge');
INSERT INTO car_makers (make_id, make_description) VALUES ('3','Ferrari');
INSERT INTO car_makers (make_id, make_description) VALUES ('4','Ford');
INSERT INTO car_makers (make_id, make_description) VALUES ('5','Corvette');
INSERT INTO car_makers (make_id, make_description) VALUES ('6','Mercedes');
INSERT INTO car_makers (make_id, make_description) VALUES ('7','Lexus');
INSERT INTO car_makers (make_id, make_description) VALUES ('8','BMW');
INSERT INTO car_makers (make_id, make_description) VALUES ('9','Porche');
INSERT INTO car_makers (make_id, make_description) VALUES ('10','Fiat');
INSERT INTO car_makers (make_id, make_description) VALUES ('11','Jaguar');
INSERT INTO car_makers (make_id, make_description) VALUES ('12','Lancias');
INSERT INTO car_makers (make_id, make_description) VALUES ('13','Saabs ');
INSERT INTO car_makers (make_id, make_description) VALUES ('0','(null)');

/*CARS*/

INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('1','1','Pickup','1948','red',to_date('2015/03/12','YYYY-MM-DD'),'no','no','9532','9982','yes',to_date('2015/05/22','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('2','2','Challenger','1974','yellow',to_date('2015/03/20','YYYY-MM-DD'),'no','no','10000','10450','yes',to_date('2015/06/30','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('3','3','250 GT California','1957','red',to_date('2015/04/21','YYYY-MM-DD'),'no','no','30181','30631','yes',to_date('2015/05/09','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('4','4','Ford','1969','teal',to_date('2015/04/22','YYYY-MM-DD'),'no','no','26028','26478','yes',to_date('2015/06/02','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('5','5','V8','1955','red',to_date('2015/05/05','YYYY-MM-DD'),'no','no','19347','19797','yes',to_date('2015/06/10','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('6','2','Royal','1959','black',to_date('2015/05/15','YYYY-MM-DD'),'no','no','82481','82931','yes',to_date('2015/07/25','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('7','1','Corvette','1953','blue',to_date('2015/05/30','YYYY-MM-DD'),'no','no','17000','17450','yes',to_date('2015/10/10','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('8','7','LFA','2011','black',to_date('2015/06/07','YYYY-MM-DD'),'no','no','12903','13353','yes',to_date('2016/01/17','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('9','4','Torino','1976','green',to_date('2015/07/08','YYYY-MM-DD'),'no','no','24000','24450','yes',to_date('2015/11/18','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('10','8','328 Roadster','1940','maroon',to_date('2015/08/23','YYYY-MM-DD'),'no','no','27000','27450','yes',to_date('2016/01/03','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('11','5','Stingray','1963','yellow',to_date('2015/09/04','YYYY-MM-DD'),'no','no','28000','28450','yes',to_date('2016/04/14','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('12','8','507 Roadster','1957','red',to_date('2015/10/22','YYYY-MM-DD'),'no','no','27000','27450','yes',to_date('2016/07/02','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('13','3','450 Italia','2011','green',to_date('2015/11/23','YYYY-MM-DD'),'no','no','32000','32450','yes',to_date('2016/03/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('14','7','F Sport','2011','silver',to_date('2015/12/23','YYYY-MM-DD'),'no','no','22000','22450','yes',to_date('2016/04/03','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('15','5','Stringray LT/1','1970','black',to_date('2016/01/25','YYYY-MM-DD'),'no','no','26038','26488','yes',to_date('2016/05/05','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('16','2','Viper','1993','black',to_date('2016/03/12','YYYY-MM-DD'),'no','no','14000','14450','yes',to_date('2016/04/22','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('17','3','Enzo','2002','silver',to_date('2016/04/23','YYYY-MM-DD'),'no','no','26000','26450','yes',to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('18','1','Camaro','1969','yellow',to_date('2016/05/04','YYYY-MM-DD'),'no','no','19000','19450','yes',to_date('2016/09/14','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('19','5','Z06','2002','black',to_date('2016/06/20','YYYY-MM-DD'),'yes','no','23000','23450','yes',to_date('2016/07/30','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('20','4','Pinto','1972','red',to_date('2016/07/11','YYYY-MM-DD'),'no','no','7000','7450','yes',to_date('2016/08/21','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('21','6','300SL Gullwing','1955','black',to_date('2016/08/14','YYYY-MM-DD'),'no','no','22000','22450','yes',to_date('2016/12/24','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('22','1','Corvette','1953','blue',to_date('2016/08/29','YYYY-MM-DD'),'no','no','29000','29450','yes',to_date('2017/03/09','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('23','1','El Camino SS','1970','green',to_date('2016/09/15','YYYY-MM-DD'),'no','no','31000','31450','yes',to_date('2017/03/25','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('24','6','540K','1940','black',to_date('2016/10/13','YYYY-MM-DD'),'no','no','24000','24450','yes',to_date('2016/12/23','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('25','5','V8','1956','teal',to_date('2016/11/03','YYYY-MM-DD'),'no','no','24000','24450','yes',to_date('2017/03/13','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('26','2','Viper','1993','green',to_date('2016/11/29','YYYY-MM-DD'),'no','no','17000','17450','yes',to_date('2017/07/09','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('27','8','Turbo','1975','silver',to_date('2016/12/29','YYYY-MM-DD'),'no','no','24000','24450','yes',to_date('2017/04/09','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('28','1','El Camino SS','1970','red',to_date('2017/01/28','YYYY-MM-DD'),'no','no','29000','29450','yes',to_date('2017/08/08','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('29','6','300SEL 6.3','1970','green',to_date('2017/02/09','YYYY-MM-DD'),'no','no','29000','29450','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('30','4','Torino','1974','yellow',to_date('2017/03/17','YYYY-MM-DD'),'yes','no','27000','27450','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('31','1','El Camino SS','1970','black',to_date('2017/07/23','YYYY-MM-DD'),'no','no','32000','32450','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('32','5','Stringray LT/1','1972','black',to_date('2018/04/20','YYYY-MM-DD'),'no','no','32500','32950','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('33','6','540K','1940','silver',to_date('2018/08/10','YYYY-MM-DD'),'yes','no','29428','29878','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('34','1','Camero','2010','red',to_date('2019/05/23','YYYY-MM-DD'),'no','no','37000','37450','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('35','4','GT40','1969','red',to_date('2019/12/24','YYYY-MM-DD'),'no','no','29471','29921','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('36','9','356','1952','red',to_date('2019/12/20','YYYY-MM-DD'),'yes','no','50700','51150','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('37','10','128','1970','blue',to_date('2019/12/25','YYYY-MM-DD'),'no','no','41000','41450','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('38','11','E/Type','1961','silver',to_date('2019/12/25','YYYY-MM-DD'),'no','no','46000','46450','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('39','4','Mustang','1987','blue',to_date('2019/12/30','YYYY-MM-DD'),'no','no','56000','56450','no',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('40','1','Pickup','1948','red',to_date('2015/07/23','YYYY-MM-DD'),'yes','yes','20','60','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('41','2','Challenger','1974','yellow',to_date('2015/11/11','YYYY-MM-DD'),'yes','yes','50','200','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('42','3','250 GT California','1957','red',to_date('2015/12/05','YYYY-MM-DD'),'yes','yes','200','455','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('43','4','Ford','1969','teal',to_date('2016/02/22','YYYY-MM-DD'),'yes','yes','5','30','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('44','5','V8','1955','red',to_date('2016/05/09','YYYY-MM-DD'),'yes','yes','50','200','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('45','2','Royal','1959','black',to_date('2016/08/03','YYYY-MM-DD'),'yes','yes','5','30','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('46','1','Corvette','1953','blue',to_date('2016/10/20','YYYY-MM-DD'),'yes','yes','25','65','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('47','7','LFA','2011','black',to_date('2017/01/24','YYYY-MM-DD'),'yes','yes','20','60','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('48','4','Torino','1976','green',to_date('2017/04/20','YYYY-MM-DD'),'yes','yes','50','200','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('49','8','328 Roadster','1940','maroon',to_date('2018/03/13','YYYY-MM-DD'),'yes','yes','200','455','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('50','5','Stingray','1963','yellow',to_date('2018/05/15','YYYY-MM-DD'),'yes','yes','50','200','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('51','8','507 Roadster','1957','red',to_date('2019/06/23','YYYY-MM-DD'),'yes','yes','200','455','(null)',to_date('1900/01/01','YYYY-MM-DD'));
INSERT INTO cars (car_id, make_id, car_model, year_produced, color, date_acquired, requires_servicing, for_servicing, car_cost, price, is_sold, sell_date) VALUES ('0','0','(null)','0','(null)',to_date('1900/01/01','YYYY-MM-DD'),'(null)','(null)','0','0','(null)',to_date('1900/01/01','YYYY-MM-DD'));

/*ACQUISITION TYPE*/

INSERT INTO acquisition_type (type_id, type_description) VALUES ('1','Auction');
INSERT INTO acquisition_type (type_id, type_description) VALUES ('2','Individual Transaction');
INSERT INTO acquisition_type (type_id, type_description) VALUES ('3','Trade-In');
INSERT INTO acquisition_type (type_id, type_description) VALUES ('0','(null)');

/*DEALERS*/

INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('1','LA Auto Auction','4057283012');
INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('2','Jeff Briggs','6741029384');
INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('3','Greg Barsegian','7771029342');
INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('4','David Kuckos','8889102847');
INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('5','SF Auto Auction','4159208372');
INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('6','Rick Tallen','9990192837');
INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('7','Mitchell Grant','3339029837');
INSERT INTO dealers (dealer_id, dealer_description, contact) VALUES ('0','(null)','0');

/*ACQUISITION INVOICES*/

INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('1','1','1','1',to_date('2015/03/12','YYYY-MM-DD'),'9532','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('2','2','2','2',to_date('2015/03/20','YYYY-MM-DD'),'10000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('3','3','3','3',to_date('2015/04/21','YYYY-MM-DD'),'30181','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('4','4','2','4',to_date('2015/04/22','YYYY-MM-DD'),'26028','yes','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('5','5','1','5',to_date('2015/05/05','YYYY-MM-DD'),'19347','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('6','6','3','6',to_date('2015/05/15','YYYY-MM-DD'),'82481','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('7','7','1','1',to_date('2015/05/30','YYYY-MM-DD'),'17000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('8','8','3','7',to_date('2015/06/07','YYYY-MM-DD'),'12903','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('9','9','3','6',to_date('2015/07/08','YYYY-MM-DD'),'24000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('10','10','2','4',to_date('2015/08/23','YYYY-MM-DD'),'27000','yes','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('11','11','1','5',to_date('2015/09/04','YYYY-MM-DD'),'28000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('12','12','2','3',to_date('2015/10/22','YYYY-MM-DD'),'27000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('13','13','1','1',to_date('2015/11/23','YYYY-MM-DD'),'32000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('14','14','2','2',to_date('2015/12/23','YYYY-MM-DD'),'22000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('15','15','1','5',to_date('2016/01/25','YYYY-MM-DD'),'26038','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('16','16','2','3',to_date('2016/03/12','YYYY-MM-DD'),'14000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('17','17','3','4',to_date('2016/04/23','YYYY-MM-DD'),'26000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('18','18','3','4',to_date('2016/05/04','YYYY-MM-DD'),'19000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('19','19','1','1',to_date('2016/06/20','YYYY-MM-DD'),'23000','yes','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('20','20','2','6',to_date('2016/07/11','YYYY-MM-DD'),'7000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('21','21','1','5',to_date('2016/08/14','YYYY-MM-DD'),'22000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('22','22','1','1',to_date('2016/08/29','YYYY-MM-DD'),'29000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('23','23','2','7',to_date('2016/09/15','YYYY-MM-DD'),'31000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('24','24','3','6',to_date('2016/10/13','YYYY-MM-DD'),'24000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('25','25','1','5',to_date('2016/11/03','YYYY-MM-DD'),'24000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('26','26','3','4',to_date('2016/11/29','YYYY-MM-DD'),'17000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('27','27','3','4',to_date('2016/12/29','YYYY-MM-DD'),'24000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('28','28','1','1',to_date('2017/01/28','YYYY-MM-DD'),'29000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('29','29','3','7',to_date('2017/02/09','YYYY-MM-DD'),'29000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('30','30','1','5',to_date('2017/03/17','YYYY-MM-DD'),'27000','yes','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('31','31','2','4',to_date('2017/07/23','YYYY-MM-DD'),'32000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('32','32','3','2',to_date('2018/04/20','YYYY-MM-DD'),'32500','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('33','33','3','3',to_date('2018/08/10','YYYY-MM-DD'),'29428','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('34','34','1','1',to_date('2019/05/23','YYYY-MM-DD'),'37000','yes','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('35','35','2','4',to_date('2019/12/24','YYYY-MM-DD'),'29471','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('36','36','1','1',to_date('2019/12/20','YYYY-MM-DD'),'50700','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('37','37','1','5',to_date('2019/12/25','YYYY-MM-DD'),'41000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('38','38','1','1',to_date('2019/12/25','YYYY-MM-DD'),'46000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('39','39','1','5',to_date('2019/12/30','YYYY-MM-DD'),'56000','no','yes');
INSERT INTO acquisition_invoices (acq_invoice_id, car_id, type_id, dealer_id, date_acquired, car_cost, is_trade, is_approved) VALUES ('0','0','0','0',to_date('1900/01/01','YYYY-MM-DD'),'0','(null)','(null)');

/*JOB DESCRIPTION*/

INSERT INTO job_description (job_id, job_description, starting_salary) VALUES ('1','staff','45000');
INSERT INTO job_description (job_id, job_description, starting_salary) VALUES ('2','service','50000');
INSERT INTO job_description (job_id, job_description, starting_salary) VALUES ('3','manager','60000');
INSERT INTO job_description (job_id, job_description, starting_salary) VALUES ('4','owner','80000');
INSERT INTO job_description (job_id, job_description, starting_salary) VALUES ('0','(null)','0');

/*STAFF*/

INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('1','Hannah','Murphy','1','8057272645','hmurphy@gmail.com','9556 Loomis',to_date('2015/03/01','YYYY-MM-DD'),'yes');
INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('2','Jillian','Plushkel','1','8058261438','jplushkelgmail.com','2022 Olive BLVD',to_date('2015/03/01','YYYY-MM-DD'),'yes');
INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('3','Katie','Lyn','1','8058163548','kltn@gmail.com','3593 Johnson',to_date('2015/04/01','YYYY-MM-DD'),'yes');
INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('4','Tom','Hanks','2','8057264329','thanks@yahoo.com','9369 Broad Street',to_date('2016/01/01','YYYY-MM-DD'),'yes');
INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('5','Eric','Greggs','2','8057252434','ericcgreg@yahoo.com','6839 Loomis',to_date('2015/04/01','YYYY-MM-DD'),'yes');
INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('6','Enrico','Luisa','3','8056251322','georgebanos@gmail.com','4313 Slack Street',to_date('2016/05/01','YYYY-MM-DD'),'yes');
INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('7','Larry','Hernandez','4','8059292821','larryhernandez@gmail.com','2337 Broad Street',to_date('2015/01/01','YYYY-MM-DD'),'yes');
INSERT INTO staff (staff_id, f_name, l_name, job_id, phone_number, email, address, start_date, is_current) VALUES ('0','(null)','(null)','0','0','(null)','(null)',to_date('1900/01/01','YYYY-MM-DD'),'(null)');

/*SUPPLIERS*/

INSERT INTO suppliers (supplier_id, supplier_description, contact) VALUES ('1','Auto Parts Warehouse','8057465230');
INSERT INTO suppliers (supplier_id, supplier_description, contact) VALUES ('2','Wholesale Tires','8057162534');
INSERT INTO suppliers (supplier_id, supplier_description, contact) VALUES ('3','Auto Cleaning Warehouse','8058920384');
INSERT INTO suppliers (supplier_id, supplier_description, contact) VALUES ('0','(null)','0');

/*INVENTORY*/

INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('1','car oil','30','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('2','windshield fluid','24','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('3','windshield wipers','39','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('4','driving lights','12','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('5','tail lights','14','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('6','turning lights','16','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('7','shocks','19','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('8','bearings','32','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('9','sunroof','4','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('10','bumper','6','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('11','grill','7','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('12','hitch','3','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('13','exterior cleaner','12','3');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('14','interior cleaner','10','3');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('15','brushes','4','3');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('16','tires','40','2');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('17','AWD tires','16','2');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('18','other/custom','0','1');
INSERT INTO inventory (part_id, part_description, quant_available, supplier_id) VALUES ('0','(null)','0','0');

/* PO OUT*/

INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('1',to_date('2015/04/10','YYYY-MM-DD'),'1','5','1','15','5','75',to_date('2015/04/12','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('2',to_date('2015/04/15','YYYY-MM-DD'),'1','5','10','6','55','330',to_date('2015/04/20','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('3',to_date('2015/04/15','YYYY-MM-DD'),'1','5','7','10','35','350',to_date('2015/04/21','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('6',to_date('2015/05/07','YYYY-MM-DD'),'3','5','13','10','5','50',to_date('2015/05/15','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('7',to_date('2015/05/25','YYYY-MM-DD'),'1','5','2','24','4','96',to_date('2015/05/30','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('8',to_date('2015/06/01','YYYY-MM-DD'),'2','5','16','30','35','1050',to_date('2015/06/07','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('11',to_date('2015/08/27','YYYY-MM-DD'),'3','5','14','10','4','40',to_date('2015/09/04','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('12',to_date('2015/10/14','YYYY-MM-DD'),'1','5','6','16','20','320',to_date('2015/10/22','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('13',to_date('2015/11/18','YYYY-MM-DD'),'1','5','3','12','9','108',to_date('2015/11/23','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('16',to_date('2016/03/08','YYYY-MM-DD'),'2','5','17','16','60','960',to_date('2016/03/12','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('19',to_date('2016/06/11','YYYY-MM-DD'),'1','5','11','4','40','160',to_date('2016/06/20','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('20',to_date('2016/06/11','YYYY-MM-DD'),'1','4','4','6','15','90',to_date('2016/07/11','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('21',to_date('2016/08/04','YYYY-MM-DD'),'1','4','4','6','15','90',to_date('2016/08/14','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('22',to_date('2016/08/17','YYYY-MM-DD'),'1','5','11','3','15','45',to_date('2016/08/29','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('23',to_date('2016/09/04','YYYY-MM-DD'),'1','4','8','16','13','208',to_date('2016/09/15','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('24',to_date('2016/10/05','YYYY-MM-DD'),'1','5','7','9','35','315',to_date('2016/10/13','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('27',to_date('2016/12/17','YYYY-MM-DD'),'3','4','15','4','5','20',to_date('2016/12/29','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('28',to_date('2017/01/13','YYYY-MM-DD'),'1','5','5','10','10','100',to_date('2017/01/28','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('29',to_date('2017/02/01','YYYY-MM-DD'),'1','5','5','4','10','40',to_date('2017/02/09','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('30',to_date('2017/03/12','YYYY-MM-DD'),'1','4','12','3','29','87',to_date('2017/03/17','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('31',to_date('2017/07/12','YYYY-MM-DD'),'1','4','8','16','13','208',to_date('2017/07/23','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('32',to_date('2018/04/14','YYYY-MM-DD'),'1','4','9','9','120','1080',to_date('2018/04/20','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('33',to_date('2018/08/02','YYYY-MM-DD'),'3','5','13','2','5','10',to_date('2018/08/10','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('34',to_date('2019/05/15','YYYY-MM-DD'),'1','5','1','15','5','75',to_date('2019/05/23','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('35',to_date('2019/12/15','YYYY-MM-DD'),'2','4','16','10','35','350',to_date('2019/12/24','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('36',to_date('2019/12/16','YYYY-MM-DD'),'1','5','3','12','9','108',to_date('2019/12/20','YYYY-MM-DD'));
INSERT INTO PO_out (PO_id_out, purchase_date, supplier_id, preparer_id, part_id, quantity, part_price, purchase_total, est_delivery) VALUES ('0',to_date('1900/01/01','YYYY-MM-DD'),'0','0','0','0','0','0',to_date('1900/01/01','YYYY-MM-DD'));

/*PO INVENTORY MAP*/

INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('1','1');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('2','10');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('3','7');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('6','13');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('7','2');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('8','16');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('11','14');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('12','6');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('13','3');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('16','17');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('19','11');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('20','4');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('21','4');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('22','11');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('23','8');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('24','7');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('27','15');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('28','5');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('29','5');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('30','12');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('31','8');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('32','9');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('33','13');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('34','1');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('35','16');
INSERT INTO PO_inventory_map (PO_id_out, part_id) VALUES ('36','3');

/*ACCOUNTS PAYABLE*/

INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('1','1','0','0','1','yes','75',to_date('2015/04/12','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('2','2','0','0','1','yes','330',to_date('2015/04/20','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('3','3','0','0','1','yes','350',to_date('2015/04/21','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('4','6','0','0','3','yes','50',to_date('2015/05/15','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('5','7','0','0','1','yes','96',to_date('2015/05/30','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('6','8','0','0','2','yes','1050',to_date('2015/06/07','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('7','11','0','0','3','yes','40',to_date('2015/09/04','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('8','12','0','0','1','yes','320',to_date('2015/10/22','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('9','13','0','0','1','yes','108',to_date('2015/11/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('10','16','0','0','2','yes','960',to_date('2016/03/12','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('11','19','0','0','1','yes','160',to_date('2016/06/20','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('12','20','0','0','1','yes','90',to_date('2016/07/11','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('13','21','0','0','1','yes','90',to_date('2016/08/14','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('14','22','0','0','1','yes','45',to_date('2016/08/29','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('15','23','0','0','1','yes','208',to_date('2016/09/15','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('16','24','0','0','1','yes','315',to_date('2016/10/13','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('17','27','0','0','3','yes','20',to_date('2016/12/29','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('18','28','0','0','1','yes','100',to_date('2017/01/28','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('19','29','0','0','1','yes','40',to_date('2017/02/09','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('20','30','0','0','1','yes','87',to_date('2017/03/17','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('21','31','0','0','1','yes','208',to_date('2017/07/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('22','32','0','0','1','yes','1080',to_date('2018/04/20','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('23','33','0','0','3','yes','10',to_date('2018/08/10','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('24','34','0','0','1','yes','75',to_date('2019/05/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('25','35','0','0','2','yes','350',to_date('2019/12/24','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('26','36','0','0','1','yes','108',to_date('2019/12/20','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('27','0','1','1','0','no','9532',to_date('2015/03/12','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('28','0','2','2','0','no','10000',to_date('2015/03/20','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('29','0','3','3','0','no','30181',to_date('2015/04/21','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('30','0','4','4','0','no','26028',to_date('2015/04/22','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('31','0','5','5','0','no','19347',to_date('2015/05/05','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('32','0','6','6','0','no','82481',to_date('2015/05/15','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('33','0','7','1','0','no','17000',to_date('2015/05/30','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('34','0','8','7','0','no','12903',to_date('2015/06/07','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('35','0','9','6','0','no','24000',to_date('2015/07/08','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('36','0','10','4','0','no','27000',to_date('2015/08/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('37','0','11','5','0','no','28000',to_date('2015/09/04','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('38','0','12','3','0','no','27000',to_date('2015/10/22','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('39','0','13','1','0','no','32000',to_date('2015/11/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('40','0','14','2','0','no','22000',to_date('2015/12/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('41','0','15','5','0','no','26038',to_date('2016/01/25','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('42','0','16','3','0','no','14000',to_date('2016/03/12','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('43','0','17','4','0','no','26000',to_date('2016/04/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('44','0','18','4','0','no','19000',to_date('2016/05/04','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('45','0','19','1','0','no','23000',to_date('2016/06/20','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('46','0','20','6','0','no','7000',to_date('2016/07/11','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('47','0','21','5','0','no','22000',to_date('2016/08/14','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('48','0','22','1','0','no','29000',to_date('2016/08/29','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('49','0','23','7','0','no','31000',to_date('2016/09/15','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('50','0','24','6','0','no','24000',to_date('2016/10/13','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('51','0','25','5','0','no','24000',to_date('2016/11/03','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('52','0','26','4.00','0','no','17000',to_date('2016/11/29','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('53','0','27','4.00','0','no','24000',to_date('2016/12/29','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('54','0','28','1.00','0','no','29000',to_date('2017/01/28','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('55','0','29','7.00','0','no','29000',to_date('2017/02/09','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('56','0','30','5.00','0','no','27000',to_date('2017/03/17','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('57','0','31','4.00','0','no','32000',to_date('2017/07/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('58','0','32','2.00','0','no','32500',to_date('2018/04/20','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('59','0','33','3.00','0','no','29428',to_date('2018/08/10','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('60','0','34','1.00','0','no','37000',to_date('2019/05/23','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('61','0','35','4.00','0','no','29471',to_date('2019/12/24','YYYY-MM-DD'),'yes');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('62','0','36','1.00','0','no','50700',to_date('2019/12/20','YYYY-MM-DD'),'no');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('63','0','37','5.00','0','no','41000',to_date('2019/12/25','YYYY-MM-DD'),'no');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('64','0','38','1.00','0','no','46000',to_date('2019/12/25','YYYY-MM-DD'),'no');
INSERT INTO accounts_payable (AP_id, PO_id_out, acq_invoice_id, dealer_id, supplier_id, for_supplies, amount, pay_by_date, is_paid) VALUES ('65','0','39','5.00','0','no','56000',to_date('2019/12/30','YYYY-MM-DD'),'no');

/*CUSTOMERS*/

INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('1','Jaqueline','Erickson','8058274716','je@gmail.com','1257 Johnson','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('2','Victoria','Michaels','8056152436','vm@gmail.com','9450 Branch','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('3','Frank','Ramezani','8051234567','fr@gmail.com','4339 California','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('4','Winthrop','Erickson','8050987659','we@gmail.com','934 Branch','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('5','Bob','Seiver','8069283752','sw@gmail.com','3427 Johnson','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('6','Dwight','Erickson','4058127462','de@gmail.com','160 Olive BLVD','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('7','Sally','Ramezani','9250293876','sakred@gmail.com','6280 Orchard Street','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('8','Victoria','Michaels','9251726411','vicmic@gmail.com','3864 Loomis','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('9','Domique','Mcquaid','8059138261','dom@gmail.com','2282 Johnson','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('10','Gunther','Floyd','8051828481','gun@gmail.com','9557 Loomis','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('11','Zane','Michaels','5048128731','sane@gmail.com','2021 Olive BLVD','3');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('12','Ann','Smith','8201827461','annnn@gmail.com','2593 Johnson','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('13','Zane','Smith','8058172652','zanemans@gmail.com','9269 Broad Street','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('14','Madeline','Seiver','8037261526','maddy@gmail.com','6899 Loomis','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('15','Zane','Ramezani','8059182735','zr@gmail.com','4315 Slack Street','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('16','Jaqueline','Dobson','8051237500','jaw@gmail.com','2337 Broad Street','3');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('17','Ulga','Pouragabager','8057129652','ulga@gmail.com','3539 Loomis','2');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('18','Winthrop','Erickson','4057162729','winny@gmail.com','1327 Slack Street','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('19','Domique','Doe','9159182741','domm@gmail.com','7904 Orchard Street','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('20','Dwight','Floyd','6152903812','dwight@gmail.com','9204 Orchard Street','1');
INSERT INTO customers (customer_id, f_name, l_name, phone_number, email, address, num_transactions) VALUES ('0','(null)','(null)','0','(null)','(null)','0');

/*CUSTOMER PREFERENCES*/

INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('1','Chevrolet');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('2','Dodge');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('3','Ferrari');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('4','Ford');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('5','Corvette');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('6','Mercedes');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('7','Lexus');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('8','BMW');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('9','Porche');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('10','Fiat');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('11','Jaguar');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('12','Lancias');
INSERT INTO customer_preferences (preference_id, pref_description) VALUES ('13','Saabs ');

/*CUSTOMER PREFERENCE MAP*/

INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('1','3');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('1','4');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('2','1');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('3','4');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('4','7');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('4','1');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('5','3');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('5','5');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('5','6');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('6','4');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('7','5');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('8','1');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('8','5');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('9','8');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('9','7');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('10','3');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('10','2');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('11','9');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('12','4');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('13','10');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('13','3');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('14','8');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('15','1');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('15','4');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('15','7');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('16','1');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('17','3');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('17','8');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('18','6');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('19','4');
INSERT INTO customer_preference_map (customer_id, preference_id) VALUES ('20','4');

/*PO IN*/

INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('1','1',to_date('2015/05/12','YYYY-MM-DD'),'1','1',to_date('2015/05/22','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('2','2',to_date('2015/06/20','YYYY-MM-DD'),'2','2',to_date('2015/06/30','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('3','3',to_date('2015/04/29','YYYY-MM-DD'),'3','3',to_date('2015/05/09','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('4','4',to_date('2015/05/22','YYYY-MM-DD'),'4','2',to_date('2015/06/02','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('5','5',to_date('2015/05/30','YYYY-MM-DD'),'5','7',to_date('2015/06/10','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('6','6',to_date('2015/07/15','YYYY-MM-DD'),'6','1',to_date('2015/07/25','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('7','7',to_date('2015/09/30','YYYY-MM-DD'),'7','2',to_date('2015/10/10','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('8','8',to_date('2016/01/07','YYYY-MM-DD'),'8','3',to_date('2016/01/17','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('9','9',to_date('2015/11/08','YYYY-MM-DD'),'9','3',to_date('2015/11/18','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('10','10',to_date('2015/12/23','YYYY-MM-DD'),'10','7',to_date('2016/01/03','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('11','11',to_date('2016/04/04','YYYY-MM-DD'),'11','2',to_date('2016/04/14','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('12','12',to_date('2016/06/22','YYYY-MM-DD'),'12','7',to_date('2016/07/02','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('13','13',to_date('2016/02/23','YYYY-MM-DD'),'13','3',to_date('2016/03/01','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('14','3',to_date('2016/03/23','YYYY-MM-DD'),'14','1',to_date('2016/04/03','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('15','4',to_date('2016/04/25','YYYY-MM-DD'),'15','2',to_date('2016/05/05','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('16','16',to_date('2016/04/12','YYYY-MM-DD'),'16','3',to_date('2016/04/22','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('17','11',to_date('2016/07/23','YYYY-MM-DD'),'17','6',to_date('2016/07/31','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('18','15',to_date('2016/09/04','YYYY-MM-DD'),'18','7',to_date('2016/09/14','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('19','6',to_date('2016/07/20','YYYY-MM-DD'),'19','1',to_date('2016/07/30','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('20','16',to_date('2016/8/11','YYYY-MM-DD'),'20','2',to_date('2016/08/21','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('21','13',to_date('2016/12/14','YYYY-MM-DD'),'21','3',to_date('2016/12/24','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('22','17',to_date('2017/03/01','YYYY-MM-DD'),'22','6',to_date('2017/03/09','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('23','8',to_date('2017/03/15','YYYY-MM-DD'),'23','7',to_date('2017/03/25','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('24','18',to_date('2016/12/13','YYYY-MM-DD'),'24','6',to_date('2016/12/23','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('25','15',to_date('2017/03/03','YYYY-MM-DD'),'25','7',to_date('2017/03/13','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('26','19',to_date('2017/06/29','YYYY-MM-DD'),'26','2',to_date('2017/07/09','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('27','10',to_date('2017/03/29','YYYY-MM-DD'),'27','1',to_date('2017/04/09','YYYY-MM-DD'),'yes');
INSERT INTO PO_in (PO_id_in, customer_id, purchase_date, car_id, preparer_id, est_delivery, is_approved) VALUES ('28','16',to_date('2017/07/28','YYYY-MM-DD'),'28','1',to_date('2017/08/08','YYYY-MM-DD'),'yes');

/*INVENTORY SALES TRACKER*/

INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('1','1');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('2','2');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('3','3');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('4','4');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('5','5');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('6','6');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('7','7');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('8','8');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('9','9');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('10','10');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('11','11');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('12','12');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('13','13');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('14','14');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('15','15');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('16','16');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('17','17');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('18','18');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('19','19');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('20','20');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('21','21');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('22','22');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('23','23');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('24','24');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('25','25');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('26','26');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('27','27');
INSERT INTO inventory_sales_tracker (car_id, PO_id_in) VALUES ('28','28');

/*SALES INVOICES*/

INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('1','1','1',to_date('2015/05/12','YYYY-MM-DD'),'9771');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('2','2','2',to_date('2015/06/20','YYYY-MM-DD'),'10239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('3','3','3',to_date('2015/04/29','YYYY-MM-DD'),'30420');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('4','4','4',to_date('2015/05/22','YYYY-MM-DD'),'26267');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('5','5','5',to_date('2015/05/30','YYYY-MM-DD'),'19586');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('6','6','6',to_date('2015/07/15','YYYY-MM-DD'),'82720');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('7','7','7',to_date('2015/09/30','YYYY-MM-DD'),'17239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('8','8','8',to_date('2016/01/07','YYYY-MM-DD'),'13142');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('9','9','9',to_date('2015/11/08','YYYY-MM-DD'),'24239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('10','9','9',to_date('2015/11/08','YYYY-MM-DD'),'24239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('11','10','10',to_date('2015/12/23','YYYY-MM-DD'),'27239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('12','11','11',to_date('2016/04/04','YYYY-MM-DD'),'28239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('13','12','12',to_date('2016/06/22','YYYY-MM-DD'),'27239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('14','13','13',to_date('2016/02/23','YYYY-MM-DD'),'32239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('15','3','14',to_date('2016/03/23','YYYY-MM-DD'),'22239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('16','4','15',to_date('2016/04/25','YYYY-MM-DD'),'26277');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('17','11','17',to_date('2016/07/23','YYYY-MM-DD'),'26239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('18','16','16',to_date('2016/04/12','YYYY-MM-DD'),'14239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('19','11','17',to_date('2016/07/23','YYYY-MM-DD'),'26239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('20','15','18',to_date('2016/09/04','YYYY-MM-DD'),'19239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('21','6','19',to_date('2016/07/20','YYYY-MM-DD'),'23239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('22','16','20',to_date('2016/8/11','YYYY-MM-DD'),'7239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('23','13','21',to_date('2016/12/14','YYYY-MM-DD'),'22239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('24','17','22',to_date('2017/03/01','YYYY-MM-DD'),'29239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('25','8','23',to_date('2017/03/15','YYYY-MM-DD'),'31239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('26','18','24',to_date('2016/12/13','YYYY-MM-DD'),'24239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('27','15','25',to_date('2017/03/03','YYYY-MM-DD'),'24239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('28','19','26',to_date('2017/06/29','YYYY-MM-DD'),'17239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('29','10','27',to_date('2017/03/29','YYYY-MM-DD'),'24239');
INSERT INTO sales_invoices (invoice_id, customer_id, PO_id_in, sale_date, price) VALUES ('30','16','28',to_date('2017/07/28','YYYY-MM-DD'),'29239');

/*ACCOUNTS RECEIVABLE*/

INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('1','1','9771',to_date('2015/05/22','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('2','2','10239',to_date('2015/06/30','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('3','3','30420',to_date('2015/05/09','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('4','4','26267',to_date('2015/06/02','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('5','5','19586',to_date('2015/06/10','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('6','6','82720',to_date('2015/07/25','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('7','7','17239',to_date('2015/10/10','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('8','8','13142',to_date('2016/01/17','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('10','9','24239',to_date('2015/11/18','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('11','10','27239',to_date('2016/01/03','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('12','11','28239',to_date('2016/04/14','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('13','12','27239',to_date('2016/07/02','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('14','13','32239',to_date('2016/03/01','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('15','3','22239',to_date('2016/04/03','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('16','4','26277',to_date('2016/05/05','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('18','16','14239',to_date('2016/04/22','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('19','11','26239',to_date('2016/07/31','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('20','15','19239',to_date('2016/09/14','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('21','6','23239',to_date('2016/07/30','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('22','16','7239',to_date('2016/08/21','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('23','13','22239',to_date('2016/12/24','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('24','17','29239',to_date('2017/03/09','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('25','8','31239',to_date('2017/03/25','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('26','18','24239',to_date('2016/12/23','YYYY-MM-DD'),'no');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('27','15','24239',to_date('2017/03/13','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('28','19','17239',to_date('2017/07/09','YYYY-MM-DD'),'no');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('29','10','24239',to_date('2017/04/09','YYYY-MM-DD'),'yes');
INSERT INTO accounts_receivable (invoice_id, customer_id, amount, pay_by_date, is_paid) VALUES ('30','16','29239',to_date('2017/08/08','YYYY-MM-DD'),'no');

/*SERVICES*/

INSERT INTO services (service_id, service_description, is_add_on, service_cost, service_price) VALUES ('1','tire change','yes','25','65');
INSERT INTO services (service_id, service_description, is_add_on, service_cost, service_price) VALUES ('2','oil change','no','5','30');
INSERT INTO services (service_id, service_description, is_add_on, service_cost, service_price) VALUES ('3','filter/fluid change','no','5','30');
INSERT INTO services (service_id, service_description, is_add_on, service_cost, service_price) VALUES ('4','engine service','no','50','200');
INSERT INTO services (service_id, service_description, is_add_on, service_cost, service_price) VALUES ('5','detail/cleaning service','no','20','60');
INSERT INTO services (service_id, service_description, is_add_on, service_cost, service_price) VALUES ('6','enhancement/installation','yes','200','455');

/*SERVICE JOBS*/

INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('1','4','19',to_date('2016/06/20','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('2','5','30',to_date('2017/03/17','YYYY-MM-DD'),to_date('2017/03/27','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('3','4','33',to_date('2018/08/10','YYYY-MM-DD'),to_date('2018/08/20','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('4','4','36',to_date('2019/12/25','YYYY-MM-DD'),to_date('2020/01/04','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('5','5','40',to_date('2015/07/23','YYYY-MM-DD'),to_date('2015/07/30','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('6','5','41',to_date('2015/11/11','YYYY-MM-DD'),to_date('2015/11/21','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('7','4','42',to_date('2015/12/05','YYYY-MM-DD'),to_date('2015/12/15','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('8','4','43',to_date('2016/02/22','YYYY-MM-DD'),to_date('2016/02/28','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('9','5','44',to_date('2016/05/09','YYYY-MM-DD'),to_date('2016/05/19','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('10','4','45',to_date('2016/08/03','YYYY-MM-DD'),to_date('2016/08/13','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('11','5','46',to_date('2016/10/20','YYYY-MM-DD'),to_date('2016/10/30','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('12','5','47',to_date('2017/01/24','YYYY-MM-DD'),to_date('2017/01/30','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('13','5','48',to_date('2017/04/20','YYYY-MM-DD'),to_date('2017/04/30','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('14','4','49',to_date('2018/03/13','YYYY-MM-DD'),to_date('2018/03/23','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('15','4','50',to_date('2018/05/15','YYYY-MM-DD'),to_date('2018/05/25','YYYY-MM-DD'),'no');
INSERT INTO service_jobs (service_job_id, staff_id, car_id, start_date, end_date, is_current) VALUES ('16','5','51',to_date('2019/06/23','YYYY-MM-DD'),to_date('2019/06/30','YYYY-MM-DD'),'no');

/*SERVICE INVOICES*/

INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('1','1','9','4');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('2','5','10','5');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('3','4','17','6');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('4','6','2','7');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('5','2','5','8');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('6','4','7','9');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('7','2','4','10');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('8','1','18','11');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('9','5','19','12');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('10','4','6','13');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('11','6','4','14');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('12','4','2','15');
INSERT INTO service_invoices (service_invoice_id, service_id, customer_id, service_job_id) VALUES ('13','6','10','16');

/*INVENTORY SERVICE MAP*/

INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('1','1','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('2','8','4');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('3','1','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('4','16','4');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('5','14','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('6','8','6');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('7','11','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('8','1','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('9','8','4');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('10','1','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('11','17','2');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('12','14','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('13','8','6');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('14','9','1');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('15','8','10');
INSERT INTO inventory_service_map (service_job_id, part_id, quantity_used) VALUES ('16','12','1');

/*CUSTOMER SERVICE MAP*/

INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('1','0');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('2','0');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('3','0');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('4','9');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('5','10');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('6','17');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('7','2');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('8','5');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('9','7');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('10','4');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('11','18');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('12','19');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('13','6');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('14','4');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('15','2');
INSERT INTO customer_service_map (service_job_id, customer_id) VALUES ('16','10');

/*PAYROLL*/

INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('1','7','80000','6666.67',to_date('2015/01/01','YYYY-MM-DD'),to_date('2015/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('2','7','80000','6666.67',to_date('2015/02/01','YYYY-MM-DD'),to_date('2015/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('3','1','45000','3750.00',to_date('2015/03/01','YYYY-MM-DD'),to_date('2015/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('4','2','45000','3750.00',to_date('2015/03/01','YYYY-MM-DD'),to_date('2015/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('5','7','80000','6666.67',to_date('2015/03/01','YYYY-MM-DD'),to_date('2015/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('6','1','45000','3750.00',to_date('2015/04/01','YYYY-MM-DD'),to_date('2015/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('7','2','45000','3750.00',to_date('2015/04/01','YYYY-MM-DD'),to_date('2015/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('8','3','45000','3750.00',to_date('2015/04/01','YYYY-MM-DD'),to_date('2015/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('9','5','50000','4166.67',to_date('2015/04/01','YYYY-MM-DD'),to_date('2015/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('10','7','80000','6666.67',to_date('2015/04/01','YYYY-MM-DD'),to_date('2015/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('11','1','45000','3750.00',to_date('2015/05/01','YYYY-MM-DD'),to_date('2015/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('12','2','45000','3750.00',to_date('2015/05/01','YYYY-MM-DD'),to_date('2015/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('13','3','45000','3750.00',to_date('2015/05/01','YYYY-MM-DD'),to_date('2015/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('14','5','50000','4166.67',to_date('2015/05/01','YYYY-MM-DD'),to_date('2015/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('15','7','80000','6666.67',to_date('2015/05/01','YYYY-MM-DD'),to_date('2015/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('16','1','45000','3750.00',to_date('2015/06/01','YYYY-MM-DD'),to_date('2015/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('17','2','45000','3750.00',to_date('2015/06/01','YYYY-MM-DD'),to_date('2015/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('18','3','45000','3750.00',to_date('2015/06/01','YYYY-MM-DD'),to_date('2015/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('19','5','50000','4166.67',to_date('2015/06/01','YYYY-MM-DD'),to_date('2015/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('20','7','80000','6666.67',to_date('2015/06/01','YYYY-MM-DD'),to_date('2015/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('21','1','45000','3750.00',to_date('2015/07/01','YYYY-MM-DD'),to_date('2015/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('22','2','45000','3750.00',to_date('2015/07/01','YYYY-MM-DD'),to_date('2015/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('23','3','45000','3750.00',to_date('2015/07/01','YYYY-MM-DD'),to_date('2015/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('24','5','50000','4166.67',to_date('2015/07/01','YYYY-MM-DD'),to_date('2015/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('25','7','80000','6666.67',to_date('2015/07/01','YYYY-MM-DD'),to_date('2015/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('26','1','45000','3750.00',to_date('2015/08/01','YYYY-MM-DD'),to_date('2015/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('27','2','45000','3750.00',to_date('2015/08/01','YYYY-MM-DD'),to_date('2015/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('28','3','45000','3750.00',to_date('2015/08/01','YYYY-MM-DD'),to_date('2015/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('29','5','50000','4166.67',to_date('2015/08/01','YYYY-MM-DD'),to_date('2015/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('30','7','80000','6666.67',to_date('2015/08/01','YYYY-MM-DD'),to_date('2015/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('31','1','45000','3750.00',to_date('2015/09/01','YYYY-MM-DD'),to_date('2015/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('32','2','45000','3750.00',to_date('2015/09/01','YYYY-MM-DD'),to_date('2015/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('33','3','45000','3750.00',to_date('2015/09/01','YYYY-MM-DD'),to_date('2015/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('34','5','50000','4166.67',to_date('2015/09/01','YYYY-MM-DD'),to_date('2015/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('35','7','80000','6666.67',to_date('2015/09/01','YYYY-MM-DD'),to_date('2015/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('36','1','45000','3750.00',to_date('2015/10/01','YYYY-MM-DD'),to_date('2015/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('37','2','45000','3750.00',to_date('2015/10/01','YYYY-MM-DD'),to_date('2015/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('38','3','45000','3750.00',to_date('2015/10/01','YYYY-MM-DD'),to_date('2015/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('39','5','50000','4166.67',to_date('2015/10/01','YYYY-MM-DD'),to_date('2015/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('40','7','80000','6666.67',to_date('2015/10/01','YYYY-MM-DD'),to_date('2015/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('41','1','45000','3750.00',to_date('2015/11/01','YYYY-MM-DD'),to_date('2015/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('42','2','45000','3750.00',to_date('2015/11/01','YYYY-MM-DD'),to_date('2015/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('43','3','45000','3750.00',to_date('2015/11/01','YYYY-MM-DD'),to_date('2015/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('44','5','50000','4166.67',to_date('2015/11/01','YYYY-MM-DD'),to_date('2015/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('45','7','80000','6666.67',to_date('2015/11/01','YYYY-MM-DD'),to_date('2015/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('46','1','45000','3750.00',to_date('2015/12/01','YYYY-MM-DD'),to_date('2015/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('47','2','45000','3750.00',to_date('2015/12/01','YYYY-MM-DD'),to_date('2015/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('48','3','45000','3750.00',to_date('2015/12/01','YYYY-MM-DD'),to_date('2015/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('49','5','50000','4166.67',to_date('2015/12/01','YYYY-MM-DD'),to_date('2015/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('50','7','80000','6666.67',to_date('2015/12/01','YYYY-MM-DD'),to_date('2015/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('51','1','45000','3750.00',to_date('2016/01/01','YYYY-MM-DD'),to_date('2016/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('52','2','45000','3750.00',to_date('2016/01/01','YYYY-MM-DD'),to_date('2016/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('53','3','45000','3750.00',to_date('2016/01/01','YYYY-MM-DD'),to_date('2016/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('54','4','50000','4166.67',to_date('2016/01/01','YYYY-MM-DD'),to_date('2016/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('55','5','50000','4166.67',to_date('2016/01/01','YYYY-MM-DD'),to_date('2016/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('56','7','85000','7083.33',to_date('2016/01/01','YYYY-MM-DD'),to_date('2016/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('57','1','45000','3750.00',to_date('2016/02/01','YYYY-MM-DD'),to_date('2016/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('58','2','45000','3750.00',to_date('2016/02/01','YYYY-MM-DD'),to_date('2016/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('59','3','45000','3750.00',to_date('2016/02/01','YYYY-MM-DD'),to_date('2016/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('60','4','50000','4166.67',to_date('2016/02/01','YYYY-MM-DD'),to_date('2016/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('61','5','50000','4166.67',to_date('2016/02/01','YYYY-MM-DD'),to_date('2016/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('62','7','85000','7083.33',to_date('2016/02/01','YYYY-MM-DD'),to_date('2016/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('63','1','47000','3916.67',to_date('2016/03/01','YYYY-MM-DD'),to_date('2016/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('64','2','47000','3916.67',to_date('2016/03/01','YYYY-MM-DD'),to_date('2016/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('65','3','45000','3750.00',to_date('2016/03/01','YYYY-MM-DD'),to_date('2016/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('66','4','50000','4166.67',to_date('2016/03/01','YYYY-MM-DD'),to_date('2016/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('67','5','50000','4166.67',to_date('2016/03/01','YYYY-MM-DD'),to_date('2016/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('68','7','85000','7083.33',to_date('2016/03/01','YYYY-MM-DD'),to_date('2016/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('69','1','47000','3916.67',to_date('2016/04/01','YYYY-MM-DD'),to_date('2016/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('70','2','47000','3916.67',to_date('2016/04/01','YYYY-MM-DD'),to_date('2016/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('71','3','47000','3916.67',to_date('2016/04/01','YYYY-MM-DD'),to_date('2016/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('72','4','50000','4166.67',to_date('2016/04/01','YYYY-MM-DD'),to_date('2016/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('73','5','50000','4166.67',to_date('2016/04/01','YYYY-MM-DD'),to_date('2016/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('74','7','85000','7083.33',to_date('2016/04/01','YYYY-MM-DD'),to_date('2016/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('75','1','47000','3916.67',to_date('2016/05/01','YYYY-MM-DD'),to_date('2016/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('76','2','47000','3916.67',to_date('2016/05/01','YYYY-MM-DD'),to_date('2016/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('77','3','47000','3916.67',to_date('2016/05/01','YYYY-MM-DD'),to_date('2016/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('78','4','50000','4166.67',to_date('2016/05/01','YYYY-MM-DD'),to_date('2016/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('79','5','50000','4166.67',to_date('2016/05/01','YYYY-MM-DD'),to_date('2016/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('80','6','60000','5000.00',to_date('2016/05/01','YYYY-MM-DD'),to_date('2016/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('81','7','85000','7083.33',to_date('2016/05/01','YYYY-MM-DD'),to_date('2016/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('82','1','47000','3916.67',to_date('2016/06/01','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('83','2','47000','3916.67',to_date('2016/06/01','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('84','3','47000','3916.67',to_date('2016/06/01','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('85','4','50000','4166.67',to_date('2016/06/01','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('86','5','50000','4166.67',to_date('2016/06/01','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('87','6','60000','5000.00',to_date('2016/06/01','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('88','7','85000','7083.33',to_date('2016/06/01','YYYY-MM-DD'),to_date('2016/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('89','1','47000','3916.67',to_date('2016/07/01','YYYY-MM-DD'),to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('90','2','47000','3916.67',to_date('2016/07/01','YYYY-MM-DD'),to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('91','3','47000','3916.67',to_date('2016/07/01','YYYY-MM-DD'),to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('92','4','50000','4166.67',to_date('2016/07/01','YYYY-MM-DD'),to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('93','5','50000','4166.67',to_date('2016/07/01','YYYY-MM-DD'),to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('94','6','60000','5000.00',to_date('2016/07/01','YYYY-MM-DD'),to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('95','7','85000','7083.33',to_date('2016/07/01','YYYY-MM-DD'),to_date('2016/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('96','1','47000','3916.67',to_date('2016/08/01','YYYY-MM-DD'),to_date('2016/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('97','2','47000','3916.67',to_date('2016/08/01','YYYY-MM-DD'),to_date('2016/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('98','3','47000','3916.67',to_date('2016/08/01','YYYY-MM-DD'),to_date('2016/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('99','4','50000','4166.67',to_date('2016/08/01','YYYY-MM-DD'),to_date('2016/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('100','5','50000','4166.67',to_date('2016/08/01','YYYY-MM-DD'),to_date('2016/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('101','6','60000','5000.00',to_date('2016/08/01','YYYY-MM-DD'),to_date('2016/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('102','7','85000','7083.33',to_date('2016/08/01','YYYY-MM-DD'),to_date('2016/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('103','1','47000','3916.67',to_date('2016/09/01','YYYY-MM-DD'),to_date('2016/08/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('104','2','47000','3916.67',to_date('2016/09/01','YYYY-MM-DD'),to_date('2016/08/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('105','3','47000','3916.67',to_date('2016/09/01','YYYY-MM-DD'),to_date('2016/08/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('106','4','50000','4166.67',to_date('2016/09/01','YYYY-MM-DD'),to_date('2016/08/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('107','5','50000','4166.67',to_date('2016/09/01','YYYY-MM-DD'),to_date('2016/08/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('108','6','60000','5000.00',to_date('2016/09/01','YYYY-MM-DD'),to_date('2016/08/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('109','7','85000','7083.33',to_date('2016/09/01','YYYY-MM-DD'),to_date('2016/08/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('110','1','47000','3916.67',to_date('2016/10/01','YYYY-MM-DD'),to_date('2016/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('111','2','47000','3916.67',to_date('2016/10/01','YYYY-MM-DD'),to_date('2016/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('112','3','47000','3916.67',to_date('2016/10/01','YYYY-MM-DD'),to_date('2016/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('113','4','50000','4166.67',to_date('2016/10/01','YYYY-MM-DD'),to_date('2016/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('114','5','50000','4166.67',to_date('2016/10/01','YYYY-MM-DD'),to_date('2016/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('115','6','60000','5000.00',to_date('2016/10/01','YYYY-MM-DD'),to_date('2016/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('116','7','85000','7083.33',to_date('2016/10/01','YYYY-MM-DD'),to_date('2016/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('117','1','47000','3916.67',to_date('2016/11/01','YYYY-MM-DD'),to_date('2016/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('118','2','47000','3916.67',to_date('2016/11/01','YYYY-MM-DD'),to_date('2016/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('119','3','47000','3916.67',to_date('2016/11/01','YYYY-MM-DD'),to_date('2016/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('120','4','50000','4166.67',to_date('2016/11/01','YYYY-MM-DD'),to_date('2016/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('121','5','50000','4166.67',to_date('2016/11/01','YYYY-MM-DD'),to_date('2016/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('122','6','60000','5000.00',to_date('2016/11/01','YYYY-MM-DD'),to_date('2016/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('123','7','85000','7083.33',to_date('2016/11/01','YYYY-MM-DD'),to_date('2016/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('124','1','47000','3916.67',to_date('2016/12/01','YYYY-MM-DD'),to_date('2016/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('125','2','47000','3916.67',to_date('2016/12/01','YYYY-MM-DD'),to_date('2016/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('126','3','47000','3916.67',to_date('2016/12/01','YYYY-MM-DD'),to_date('2016/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('127','4','54000','4500.00',to_date('2016/12/01','YYYY-MM-DD'),to_date('2016/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('128','5','50000','4166.67',to_date('2016/12/01','YYYY-MM-DD'),to_date('2016/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('129','6','60000','5000.00',to_date('2016/12/01','YYYY-MM-DD'),to_date('2016/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('130','7','88000','7333.33',to_date('2016/12/01','YYYY-MM-DD'),to_date('2016/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('131','1','47000','3916.67',to_date('2017/01/01','YYYY-MM-DD'),to_date('2017/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('132','2','47000','3916.67',to_date('2017/01/01','YYYY-MM-DD'),to_date('2017/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('133','3','47000','3916.67',to_date('2017/01/01','YYYY-MM-DD'),to_date('2017/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('134','4','54000','4500.00',to_date('2017/01/01','YYYY-MM-DD'),to_date('2017/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('135','5','50000','4166.67',to_date('2017/01/01','YYYY-MM-DD'),to_date('2017/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('136','6','60000','5000.00',to_date('2017/01/01','YYYY-MM-DD'),to_date('2017/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('137','7','88000','7333.33',to_date('2017/01/01','YYYY-MM-DD'),to_date('2017/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('138','1','47000','3916.67',to_date('2017/02/01','YYYY-MM-DD'),to_date('2017/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('139','2','47000','3916.67',to_date('2017/02/01','YYYY-MM-DD'),to_date('2017/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('140','3','47000','3916.67',to_date('2017/02/01','YYYY-MM-DD'),to_date('2017/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('141','4','54000','4500.00',to_date('2017/02/01','YYYY-MM-DD'),to_date('2017/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('142','5','50000','4166.67',to_date('2017/02/01','YYYY-MM-DD'),to_date('2017/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('143','6','60000','5000.00',to_date('2017/02/01','YYYY-MM-DD'),to_date('2017/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('144','7','88000','7333.33',to_date('2017/02/01','YYYY-MM-DD'),to_date('2017/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('145','1','49000','4083.33',to_date('2017/03/01','YYYY-MM-DD'),to_date('2017/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('146','2','49000','4083.33',to_date('2017/03/01','YYYY-MM-DD'),to_date('2017/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('147','3','47000','3916.67',to_date('2017/03/01','YYYY-MM-DD'),to_date('2017/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('148','4','54000','4500.00',to_date('2017/03/01','YYYY-MM-DD'),to_date('2017/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('149','5','50000','4166.67',to_date('2017/03/01','YYYY-MM-DD'),to_date('2017/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('150','6','60000','5000.00',to_date('2017/03/01','YYYY-MM-DD'),to_date('2017/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('151','7','88000','7333.33',to_date('2017/03/01','YYYY-MM-DD'),to_date('2017/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('152','1','49000','4083.33',to_date('2017/04/01','YYYY-MM-DD'),to_date('2017/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('153','2','49000','4083.33',to_date('2017/04/01','YYYY-MM-DD'),to_date('2017/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('154','4','54000','4500.00',to_date('2017/04/01','YYYY-MM-DD'),to_date('2017/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('155','5','53000','4416.67',to_date('2017/04/01','YYYY-MM-DD'),to_date('2017/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('156','6','60000','5000.00',to_date('2017/04/01','YYYY-MM-DD'),to_date('2017/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('157','7','88000','7333.33',to_date('2017/04/01','YYYY-MM-DD'),to_date('2017/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('158','1','49000','4083.33',to_date('2017/05/01','YYYY-MM-DD'),to_date('2017/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('159','2','49000','4083.33',to_date('2017/05/01','YYYY-MM-DD'),to_date('2017/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('160','4','54000','4500.00',to_date('2017/05/01','YYYY-MM-DD'),to_date('2017/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('161','5','53000','4416.67',to_date('2017/05/01','YYYY-MM-DD'),to_date('2017/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('162','6','63000','5250.00',to_date('2017/05/01','YYYY-MM-DD'),to_date('2017/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('163','7','88000','7333.33',to_date('2017/05/01','YYYY-MM-DD'),to_date('2017/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('164','1','49000','4083.33',to_date('2017/06/01','YYYY-MM-DD'),to_date('2017/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('165','2','49000','4083.33',to_date('2017/06/01','YYYY-MM-DD'),to_date('2017/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('166','4','54000','4500.00',to_date('2017/06/01','YYYY-MM-DD'),to_date('2017/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('167','5','53000','4416.67',to_date('2017/06/01','YYYY-MM-DD'),to_date('2017/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('168','6','63000','5250.00',to_date('2017/06/01','YYYY-MM-DD'),to_date('2017/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('169','7','88000','7333.33',to_date('2017/06/01','YYYY-MM-DD'),to_date('2017/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('170','1','49000','4083.33',to_date('2017/07/01','YYYY-MM-DD'),to_date('2017/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('171','2','49000','4083.33',to_date('2017/07/01','YYYY-MM-DD'),to_date('2017/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('172','4','54000','4500.00',to_date('2017/07/01','YYYY-MM-DD'),to_date('2017/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('173','5','53000','4416.67',to_date('2017/07/01','YYYY-MM-DD'),to_date('2017/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('174','6','63000','5250.00',to_date('2017/07/01','YYYY-MM-DD'),to_date('2017/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('175','7','88000','7333.33',to_date('2017/07/01','YYYY-MM-DD'),to_date('2017/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('176','1','49000','4083.33',to_date('2017/08/01','YYYY-MM-DD'),to_date('2017/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('177','2','49000','4083.33',to_date('2017/08/01','YYYY-MM-DD'),to_date('2017/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('178','4','54000','4500.00',to_date('2017/08/01','YYYY-MM-DD'),to_date('2017/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('179','5','53000','4416.67',to_date('2017/08/01','YYYY-MM-DD'),to_date('2017/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('180','6','63000','5250.00',to_date('2017/08/01','YYYY-MM-DD'),to_date('2017/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('181','7','88000','7333.33',to_date('2017/08/01','YYYY-MM-DD'),to_date('2017/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('182','1','49000','4083.33',to_date('2017/09/01','YYYY-MM-DD'),to_date('2017/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('183','2','49000','4083.33',to_date('2017/09/01','YYYY-MM-DD'),to_date('2017/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('184','4','54000','4500.00',to_date('2017/09/01','YYYY-MM-DD'),to_date('2017/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('185','5','53000','4416.67',to_date('2017/09/01','YYYY-MM-DD'),to_date('2017/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('186','6','63000','5250.00',to_date('2017/09/01','YYYY-MM-DD'),to_date('2017/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('187','7','88000','7333.33',to_date('2017/09/01','YYYY-MM-DD'),to_date('2017/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('188','1','49000','4083.33',to_date('2017/10/01','YYYY-MM-DD'),to_date('2017/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('189','2','49000','4083.33',to_date('2017/10/01','YYYY-MM-DD'),to_date('2017/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('190','4','54000','4500.00',to_date('2017/10/01','YYYY-MM-DD'),to_date('2017/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('191','5','53000','4416.67',to_date('2017/10/01','YYYY-MM-DD'),to_date('2017/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('192','6','63000','5250.00',to_date('2017/10/01','YYYY-MM-DD'),to_date('2017/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('193','7','88000','7333.33',to_date('2017/10/01','YYYY-MM-DD'),to_date('2017/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('194','1','49000','4083.33',to_date('2017/11/01','YYYY-MM-DD'),to_date('2017/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('195','2','49000','4083.33',to_date('2017/11/01','YYYY-MM-DD'),to_date('2017/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('196','4','54000','4500.00',to_date('2017/11/01','YYYY-MM-DD'),to_date('2017/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('197','5','53000','4416.67',to_date('2017/11/01','YYYY-MM-DD'),to_date('2017/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('198','6','63000','5250.00',to_date('2017/11/01','YYYY-MM-DD'),to_date('2017/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('199','7','88000','7333.33',to_date('2017/11/01','YYYY-MM-DD'),to_date('2017/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('200','1','49000','4083.33',to_date('2017/12/01','YYYY-MM-DD'),to_date('2017/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('201','2','49000','4083.33',to_date('2017/12/01','YYYY-MM-DD'),to_date('2017/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('202','4','54000','4500.00',to_date('2017/12/01','YYYY-MM-DD'),to_date('2017/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('203','5','53000','4416.67',to_date('2017/12/01','YYYY-MM-DD'),to_date('2017/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('204','6','63000','5250.00',to_date('2017/12/01','YYYY-MM-DD'),to_date('2017/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('205','7','88000','7333.33',to_date('2017/12/01','YYYY-MM-DD'),to_date('2017/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('206','1','49000','4083.33',to_date('2018/01/01','YYYY-MM-DD'),to_date('2018/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('207','2','49000','4083.33',to_date('2018/01/01','YYYY-MM-DD'),to_date('2018/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('208','4','57000','4750.00',to_date('2018/01/01','YYYY-MM-DD'),to_date('2018/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('209','5','53000','4416.67',to_date('2018/01/01','YYYY-MM-DD'),to_date('2018/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('210','6','63000','5250.00',to_date('2018/01/01','YYYY-MM-DD'),to_date('2018/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('211','7','90000','7500.00',to_date('2018/01/01','YYYY-MM-DD'),to_date('2018/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('212','1','49000','4083.33',to_date('2018/02/01','YYYY-MM-DD'),to_date('2018/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('213','2','49000','4083.33',to_date('2018/02/01','YYYY-MM-DD'),to_date('2018/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('214','4','57000','4750.00',to_date('2018/02/01','YYYY-MM-DD'),to_date('2018/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('215','5','53000','4416.67',to_date('2018/02/01','YYYY-MM-DD'),to_date('2018/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('216','6','63000','5250.00',to_date('2018/02/01','YYYY-MM-DD'),to_date('2018/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('217','7','90000','7500.00',to_date('2018/02/01','YYYY-MM-DD'),to_date('2018/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('218','1','52000','4333.33',to_date('2018/03/01','YYYY-MM-DD'),to_date('2018/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('219','2','52000','4333.33',to_date('2018/03/01','YYYY-MM-DD'),to_date('2018/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('220','4','57000','4750.00',to_date('2018/03/01','YYYY-MM-DD'),to_date('2018/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('221','5','53000','4416.67',to_date('2018/03/01','YYYY-MM-DD'),to_date('2018/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('222','6','63000','5250.00',to_date('2018/03/01','YYYY-MM-DD'),to_date('2018/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('223','7','90000','7500.00',to_date('2018/03/01','YYYY-MM-DD'),to_date('2018/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('224','1','52000','4333.33',to_date('2018/04/01','YYYY-MM-DD'),to_date('2018/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('225','2','52000','4333.33',to_date('2018/04/01','YYYY-MM-DD'),to_date('2018/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('226','4','57000','4750.00',to_date('2018/04/01','YYYY-MM-DD'),to_date('2018/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('227','5','55000','4583.33',to_date('2018/04/01','YYYY-MM-DD'),to_date('2018/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('228','6','63000','5250.00',to_date('2018/04/01','YYYY-MM-DD'),to_date('2018/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('229','7','90000','7500.00',to_date('2018/04/01','YYYY-MM-DD'),to_date('2018/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('230','1','52000','4333.33',to_date('2018/05/01','YYYY-MM-DD'),to_date('2018/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('231','2','52000','4333.33',to_date('2018/05/01','YYYY-MM-DD'),to_date('2018/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('232','4','57000','4750.00',to_date('2018/05/01','YYYY-MM-DD'),to_date('2018/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('233','5','55000','4583.33',to_date('2018/05/01','YYYY-MM-DD'),to_date('2018/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('234','6','66000','5500.00',to_date('2018/05/01','YYYY-MM-DD'),to_date('2018/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('235','7','90000','7500.00',to_date('2018/05/01','YYYY-MM-DD'),to_date('2018/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('236','1','52000','4333.33',to_date('2018/06/01','YYYY-MM-DD'),to_date('2018/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('237','2','52000','4333.33',to_date('2018/06/01','YYYY-MM-DD'),to_date('2018/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('238','4','57000','4750.00',to_date('2018/06/01','YYYY-MM-DD'),to_date('2018/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('239','5','55000','4583.33',to_date('2018/06/01','YYYY-MM-DD'),to_date('2018/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('240','6','66000','5500.00',to_date('2018/06/01','YYYY-MM-DD'),to_date('2018/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('241','7','90000','7500.00',to_date('2018/06/01','YYYY-MM-DD'),to_date('2018/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('242','1','52000','4333.33',to_date('2018/07/01','YYYY-MM-DD'),to_date('2018/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('243','2','52000','4333.33',to_date('2018/07/01','YYYY-MM-DD'),to_date('2018/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('244','4','57000','4750.00',to_date('2018/07/01','YYYY-MM-DD'),to_date('2018/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('245','5','55000','4583.33',to_date('2018/07/01','YYYY-MM-DD'),to_date('2018/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('246','6','66000','5500.00',to_date('2018/07/01','YYYY-MM-DD'),to_date('2018/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('247','7','90000','7500.00',to_date('2018/07/01','YYYY-MM-DD'),to_date('2018/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('248','1','52000','4333.33',to_date('2018/08/01','YYYY-MM-DD'),to_date('2018/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('249','2','52000','4333.33',to_date('2018/08/01','YYYY-MM-DD'),to_date('2018/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('250','4','57000','4750.00',to_date('2018/08/01','YYYY-MM-DD'),to_date('2018/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('251','5','55000','4583.33',to_date('2018/08/01','YYYY-MM-DD'),to_date('2018/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('252','6','66000','5500.00',to_date('2018/08/01','YYYY-MM-DD'),to_date('2018/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('253','7','90000','7500.00',to_date('2018/08/01','YYYY-MM-DD'),to_date('2018/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('254','1','52000','4333.33',to_date('2018/09/01','YYYY-MM-DD'),to_date('2018/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('255','2','52000','4333.33',to_date('2018/09/01','YYYY-MM-DD'),to_date('2018/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('256','4','57000','4750.00',to_date('2018/09/01','YYYY-MM-DD'),to_date('2018/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('257','5','55000','4583.33',to_date('2018/09/01','YYYY-MM-DD'),to_date('2018/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('258','6','66000','5500.00',to_date('2018/09/01','YYYY-MM-DD'),to_date('2018/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('259','7','90000','7500.00',to_date('2018/09/01','YYYY-MM-DD'),to_date('2018/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('260','1','52000','4333.33',to_date('2018/10/01','YYYY-MM-DD'),to_date('2018/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('261','2','52000','4333.33',to_date('2018/10/01','YYYY-MM-DD'),to_date('2018/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('262','4','57000','4750.00',to_date('2018/10/01','YYYY-MM-DD'),to_date('2018/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('263','5','55000','4583.33',to_date('2018/10/01','YYYY-MM-DD'),to_date('2018/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('264','6','66000','5500.00',to_date('2018/10/01','YYYY-MM-DD'),to_date('2018/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('265','7','90000','7500.00',to_date('2018/10/01','YYYY-MM-DD'),to_date('2018/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('266','1','52000','4333.33',to_date('2018/11/01','YYYY-MM-DD'),to_date('2018/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('267','2','52000','4333.33',to_date('2018/11/01','YYYY-MM-DD'),to_date('2018/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('268','4','57000','4750.00',to_date('2018/11/01','YYYY-MM-DD'),to_date('2018/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('269','5','55000','4583.33',to_date('2018/11/01','YYYY-MM-DD'),to_date('2018/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('270','6','66000','5500.00',to_date('2018/11/01','YYYY-MM-DD'),to_date('2018/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('271','7','90000','7500.00',to_date('2018/11/01','YYYY-MM-DD'),to_date('2018/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('272','1','52000','4333.33',to_date('2018/12/01','YYYY-MM-DD'),to_date('2018/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('273','2','52000','4333.33',to_date('2018/12/01','YYYY-MM-DD'),to_date('2018/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('274','4','57000','4750.00',to_date('2018/12/01','YYYY-MM-DD'),to_date('2018/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('275','5','55000','4583.33',to_date('2018/12/01','YYYY-MM-DD'),to_date('2018/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('276','6','66000','5500.00',to_date('2018/12/01','YYYY-MM-DD'),to_date('2018/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('277','7','90000','7500.00',to_date('2018/12/01','YYYY-MM-DD'),to_date('2018/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('278','1','52000','4333.33',to_date('2019/01/01','YYYY-MM-DD'),to_date('2019/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('279','2','52000','4333.33',to_date('2019/01/01','YYYY-MM-DD'),to_date('2019/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('280','4','59000','4916.67',to_date('2019/01/01','YYYY-MM-DD'),to_date('2019/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('281','5','55000','4583.33',to_date('2019/01/01','YYYY-MM-DD'),to_date('2019/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('282','6','66000','5500.00',to_date('2019/01/01','YYYY-MM-DD'),to_date('2019/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('283','7','93000','7750.00',to_date('2019/01/01','YYYY-MM-DD'),to_date('2019/01/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('284','1','52000','4333.33',to_date('2019/02/01','YYYY-MM-DD'),to_date('2019/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('285','2','52000','4333.33',to_date('2019/02/01','YYYY-MM-DD'),to_date('2019/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('286','4','59000','4916.67',to_date('2019/02/01','YYYY-MM-DD'),to_date('2019/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('287','5','55000','4583.33',to_date('2019/02/01','YYYY-MM-DD'),to_date('2019/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('288','6','66000','5500.00',to_date('2019/02/01','YYYY-MM-DD'),to_date('2019/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('289','7','93000','7750.00',to_date('2019/02/01','YYYY-MM-DD'),to_date('2019/02/28','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('290','1','55000','4583.33',to_date('2019/03/01','YYYY-MM-DD'),to_date('2019/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('291','2','55000','4583.33',to_date('2019/03/01','YYYY-MM-DD'),to_date('2019/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('292','4','59000','4916.67',to_date('2019/03/01','YYYY-MM-DD'),to_date('2019/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('293','5','55000','4583.33',to_date('2019/03/01','YYYY-MM-DD'),to_date('2019/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('294','6','66000','5500.00',to_date('2019/03/01','YYYY-MM-DD'),to_date('2019/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('295','7','93000','7750.00',to_date('2019/03/01','YYYY-MM-DD'),to_date('2019/03/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('296','1','55000','4583.33',to_date('2019/04/01','YYYY-MM-DD'),to_date('2019/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('297','2','55000','4583.33',to_date('2019/04/01','YYYY-MM-DD'),to_date('2019/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('298','4','59000','4916.67',to_date('2019/04/01','YYYY-MM-DD'),to_date('2019/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('299','5','57000','4750.00',to_date('2019/04/01','YYYY-MM-DD'),to_date('2019/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('300','6','66000','5500.00',to_date('2019/04/01','YYYY-MM-DD'),to_date('2019/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('301','7','93000','7750.00',to_date('2019/04/01','YYYY-MM-DD'),to_date('2019/04/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('302','1','55000','4583.33',to_date('2019/05/01','YYYY-MM-DD'),to_date('2019/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('303','2','55000','4583.33',to_date('2019/05/01','YYYY-MM-DD'),to_date('2019/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('304','4','59000','4916.67',to_date('2019/05/01','YYYY-MM-DD'),to_date('2019/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('305','5','57000','4750.00',to_date('2019/05/01','YYYY-MM-DD'),to_date('2019/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('306','6','68000','5666.67',to_date('2019/05/01','YYYY-MM-DD'),to_date('2019/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('307','7','93000','7750.00',to_date('2019/05/01','YYYY-MM-DD'),to_date('2019/05/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('308','1','55000','4583.33',to_date('2019/06/01','YYYY-MM-DD'),to_date('2019/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('309','2','55000','4583.33',to_date('2019/06/01','YYYY-MM-DD'),to_date('2019/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('310','4','59000','4916.67',to_date('2019/06/01','YYYY-MM-DD'),to_date('2019/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('311','5','57000','4750.00',to_date('2019/06/01','YYYY-MM-DD'),to_date('2019/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('312','6','68000','5666.67',to_date('2019/06/01','YYYY-MM-DD'),to_date('2019/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('313','7','93000','7750.00',to_date('2019/06/01','YYYY-MM-DD'),to_date('2019/06/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('314','1','55000','4583.33',to_date('2019/07/01','YYYY-MM-DD'),to_date('2019/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('315','2','55000','4583.33',to_date('2019/07/01','YYYY-MM-DD'),to_date('2019/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('316','4','59000','4916.67',to_date('2019/07/01','YYYY-MM-DD'),to_date('2019/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('317','5','57000','4750.00',to_date('2019/07/01','YYYY-MM-DD'),to_date('2019/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('318','6','68000','5666.67',to_date('2019/07/01','YYYY-MM-DD'),to_date('2019/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('319','7','93000','7750.00',to_date('2019/07/01','YYYY-MM-DD'),to_date('2019/07/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('320','1','55000','4583.33',to_date('2019/08/01','YYYY-MM-DD'),to_date('2019/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('321','2','55000','4583.33',to_date('2019/08/01','YYYY-MM-DD'),to_date('2019/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('322','4','59000','4916.67',to_date('2019/08/01','YYYY-MM-DD'),to_date('2019/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('323','5','57000','4750.00',to_date('2019/08/01','YYYY-MM-DD'),to_date('2019/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('324','6','68000','5666.67',to_date('2019/08/01','YYYY-MM-DD'),to_date('2019/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('325','7','93000','7750.00',to_date('2019/08/01','YYYY-MM-DD'),to_date('2019/08/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('326','1','55000','4583.33',to_date('2019/09/01','YYYY-MM-DD'),to_date('2019/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('327','2','55000','4583.33',to_date('2019/09/01','YYYY-MM-DD'),to_date('2019/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('328','4','59000','4916.67',to_date('2019/09/01','YYYY-MM-DD'),to_date('2019/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('329','5','57000','4750.00',to_date('2019/09/01','YYYY-MM-DD'),to_date('2019/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('330','6','68000','5666.67',to_date('2019/09/01','YYYY-MM-DD'),to_date('2019/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('331','7','93000','7750.00',to_date('2019/09/01','YYYY-MM-DD'),to_date('2019/10/01','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('332','1','55000','4583.33',to_date('2019/10/01','YYYY-MM-DD'),to_date('2019/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('333','2','55000','4583.33',to_date('2019/10/01','YYYY-MM-DD'),to_date('2019/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('334','4','59000','4916.67',to_date('2019/10/01','YYYY-MM-DD'),to_date('2019/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('335','5','57000','4750.00',to_date('2019/10/01','YYYY-MM-DD'),to_date('2019/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('336','6','68000','5666.67',to_date('2019/10/01','YYYY-MM-DD'),to_date('2019/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('337','7','93000','7750.00',to_date('2019/10/01','YYYY-MM-DD'),to_date('2019/10/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('338','1','55000','4583.33',to_date('2019/11/01','YYYY-MM-DD'),to_date('2019/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('339','2','55000','4583.33',to_date('2019/11/01','YYYY-MM-DD'),to_date('2019/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('340','4','59000','4916.67',to_date('2019/11/01','YYYY-MM-DD'),to_date('2019/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('341','5','57000','4750.00',to_date('2019/11/01','YYYY-MM-DD'),to_date('2019/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('342','6','68000','5666.67',to_date('2019/11/01','YYYY-MM-DD'),to_date('2019/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('343','7','93000','7750.00',to_date('2019/11/01','YYYY-MM-DD'),to_date('2019/11/30','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('344','1','55000','4583.33',to_date('2019/12/01','YYYY-MM-DD'),to_date('2019/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('345','2','55000','4583.33',to_date('2019/12/01','YYYY-MM-DD'),to_date('2019/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('346','4','59000','4916.67',to_date('2019/12/01','YYYY-MM-DD'),to_date('2019/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('347','5','57000','4750.00',to_date('2019/12/01','YYYY-MM-DD'),to_date('2019/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('348','6','68000','5666.67',to_date('2019/12/01','YYYY-MM-DD'),to_date('2019/12/31','YYYY-MM-DD'));
INSERT INTO payroll (payroll_id, staff_id, salary, salary_payment, period_start_date, period_end_date) VALUES ('349','7','93000','7750.00',to_date('2019/12/01','YYYY-MM-DD'),to_date('2019/12/31','YYYY-MM-DD'));

/*COMMISSION TRACKER*/

INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('1','1','239','35.85','11');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('2','2','239','35.85','17');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('3','3','239','35.85','9');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('2','4','239','35.85','12');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('7','5','239','35.85','15');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('1','6','239','35.85','21');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('2','7','239','35.85','32');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('3','8','239','35.85','53');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('3','9','239','35.85','43');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('7','10','239','35.85','50');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('2','11','239','35.85','70');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('7','12','239','35.85','88');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('3','13','239','35.85','59');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('1','14','239','35.85','63');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('2','15','239','35.85','70');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('3','16','239','35.85','71');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('6','17','239','35.85','94');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('7','18','239','35.85','109');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('1','19','239','35.85','89');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('2','20','239','35.85','97');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('3','21','239','35.85','126');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('6','22','239','35.85','150');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('7','23','239','35.85','151');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('6','24','239','35.85','129');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('7','25','239','35.85','151');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('2','26','239','35.85','165');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('1','27','239','35.85','145');
INSERT INTO commission_tracker (staff_id, invoice_id, profit, commission, payroll_id) VALUES ('1','28','239','35.85','170');


/*PAYROLL MAP*/

INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('1','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('2','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('3','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('4','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('5','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('6','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('7','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('8','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('9','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('10','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('11','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('12','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('13','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('14','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('15','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('16','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('17','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('18','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('19','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('20','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('21','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('22','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('23','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('24','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('25','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('26','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('27','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('28','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('29','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('30','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('31','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('32','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('33','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('34','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('35','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('36','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('37','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('38','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('39','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('40','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('41','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('42','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('43','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('44','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('45','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('46','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('47','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('48','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('49','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('50','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('51','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('52','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('53','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('54','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('55','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('56','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('57','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('58','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('59','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('60','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('61','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('62','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('63','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('64','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('65','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('66','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('67','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('68','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('69','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('70','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('71','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('72','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('73','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('74','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('75','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('76','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('77','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('78','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('79','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('80','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('81','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('82','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('83','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('84','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('85','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('86','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('87','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('88','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('89','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('90','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('91','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('92','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('93','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('94','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('95','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('96','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('97','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('98','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('99','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('100','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('101','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('102','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('103','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('104','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('105','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('106','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('107','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('108','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('109','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('110','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('111','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('112','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('113','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('114','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('115','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('116','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('117','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('118','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('119','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('120','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('121','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('122','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('123','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('124','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('125','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('126','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('127','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('128','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('129','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('130','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('131','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('132','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('133','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('134','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('135','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('136','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('137','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('138','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('139','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('140','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('141','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('142','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('143','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('144','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('145','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('146','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('147','3');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('148','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('149','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('150','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('151','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('152','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('153','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('154','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('155','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('156','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('157','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('158','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('159','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('160','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('161','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('162','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('163','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('164','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('165','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('166','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('167','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('168','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('169','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('170','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('171','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('172','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('173','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('174','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('175','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('176','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('177','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('178','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('179','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('180','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('181','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('182','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('183','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('184','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('185','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('186','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('187','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('188','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('189','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('190','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('191','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('192','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('193','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('194','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('195','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('196','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('197','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('198','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('199','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('200','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('201','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('202','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('203','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('204','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('205','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('206','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('207','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('208','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('209','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('210','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('211','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('212','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('213','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('214','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('215','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('216','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('217','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('218','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('219','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('220','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('221','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('222','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('223','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('224','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('225','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('226','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('227','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('228','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('229','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('230','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('231','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('232','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('233','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('234','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('235','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('236','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('237','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('238','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('239','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('240','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('241','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('242','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('243','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('244','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('245','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('246','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('247','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('248','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('249','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('250','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('251','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('252','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('253','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('254','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('255','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('256','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('257','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('258','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('259','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('260','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('261','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('262','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('263','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('264','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('265','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('266','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('267','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('268','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('269','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('270','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('271','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('272','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('273','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('274','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('275','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('276','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('277','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('278','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('279','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('280','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('281','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('282','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('283','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('284','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('285','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('286','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('287','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('288','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('289','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('290','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('291','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('292','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('293','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('294','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('295','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('296','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('297','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('298','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('299','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('300','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('301','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('302','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('303','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('304','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('305','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('306','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('307','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('308','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('309','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('310','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('311','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('312','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('313','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('314','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('315','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('316','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('317','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('318','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('319','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('320','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('321','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('322','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('323','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('324','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('325','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('326','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('327','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('328','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('329','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('330','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('331','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('332','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('333','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('334','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('335','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('336','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('337','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('338','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('339','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('340','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('341','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('342','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('343','7');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('344','1');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('345','2');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('346','4');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('347','5');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('348','6');
INSERT INTO payroll_map (payroll_id, staff_id) VALUES ('349','7');

commit;
