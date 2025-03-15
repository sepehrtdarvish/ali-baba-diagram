CREATE TABLE User (
    id UUID PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    signup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);


CREATE TABLE Profile (
    id UUID PRIMARY KEY,
    user UUID UNIQUE NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    full_name VARCHAR(50),
    home_town VARCHAR(30),
    phone_number VARCHAR(20)
);

CREATE TABLE Report (
    id UUID PRIMARY KEY,
    subject VARCHAR(50) CHECK (subject IN ('Payments', 'Tickets', 'Delays', 'Other')),
    description TEXT NOT NULL,
    document UUID DEFAULT NULL REFERENCES Document(id) ON DELETE SET NULL,
    user_id UUID NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    inspector UUID NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    is_processed BOOLEAN DEFAULT FALSE,
    processed_at BOOLEAN DEFAULT FALSE,
    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Document (
    id UUID PRIMARY KEY,
    file VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user UUID NOT NULL REFERENCES User(id) ON DELETE CASCADE
);

CREATE TABLE Vehicle (
    id UUID PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    vehicle_type VARCHAR(20) CHECK (vehicle_type IN ('Train', 'Airplane', 'Bus'))
);

CREATE TABLE Train (
    id UUID PRIMARY KEY,
    train_services UUID NOT NULL REFERENCES TrainServices(id) ON DELETE CASCADE,
    star_number INT NOT NULL CHECK (3 <= star_number AND star_number <= 5),
    private_campartment BOOLEAN,
    FOREIGN KEY (id) REFERENCES Vehicle(id) ON DELETE CASCADE
);
CREATE TABLE TrainServices (
    id UUID PRIMARY KEY,
    flatbed_wagon BOOLEAN DEFAULT FALSE,
    catering_services BOOLEAN DEFAULT FALSE,
    wifi_access BOOLEAN DEFAULT FALSE,
    air_conditioning BOOLEAN DEFAULT FALSE
);

CREATE TABLE Airplane (
    id UUID PRIMARY KEY,
    airplane_services UUID NOT NULL REFERENCES AirplaneServices(id) ON DELETE CASCADE,
    flight_number INT UNIQUE NOT NULL,
    flight_class VARCHAR(50) CHECK (flight_class IN ('Economy', 'Business', 'FirstClass')),
    FOREIGN KEY (id) REFERENCES Vehicle(id) ON DELETE CASCADE
);
CREATE TABLE AirplaneServices (
    id UUID PRIMARY KEY,
    catering_services BOOLEAN DEFAULT FALSE,
    wifi_access BOOLEAN DEFAULT FALSE,
    bedable_seats BOOLEAN DEFAULT FALSE
);

CREATE TABLE Bus (
    id UUID PRIMARY KEY,
    bus_services UUID NOT NULL REFERENCES BusServices(id) ON DELETE CASCADE,
    bus_type VARCHAR(50) CHECK (bus_type IN ('VIP', 'Normal', 'Sleepable')),
    seat_kind VARCHAR(50) CHECK (seat_kind IN ('1+1', '2+1')),
    FOREIGN KEY (id) REFERENCES Vehicle(id) ON DELETE CASCADE
);
CREATE TABLE BusServices (
    id UUID PRIMARY KEY,
    catering_services BOOLEAN DEFAULT FALSE,
    individual_screen BOOLEAN DEFAULT FALSE,
    air_conditioning BOOLEAN DEFAULT FALSE
);



