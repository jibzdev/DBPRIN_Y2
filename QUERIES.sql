-- Query 1
-- Find the top 10 staff members who have completed the most services.

WITH StaffServiceCounts AS (
    SELECT
        Staff.Staff_ID,
        Staff.Staff_FName,
        Staff.Staff_LName,
        COUNT(Service.Service_ID) AS ServiceCount
    FROM
        Staff
    LEFT JOIN Service_Staff ON Staff.Staff_ID = Service_Staff.Staff_ID
    LEFT JOIN Service ON Service_Staff.Service_ID = Service.Service_ID
    GROUP BY
        Staff.Staff_ID, Staff.Staff_FName, Staff.Staff_LName
)

SELECT
    StaffServiceCounts.Staff_ID,
    StaffServiceCounts.Staff_FName,
    StaffServiceCounts.Staff_LName,
    StaffServiceCounts.ServiceCount
FROM
    StaffServiceCounts
ORDER BY
    StaffServiceCounts.ServiceCount DESC
LIMIT 10; 

-- Query 2
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

-- Query 3
-- This will analyse services at facilities to determine the demand of facilities

SELECT
    Facilities.Facility_ID,
    Facilities.Facility_Name,
    COUNT(Booking.Booking_ID) AS BookingCount
FROM
    Facilities
LEFT JOIN Facilities_Boatyard ON Facilities.Facility_ID = Facilities_Boatyard.Facility_ID
LEFT JOIN Booking ON Facilities_Boatyard.Yard_ID = Booking.Customer_ID
GROUP BY
    Facilities.Facility_ID, Facilities.Facility_Name
ORDER BY
    BookingCount DESC;



-- Query 4
-- The main query then retrieves additional details, such as the boat ID of the latest serviced boat.
-- This information can be valuable for understanding customer engagement and the most recent interactions with your services.
WITH CustomerServiceStats AS (
    SELECT
        Customer.Customer_ID,
        Customer.Customer_FName,
        Customer.Customer_LName,
        COUNT(DISTINCT Booking.Booking_ID) AS TotalBookings,
        MAX(Service.Service_Date) AS LatestServiceDate
    FROM
        Customer
    LEFT JOIN Booking ON Customer.Customer_ID = Booking.Customer_ID
    LEFT JOIN Service ON Booking.Service_ID = Service.Service_ID
    GROUP BY
        Customer.Customer_ID, Customer.Customer_FName, Customer.Customer_LName
)

SELECT
    CustomerServiceStats.Customer_ID,
    CustomerServiceStats.Customer_FName,
    CustomerServiceStats.Customer_LName,
    CustomerServiceStats.TotalBookings,
    CustomerServiceStats.LatestServiceDate,
    Boats.Boat_ID AS LatestServicedBoat
FROM
    CustomerServiceStats
LEFT JOIN Booking ON CustomerServiceStats.Customer_ID = Booking.Customer_ID
LEFT JOIN Service ON Booking.Service_ID = Service.Service_ID
LEFT JOIN Boats ON Service.Boat_ID = Boats.Boat_ID
WHERE
    Service.Service_Date = CustomerServiceStats.LatestServiceDate
ORDER BY
    CustomerServiceStats.TotalBookings DESC
LIMIT 5;

-- Query 5
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