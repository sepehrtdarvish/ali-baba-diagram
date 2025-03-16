
-- USE alibaba_db;
-- SHOW Tables;
-- describe Report;
-- USE alibaba_db;
CREATE TABLE User (
    id INTEGER PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    signup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);


CREATE TABLE Profile (
    id INTEGER PRIMARY KEY,
    user INTEGER UNIQUE NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    full_name VARCHAR(50),
    home_town VARCHAR(30),
    phone_number VARCHAR(20)
);

CREATE TABLE Report (
    id INTEGER PRIMARY KEY,
    subject VARCHAR(50) CHECK (subject IN ('Payments', 'Tickets', 'Delays', 'Other')),
    description TEXT NOT NULL,
    document INTEGER DEFAULT NULL REFERENCES Document(id) ON DELETE SET NULL,
    user_id INTEGER NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    inspector INTEGER NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    is_processed BOOLEAN DEFAULT FALSE,
    processed_at BOOLEAN DEFAULT FALSE,
    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Document (
    id INTEGER PRIMARY KEY,
    file VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user INTEGER NOT NULL REFERENCES User(id) ON DELETE CASCADE
);

CREATE TABLE Ticket (
    id INTEGER PRIMARY KEY,
    origin INTEGER NOT NULL REFERENCES Location(id) ON DELETE CASCADE,
    destination INTEGER NOT NULL REFERENCES Location(id) ON DELETE CASCADE,
    price FLOAT CHECK (price > 0),
    start_at TIMESTAMP NOT NULL,
    duration INT NOT NULL,
    delay INT DEFAULT NULL,
    class VARCHAR(20) CHECK (class IN ('economic', 'VIP', 'business')),
    capacity INT NOT NULL CHECK (capacity > 0),
    vehicle_type INTEGER NOT NULL REFERENCES Vehicle(id) ON DELETE CASCADE,
    stops INT DEFAULT NULL
);
CREATE TABLE Reservation (
    id INTEGER PRIMARY KEY,
    user INTEGER NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    ticket INTEGER NOT NULL REFERENCES Ticket(id) ON DELETE CASCADE,
    transaction INTEGER DEFAULT NULL REFERENCES Transaction(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_cancelled BOOLEAN DEFAULT FALSE,
    has_paid BOOLEAN DEFAULT FALSE,
    expiration_date TIMESTAMP DEFAULT NULL
);

CREATE TABLE Transaction (
    id INTEGER PRIMARY KEY,
    card_number VARCHAR(16) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    paid_amount INT NOT NULL CHECK (paid_amount >= 0),
    tracking_code VARCHAR(50) UNIQUE NOT NULL,
    success BOOLEAN DEFAULT FALSE,
    payment_method VARCHAR(50) NOT NULL
);

CREATE TABLE Vehicle (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    vehicle_type VARCHAR(20) CHECK (vehicle_type IN ('Train', 'Airplane', 'Bus'))
);

CREATE TABLE Train (
    id INTEGER PRIMARY KEY,
    train_services INTEGER NOT NULL REFERENCES TrainServices(id) ON DELETE CASCADE,
    star_number INT NOT NULL CHECK (3 <= star_number AND star_number <= 5),
    private_campartment BOOLEAN,
    FOREIGN KEY (id) REFERENCES Vehicle(id) ON DELETE CASCADE
);
CREATE TABLE TrainServices (
    id INTEGER PRIMARY KEY,
    flatbed_wagon BOOLEAN DEFAULT FALSE,
    catering_services BOOLEAN DEFAULT FALSE,
    wifi_access BOOLEAN DEFAULT FALSE,
    air_conditioning BOOLEAN DEFAULT FALSE
);

CREATE TABLE Airplane (
    id INTEGER PRIMARY KEY,
    airplane_services INTEGER NOT NULL REFERENCES AirplaneServices(id) ON DELETE CASCADE,
    flight_number INT UNIQUE NOT NULL,
    flight_class VARCHAR(50) CHECK (flight_class IN ('Economy', 'Business', 'FirstClass')),
    FOREIGN KEY (id) REFERENCES Vehicle(id) ON DELETE CASCADE
);
CREATE TABLE AirplaneServices (
    id INTEGER PRIMARY KEY,
    catering_services BOOLEAN DEFAULT FALSE,
    wifi_access BOOLEAN DEFAULT FALSE,
    bedable_seats BOOLEAN DEFAULT FALSE
);

CREATE TABLE Bus (
    id INTEGER PRIMARY KEY,
    bus_services INTEGER NOT NULL REFERENCES BusServices(id) ON DELETE CASCADE,
    bus_type VARCHAR(50) CHECK (bus_type IN ('VIP', 'Normal', 'Sleepable')),
    seat_kind VARCHAR(50) CHECK (seat_kind IN ('1+1', '2+1')),
    FOREIGN KEY (id) REFERENCES Vehicle(id) ON DELETE CASCADE
);
CREATE TABLE BusServices (
    id INTEGER PRIMARY KEY,
    catering_services BOOLEAN DEFAULT FALSE,
    individual_screen BOOLEAN DEFAULT FALSE,
    air_conditioning BOOLEAN DEFAULT FALSE
);



