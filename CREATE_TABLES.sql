CREATE TYPE Emergency_T AS ENUM('Staff', 'Customer');
CREATE TABLE Emergency_Contact(
    Emergency_ID SERIAL PRIMARY KEY NOT NULL,
    Emergency_Type Emergency_T,
    Emergency_FName VARCHAR(50) NOT NULL,
    Emergency_LName VARCHAR(50) NOT NULL,
    Emergency_Phone VARCHAR(20) NOT NULL,
    Emergency_Email VARCHAR(50) NOT NULL,
    Emergency_Address VARCHAR(50) NOT NULL,
    Emergency_Postcode VARCHAR(50) NOT NULL,
    Emergency_City VARCHAR(50) NOT NULL
);

CREATE TYPE Customer_T AS ENUM('Company', 'Individual');
CREATE TABLE Customer(
    Customer_ID SERIAL PRIMARY KEY NOT NULL,
    Customer_FName VARCHAR(35) NOT NULL,
    Customer_LName VARCHAR(35) NOT NULL,
    Customer_DOB DATE NOT NULL,
    Customer_Email VARCHAR(100) NOT NULL,
    Customer_Phone VARCHAR(25) NOT NULL,
    Customer_Address VARCHAR(100) NOT NULL,
    Customer_Postcode VARCHAR(10) NOT NULL,
    Customer_City VARCHAR(30) NOT NULL,
    Customer_Type Customer_T,
    Emergency_ID INT REFERENCES Emergency_Contact(Emergency_ID) NOT NULL
);

CREATE TABLE Country(
    Country_ID SERIAL PRIMARY KEY NOT NULL,
    Country_Name VARCHAR(35) NOT NULL
);

CREATE TABLE Boatyard(
    Yard_ID SERIAL PRIMARY KEY NOT NULL,
    Yard_Name VARCHAR(35) NOT NULL,
    Yard_Address VARCHAR(100) NOT NULL,
    Yard_Postcode VARCHAR(10) NOT NULL,
    Yard_City VARCHAR(30) NOT NULL,
    Yard_Size VARCHAR(50),
    Country_ID INT REFERENCES Country(Country_ID) NOT NULL
);

CREATE TABLE Staff(
    Staff_ID SERIAL PRIMARY KEY NOT NULL,
    Staff_FName VARCHAR(35) NOT NULL,
    Staff_LName VARCHAR(35) NOT NULL,
    Staff_DOB DATE NOT NULL,
    Staff_Email VARCHAR(100) NOT NULL,
    Staff_Phone VARCHAR(20) NOT NULL,
    Staff_Address VARCHAR(100) NOT NULL,
    Staff_Postcode VARCHAR(10) NOT NULL,
    Staff_City VARCHAR(30) NOT NULL,
    Date_Of_Employment DATE NOT NULL,
    Yard_ID INT REFERENCES Boatyard(Yard_ID) NOT NULL,
    Emergency_ID INT REFERENCES Emergency_Contact(Emergency_ID) NOT NULL
);

CREATE TABLE Role(
    Role_ID SERIAL PRIMARY KEY NOT NULL,
    Role_Name VARCHAR(25) NOT NULL,
    Role_Description VARCHAR(250) NOT NULL
);

CREATE TABLE Staff_Role(
    Staff_ID INT REFERENCES Staff(Staff_ID) NOT NULL,
    Role_ID INT REFERENCES Role(Role_ID) NOT NULL
);

CREATE TYPE Boat_T AS ENUM('Commercial', 'Private');
CREATE TABLE Boats (
    Boat_ID SERIAL PRIMARY KEY,
    Boat_Name VARCHAR(50) NOT NULL,
    Build_Date DATE NOT NULL,
    Boat_Class VARCHAR(50) NOT NULL,
    Boat_Hull_Design VARCHAR(150) NOT NULL,
    Boat_Dimensions VARCHAR(50) NOT NULL,
    Boat_Propulsion VARCHAR(50) NOT NULL,
    Fuel_Type VARCHAR(15) NOT NULL,
    Boat_Capacity INT NOT NULL,
    Boat_Registration VARCHAR(50),
    Boat_History VARCHAR(250) NOT NULL,
    Boat_Type Boat_T,
    Yard_ID INT REFERENCES Boatyard(Yard_ID) NOT NULL,
    Customer_ID INT REFERENCES Customer(Customer_ID) NOT NULL
);

CREATE TABLE Facilities(
    Facility_ID SERIAL PRIMARY KEY NOT NULL,
    Facility_Name VARCHAR(50) NOT NULL,
    Facility_Details VARCHAR(250) NOT NULL
);

CREATE TABLE Facilities_Boatyard(
    Facility_ID INT REFERENCES Facilities(Facility_ID) NOT NULL,
    Yard_ID INT REFERENCES Boatyard(Yard_ID) NOT NULL
);

CREATE TABLE Parts(
    Part_ID SERIAL PRIMARY KEY NOT NULL,
    Part_Name VARCHAR(50) NOT NULL,
    Part_Description VARCHAR(250) NOT NULL
);

CREATE TABLE Service(
    Service_ID SERIAL PRIMARY KEY NOT NULL,
    Service_Date DATE NOT NULL,
    Service_Details VARCHAR(250) NOT NULL,
    Completed BOOLEAN NOT NULL,
    Emergency_Service BOOLEAN NOT NULL,
    Customer_ID INT REFERENCES Customer(Customer_ID) NOT NULL,
    Part_ID INT REFERENCES Parts(Part_ID) NOT NULL,
    Boat_ID INT REFERENCES Boats(Boat_ID) NOT NULL
);

CREATE TABLE Booking(
    Booking_ID SERIAL PRIMARY KEY NOT NULL,
    Booking_Date DATE NOT NULL,
    Service_ID INT REFERENCES Service(Service_ID) NOT NULL,
    Customer_ID INT REFERENCES Customer(Customer_ID) NOT NULL
);

CREATE TABLE Service_Staff(
    Service_ID INT REFERENCES Service(Service_ID) NOT NULL,
    Staff_ID INT REFERENCES Staff(Staff_ID) NOT NULL,
    Service_Description VARCHAR(250) NOT NULL,
    Yard_ID INT REFERENCES Boatyard(Yard_ID) NOT NULL
);