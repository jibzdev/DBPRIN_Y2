-- Query 1
-- Select All Services that are uncompleted, List all boat details and issues along side it.

SELECT
    Boats.Boat_ID,
    Boats.Boat_Name,
    Boats.Build_Date,
    Boats.Boat_Class,
    Boats.Boat_Hull_Design,
    Boats.Boat_Dimensions,
    Boats.Boat_Propulsion,
    Boats.Fuel_Type,
    Boats.Boat_Capacity,
    Boats.Boat_Registration,
    Boats.Boat_History,
    Boats.Boat_Type,
    Boatyard.Yard_ID AS Boatyard_ID,
    Boatyard.Yard_Name AS Boatyard_Name,
    Boatyard.Yard_Address,
    Boatyard.Yard_Postcode,
    Boatyard.Yard_City,
    Service.Service_ID,
    Service.Service_Date,
    Service.Service_Details,
    Service.Completed,
    Service.Emergency_Service,
    Customer.Customer_ID,
    Customer.Customer_FName,
    Customer.Customer_LName,
    Staff.Staff_ID,
    Staff.Staff_FName,
    Staff.Staff_LName,
    Staff.Date_Of_Employment
FROM
    Boats
JOIN Boatyard ON Boats.Yard_ID = Boatyard.Yard_ID
JOIN Service ON Boats.Boat_ID = Service.Boat_ID
JOIN Customer ON Service.Customer_ID = Customer.Customer_ID
JOIN Service_Staff ON Service.Service_ID = Service_Staff.Service_ID
JOIN Staff ON Service_Staff.Staff_ID = Staff.Staff_ID
WHERE
    Service.Completed = False;


-- Query 2
-- Find all Facilites that are available for Services (IE: not been booked for any services)
SELECT 
    Facilities.Facility_ID,
    Facilities.Facility_Name,
    Facilities.Facility_Details,
    Boatyard.Yard_Name
FROM 
    Facilities
JOIN 
    Facilities_Boatyard ON Facilities.Facility_ID = Facilities_Boatyard.Facility_ID
JOIN 
    Boatyard ON Facilities_Boatyard.Yard_ID = Boatyard.Yard_ID
WHERE 
    Facilities.Facility_ID NOT IN (
        SELECT DISTINCT 
            Facilities.Facility_ID
        FROM 
            Facilities_Boatyard
        JOIN 
            Booking ON Facilities_Boatyard.Yard_ID = Booking.Customer_ID
        JOIN 
            Service ON Booking.Service_ID = Service.Service_ID
        JOIN 
            Facilities ON Facilities_Boatyard.Facility_ID = Facilities.Facility_ID
    )
AND 
    Boatyard.Yard_ID = 7; -- <-- The yard ID Range 1,17