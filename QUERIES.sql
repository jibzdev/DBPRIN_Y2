DECLARE @Yard_ID INT = 1;

WITH BoatyardInfo AS (
    SELECT
        Yard_ID,
        Yard_Name,
        Yard_Address,
        Yard_Postcode,
        Yard_City
    FROM
        Boatyard
    WHERE
        Yard_ID = @Yard_ID
)

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
    BoatyardInfo.Yard_ID AS Boatyard_ID,
    BoatyardInfo.Yard_Name AS Boatyard_Name,
    BoatyardInfo.Yard_Address,
    BoatyardInfo.Yard_Postcode,
    BoatyardInfo.Yard_City,
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
JOIN BoatyardInfo ON Boats.Yard_ID = BoatyardInfo.Yard_ID
JOIN Service ON Boats.Boat_ID = Service.Boat_ID
JOIN Customer ON Service.Customer_ID = Customer.Customer_ID
JOIN Service_Staff ON Service.Service_ID = Service_Staff.Service_ID
JOIN Staff ON Service_Staff.Staff_ID = Staff.Staff_ID
WHERE
    Service.Completed = False;