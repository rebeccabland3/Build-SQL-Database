
/*Sales invoice (report for one sales invoice, user enters sales invoice number)*/

select * from sales_invoices
where invoice_id = 2;

/*Sale Profit Report (report that shows how much money would be made if a proposed sale would take place).*/

select (c.price - c.car_cost) as expected_profit, car_id, make_description, car_model
from cars c
join car_makers cm on cm.make_id = c.make_id
where is_sold = "no"
and for_servicing = "no"
and car_id = 35;

/*Service Work Order (report for one work order user enters work order number)*/

select make_description, car_model, service_invoice_id, service_job_id, service_price, staff_id from 
    (
    select c.f_name, c.l_name, make_description, car_model, service_invoice_id, sj.service_job_id, service_price, sf.staff_id
    from service_jobs sj
    join service_invoices si on si.service_job_id = sj.service_job_id
    join services s on s.service_id = si.service_id
    join customers c on c.customer_id = si.customer_id
    join staff sf on sf.staff_id = sj.staff_id
    join cars on cars.car_id = sj.car_id
    join car_makers cm on cm.make_id = cars.make_id
    )
where service_job_id = 5;

/*Purchase order (report for one purchase, user enters purchase order number).*/

select * from PO_out
where PO_id_out = 16;

/*List of all vehicles for sale.*/

select * from cars
where is_sold = 'no'
and for_servicing = 'no';

/*List of customers who are interested in a specific make of a vehicle (user enters make of vehicle).*/

select * from customers c
join customer_preference_map cpm on cpm.customer_id= c.customer_id
join customer_preferences cp on cp.preference_id = cpm.preference_id
join car_makers cm on cm.make_id = cp.preference_id
join cars on cars.make_id = cm.make_id
where make_description = 'Ford';
/*List of vehicles that need servicing for a specific service (user enters type of service).*/

select * from cars
join service_jobs sj on sj.car_id = cars.car_id
join service_invoices si on si.service_job_id = sj.service_job_id
join services s on s.service_id = si.service_id
where requires_servicing = 'yes'
and service_description = 'engine service';

/*List of all vehicles that have been sold this month (user enters month) along with the profit earned by each vehicle and the commission paid to the sales person.*/

select car_id, make_id, car_model, (c.price - car_cost) as sale_profit, commission from cars c
join inventory_sales_tracker ist on ist.car_id = c.car_id
join po_in pi on pi.PO_id_in = ist.PO_id_in
join sales_invoices si on si.PO_id_in = pi.PO_id_in
join commission_tracker ct on ct.invoice_id = si.invoice_id
where is_sold = 'yes'
and extract(month from sell_date) = 12;

/*A list of all profits (revenues less expenses) for all services performed where the profits are grouped by service.*/

select service_description, (service_price-service_cost) as profits_from_service 
from services;
/*List of best “Sales Person”
    i. 	Highest commissions*/
    
select distinct(staff_id), commission 
from commission_tracker
order by commission desc;

    /*ii. 	Largest number of vehicles sold*/

select distinct(preparer_id), s.f_name, s.l_name, count(car_id) as num_cars_sold
from PO_in 
join staff s on s.staff_id = po_in.preparer_id
group by preparer_id, s.f_name, s.l_name
order by num_cars_sold desc;

/*List of customers who have purchased a car but have not had this car serviced with us.*/

select * from customers c
join PO_in pi on pi.customer_id = c.customer_id
join inventory_sales_tracker ist on ist.PO_id_in = pi.PO_id_in
join cars on cars.car_id = ist.car_id
where for_servicing = 'no';

/*A list of all customers who have purchased a vehicle from us.*/

select * from customers c
join PO_in pi on pi.customer_id = c.customer_id
join inventory_sales_tracker ist on ist.PO_id_in = pi.PO_id_in
join cars on cars.car_id = ist.car_id
where for_servicing = 'no';
