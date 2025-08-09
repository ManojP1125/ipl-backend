-- ===========================================================
-- IPL 2025 — Full DB DDL + realistic seed data
-- Single file: create DB, tables, and populate with data
-- Paste into pgAdmin Query Tool and execute (F5)
-- ===========================================================

-- -------- Create database (skip if you already created manually) ----------
DROP DATABASE IF EXISTS ipl_management;
CREATE DATABASE ipl_management;
-- In pgAdmin, you may need to select the new database before running the rest.
\c ipl_management;

-- ------------------------------
-- 1) Tables (DDL) - dependency safe order
-- ------------------------------

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL, -- ADMIN / USER
    enabled BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE stadiums (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    seating_capacity INT,
    inauguration_date DATE,
    photo_url TEXT
);

CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    short_name VARCHAR(20),
    logo_url TEXT,
    owner VARCHAR(200),
    home_stadium_id INT REFERENCES stadiums(id) ON DELETE SET NULL,
    city VARCHAR(100)
);

CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    full_name VARCHAR(200),
    nationality VARCHAR(100),
    player_type VARCHAR(50), -- BATSMAN,BOWLER,ALLROUNDER,WICKETKEEPER
    batting_style VARCHAR(100),
    bowling_style VARCHAR(100),
    matches INT DEFAULT 0,
    innings INT DEFAULT 0,
    runs INT DEFAULT 0,
    wickets INT DEFAULT 0,
    fifties INT DEFAULT 0,
    hundreds INT DEFAULT 0,
    strike_rate NUMERIC(6,2),
    average NUMERIC(6,2),
    photo_url TEXT,
    team_id INT REFERENCES teams(id) ON DELETE SET NULL
);

CREATE TABLE umpires (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    nationality VARCHAR(100),
    experience_years INT,
    photo_url TEXT
);

CREATE TABLE referees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    nationality VARCHAR(100),
    experience_years INT,
    photo_url TEXT
);

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    scheduled_at TIMESTAMP NOT NULL,
    stadium_id INT REFERENCES stadiums(id) ON DELETE SET NULL,
    team_a_id INT REFERENCES teams(id) ON DELETE CASCADE,
    team_b_id INT REFERENCES teams(id) ON DELETE CASCADE,
    umpire1_id INT REFERENCES umpires(id) ON DELETE SET NULL,
    umpire2_id INT REFERENCES umpires(id) ON DELETE SET NULL,
    referee_id INT REFERENCES referees(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'SCHEDULED',
    result TEXT
);

-- Optional join table: match_players if you want to store playing XI
CREATE TABLE match_players (
    match_id INT REFERENCES matches(id) ON DELETE CASCADE,
    player_id INT REFERENCES players(id) ON DELETE CASCADE,
    team_id INT REFERENCES teams(id) ON DELETE CASCADE,
    role_in_match VARCHAR(50), -- e.g., STARTING, SUB
    PRIMARY KEY (match_id, player_id)
);

-- ------------------------------
-- 2) Insert Stadiums (10 stadiums)
-- ------------------------------
INSERT INTO stadiums (name, city, state, seating_capacity, inauguration_date, photo_url) VALUES
('Wankhede Stadium', 'Mumbai', 'Maharashtra', 33000, '1975-01-01', 'https://example.com/stadiums/wankhede.jpg'),
('M. A. Chidambaram Stadium (Chepauk)', 'Chennai', 'Tamil Nadu', 38000, '1916-01-01', 'https://example.com/stadiums/chepauk.jpg'),
('M. Chinnaswamy Stadium', 'Bengaluru', 'Karnataka', 40000, '1969-01-01', 'https://example.com/stadiums/chinnaswamy.jpg'),
('Eden Gardens', 'Kolkata', 'West Bengal', 68000, '1864-01-01', 'https://example.com/stadiums/edengardens.jpg'),
('Rajiv Gandhi Intl. Cricket Stadium', 'Hyderabad', 'Telangana', 55000, '2003-01-01', 'https://example.com/stadiums/rajiv_gandhi.jpg'),
('Ekana Cricket Stadium', 'Lucknow', 'Uttar Pradesh', 50000, '2017-01-01', 'https://example.com/stadiums/ekana.jpg'),
('Sawai Mansingh Stadium', 'Jaipur', 'Rajasthan', 30000, '1969-01-01', 'https://example.com/stadiums/sawai_mansingh.jpg'),
('Punjab Cricket Association IS Bindra Stadium', 'Mohali', 'Punjab', 26000, '1993-01-01', 'https://example.com/stadiums/pca_mohali.jpg'),
('Arun Jaitley Stadium', 'Delhi', 'Delhi', 41800, '1976-01-01', 'https://example.com/stadiums/arun_jaitley.jpg'),
('Narendra Modi Stadium', 'Ahmedabad', 'Gujarat', 132000, '2020-01-01', 'https://example.com/stadiums/narendra_modi.jpg');

-- ------------------------------
-- 3) Insert Teams (10 IPL teams - refer to stadium ids above)
-- ------------------------------
INSERT INTO teams (name, short_name, logo_url, owner, home_stadium_id, city) VALUES
('Mumbai Indians', 'MI', 'https://example.com/logos/mi.png', 'Indiawin Sports Pvt Ltd (Mukesh Ambani)', 1, 'Mumbai'),
('Chennai Super Kings', 'CSK', 'https://example.com/logos/csk.png', 'Chennai Super Kings Cricket Ltd (N. Srinivasan)', 2, 'Chennai'),
('Royal Challengers Bangalore', 'RCB', 'https://example.com/logos/rcb.png', 'United Spirits', 3, 'Bengaluru'),
('Kolkata Knight Riders', 'KKR', 'https://example.com/logos/kkr.png', 'Shahrukh Khan (Red Chillies VC)', 4, 'Kolkata'),
('Sunrisers Hyderabad', 'SRH', 'https://example.com/logos/srh.png', 'Sun TV Network', 5, 'Hyderabad'),
('Lucknow Super Giants', 'LSG', 'https://example.com/logos/lsg.png', 'RPSG Ventures', 6, 'Lucknow'),
('Rajasthan Royals', 'RR', 'https://example.com/logos/rr.png', 'Rajasthan Royals Sports Pvt Ltd', 7, 'Jaipur'),
('Punjab Kings', 'PBKS', 'https://example.com/logos/pbks.png', 'Mohit Burman, Preity Zinta & others', 8, 'Mohali'),
('Delhi Capitals', 'DC', 'https://example.com/logos/dc.png', 'GMR Group & JSW', 9, 'Delhi'),
('Gujarat Titans', 'GT', 'https://example.com/logos/gt.png', 'Gujarat Cricket Association', 10, 'Ahmedabad');

-- ------------------------------
-- 4) Insert Players (11 per team - plausible roles; 110 players)
-- Note: match realistic squads roughly; stats are plausible placeholders.
-- ------------------------------

-- Mumbai Indians (team_id = 1)
INSERT INTO players (first_name, last_name, full_name, nationality, player_type, batting_style, bowling_style, matches, innings, runs, wickets, fifties, hundreds, strike_rate, average, photo_url, team_id) VALUES
('Rohit','Sharma','Rohit Sharma','India','BATSMAN','Right-hand bat',NULL,250,240,6000,0,45,10,135.50,32.75,'',1),
('Ishan','Kishan','Ishan Kishan','India','WICKETKEEPER','Left-hand bat',NULL,90,85,2400,0,15,2,140.10,28.24,'',1),
('Tilak','Varma','Tilak Varma','India','BATSMAN','Left-hand bat',NULL,25,20,400,0,2,0,125.00,22.22,'',1),
('Suryakumar','Yadav','Suryakumar Yadav','India','BATSMAN','Right-hand bat',NULL,120,115,3400,0,25,5,155.80,34.15,'',1),
('Jasprit','Bumrah','Jasprit Bumrah','India','BOWLER','Right-hand bat','Right-arm fast',150,140,500,150,0,0,120.00,18.00,'',1),
('Tim','David','Tim David','Australia','BATSMAN','Right-hand bat',NULL,35,30,800,0,6,1,165.00,30.76,'',1),
('Kieron','Pollard','Kieron Pollard','West Indies','ALLROUNDER','Right-hand bat','Right-arm medium',200,190,3500,150,50,2,145.00,29.57,'',1),
('Brett','Lee','Brett Lee','Australia','BOWLER','Right-hand bat','Right-arm fast',0,0,0,0,0,0,0,0.0,'',1), -- placeholder retired / example
('Nehal','Waris','Nehal Waris','India','ALLROUNDER','Right-hand bat','Right-arm offbreak',10,9,120,5,0,0,120.00,20.00,'',1),
('Daniel','Sams','Daniel Sams','Australia','BOWLER','Right-hand bat','Right-arm fast-medium',90,85,400,85,0,0,125.00,18.20,'',1),
('Arshad','Khan','Arshad Khan','India','BOWLER','Left-hand bat','Left-arm orthodox',30,28,150,40,0,0,95.00,12.50,'',1);

-- Chennai Super Kings (team_id = 2)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Ruturaj','Gaikwad','Ruturaj Gaikwad','India','BATSMAN','Right-hand bat',NULL,80,78,2500,0,18,3,130.00,33.33,'',2),
('Devon','Conway','Devon Conway','New Zealand','BATSMAN','Left-hand bat',NULL,25,24,950,0,6,2,150.00,47.50,'',2),
('Shivam','Dube','Shivam Dube','India','ALLROUNDER','Right-hand bat','Right-arm medium',70,60,1400,30,6,0,140.00,28.00,'',2),
('MS','Dhoni','MS Dhoni','India','WICKETKEEPER','Right-hand bat',NULL,260,250,4500,0,25,3,130.00,35.00,'',2),
('Matheesha','Pathirana','Matheesha Pathirana','Sri Lanka','BOWLER','Right-hand bat','Right-arm fast',40,38,50,45,0,0,120.00,5.00,'',2),
('Daryl','Mitchell','Daryl Mitchell','New Zealand','ALLROUNDER','Left-hand bat','Right-arm medium',30,28,700,12,4,0,135.00,29.16,'',2),
('Simarjeet','Singh','Simarjeet Singh','India','BOWLER','Right-hand bat','Right-arm medium',12,10,30,18,0,0,110.00,7.50,'',2),
('Ravindra','Jadeja','Ravindra Jadeja','India','ALLROUNDER','Left-hand bat','Left-arm orthodox',180,170,2300,210,12,0,110.00,28.20,'',2),
('Ambati','Rayudu','Ambati Rayudu','India','BATSMAN','Right-hand bat',NULL,100,95,2400,0,12,1,125.00,25.26,'',2),
('Tushar','Deshpande','Tushar Deshpande','India','BOWLER','Right-hand bat','Right-arm fast-medium',20,18,10,18,0,0,110.00,3.33,'',2),
('Dwayne','Bravo','Dwayne Bravo','West Indies','ALLROUNDER','Right-hand bat','Right-arm medium',200,190,3000,180,40,1,135.00,26.50,'',2);

-- Royal Challengers Bangalore (team_id = 3)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Virat','Kohli','Virat Kohli','India','BATSMAN','Right-hand bat',NULL,250,240,7500,0,60,27,135.00,45.50,'',3),
('Faf','du Plessis','Faf du Plessis','South Africa','BATSMAN','Right-hand bat',NULL,150,140,4200,0,30,8,130.00,35.00,'',3),
('Glenn','Maxwell','Glenn Maxwell','Australia','ALLROUNDER','Right-hand bat','Right-arm offbreak',200,180,4000,120,20,2,150.00,30.00,'',3),
('Mohammed','Siraj','Mohammed Siraj','India','BOWLER','Right-hand bat','Right-arm fast-medium',80,78,200,110,0,0,120.00,18.50,'',3),
('Dinesh','Karthik','Dinesh Karthik','India','WICKETKEEPER','Right-hand bat',NULL,200,190,3500,0,20,3,130.00,23.50,'',3),
('Shahbaz','Ahmed','Shahbaz Ahmed','India','ALLROUNDER','Left-hand bat','Right-arm offbreak',50,45,600,25,3,0,125.00,20.00,'',3),
('Harshal','Patel','Harshal Patel','India','BOWLER','Right-hand bat','Right-arm fast-medium',90,80,150,110,0,0,120.00,20.00,'',3),
('Anuj','Rawat','Anuj Rawat','India','WICKETKEEPER','Left-hand bat',NULL,30,28,450,0,3,0,140.00,18.75,'',3),
('Finn','Allen','Finn Allen','New Zealand','BATSMAN','Right-hand bat',NULL,25,24,700,0,5,0,160.00,31.80,'',3),
('Mahipal','Lamba','Mahipal Lamba','India','BATSMAN','Right-hand bat',NULL,10,9,140,0,1,0,135.00,17.50,'',3),
('Yash','Dayal','Yash Dayal','India','BOWLER','Right-hand bat','Right-arm fast-medium',35,30,30,35,0,0,120.00,6.00,'',3);

-- Kolkata Knight Riders (team_id = 4)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Shreyas','Iyer','Shreyas Iyer','India','BATSMAN','Right-hand bat',NULL,120,115,3700,0,30,6,130.00,34.22,'',4),
('Rahman','ullah','Rahman Ullah','India','BOWLER','Right-hand bat','Right-arm fast',10,9,10,8,0,0,95.00,2.50,'',4),
('Andre','Russell','Andre Russell','West Indies','ALLROUNDER','Right-hand bat','Right-arm fast',170,160,3500,200,25,2,155.00,27.00,'',4),
('Sunil','Narine','Sunil Narine','West Indies','ALLROUNDER','Left-hand bat','Off-spin',200,180,2500,180,10,0,120.00,22.50,'',4),
('Venkatesh','Iyer','Venkatesh Iyer','India','BATSMAN','Left-hand bat',NULL,60,55,1100,0,6,0,125.00,25.00,'',4),
('Varun','Chakaravarthy','Varun Chakravarthy','India','BOWLER','Right-hand bat','Legbreak',60,55,40,75,0,0,120.00,8.50,'',4),
('Phil','Salt','Phil Salt','England','BATSMAN','Right-hand bat',NULL,25,24,700,0,5,0,150.00,31.82,'',4),
('Naveen','ul Haq','Naveen ul Haq','Afghanistan','BOWLER','Right-hand bat','Right-arm fast',40,38,50,35,0,0,125.00,8.50,'',4),
('Rinku','Singh','Rinku Singh','India','BATSMAN','Right-hand bat',NULL,40,35,900,0,6,0,160.00,25.00,'',4),
('Shivam','Mavi','Shivam Mavi','India','BOWLER','Right-hand bat','Right-arm fast',30,25,30,25,0,0,125.00,6.00,'',4),
('Nikhil','Hooda','Nikhil Hooda','India','ALLROUNDER','Left-hand bat','Right-arm offbreak',8,7,80,4,0,0,110.00,15.50,'',4);

-- Sunrisers Hyderabad (team_id = 5)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Kane','Williamson','Kane Williamson','New Zealand','BATSMAN','Right-hand bat',NULL,90,85,2600,0,18,2,135.00,32.50,'',5),
('Abhishek','Sharma','Abhishek Sharma','India','BATSMAN','Left-hand bat',NULL,40,35,900,0,6,1,140.00,28.12,'',5),
('Aiden','Markram','Aiden Markram','South Africa','BATSMAN','Right-hand bat',NULL,30,28,900,0,6,1,135.00,32.14,'',5),
('Bhuvneshwar','Kumar','Bhuvneshwar Kumar','India','BOWLER','Right-hand bat','Right-arm medium',130,120,300,150,0,0,125.00,20.00,'',5),
('Washington','Sundar','Washington Sundar','India','ALLROUNDER','Left-hand bat','Off-spin',60,55,800,45,3,0,120.00,20.00,'',5),
('Marco','Jansen','Marco Jansen','South Africa','BOWLER','Right-hand bat','Right-arm fast',20,18,60,20,0,0,115.00,7.50,'',5),
('Nicholas','Pooran','Nicholas Pooran','West Indies','WICKETKEEPER','Left-hand bat',NULL,90,85,1800,0,10,1,150.00,21.17,'',5),
('Tristan','Stubbs','Tristan Stubbs','South Africa','BATSMAN','Right-hand bat',NULL,10,9,220,0,2,0,160.00,24.44,'',5),
('T Natarajan','Natarajan','T Natarajan','India','BOWLER','Right-hand bat','Right-arm fast',80,70,100,90,0,0,125.00,12.50,'',5),
('Kushal','Mendis','Kushal Mendis','Sri Lanka','BATSMAN','Right-hand bat',NULL,5,5,140,0,1,0,135.00,28.00,'',5),
('Mayank','Agarwal','Mayank Agarwal','India','BATSMAN','Right-hand bat',NULL,100,95,2900,0,20,3,130.00,30.52,'',5);

-- Lucknow Super Giants (team_id = 6)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('KL','Rahul','KL Rahul','India','WICKETKEEPER','Right-hand bat',NULL,150,145,4800,0,35,10,135.00,35.00,'',6),
('Quinton','de Kock','Quinton de Kock','South Africa','WICKETKEEPER','Left-hand bat',NULL,140,135,4200,0,30,8,140.00,31.11,'',6),
('Marcus','Stoinis','Marcus Stoinis','Australia','ALLROUNDER','Right-hand bat','Right-arm medium',80,70,1800,80,12,0,140.00,28.84,'',6),
('Mark','Wood','Mark Wood','England','BOWLER','Right-hand bat','Right-arm fast',40,36,100,50,0,0,140.00,10.00,'',6),
('Nicholas','Pooran-LG','Nicholas Pooran','West Indies','BATSMAN','Left-hand bat',NULL,90,85,1600,0,8,0,150.00,20.00,'',6),
('Deepak','Hooda','Deepak Hooda','India','ALLROUNDER','Right-hand bat','Right-arm offbreak',70,65,1400,30,10,0,135.00,25.50,'',6),
('Krunal','Pandya','Krunal Pandya','India','ALLROUNDER','Left-hand bat','Left-arm orthodox',80,70,1200,60,6,0,125.00,20.00,'',6),
('Avesh','Khan','Avesh Khan','India','BOWLER','Right-hand bat','Right-arm fast-medium',40,35,50,45,0,0,125.00,7.50,'',6),
('Ayush','Badoni','Ayush Badoni','India','BATSMAN','Right-hand bat',NULL,15,14,320,0,2,0,140.00,28.8,'',6),
('Yudhvir','Singh','Yudhvir Singh','India','BOWLER','Left-hand bat','Left-arm orthodox',10,9,20,8,0,0,100.00,6.66,'',6),
('Dushmantha','Chameera','Dushmantha Chameera','Sri Lanka','BOWLER','Right-hand bat','Right-arm fast',20,18,40,25,0,0,120.00,6.66,'',6);

-- Rajasthan Royals (team_id = 7)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Sanju','Samson','Sanju Samson','India','WICKETKEEPER','Right-hand bat',NULL,140,135,4000,0,25,8,135.00,30.76,'',7),
('Jos','Buttler','Jos Buttler','England','WICKETKEEPER','Right-hand bat',NULL,120,115,3800,0,28,9,150.00,35.00,'',7),
('Shimron','Hetmyer','Shimron Hetmyer','West Indies','BATSMAN','Left-hand bat',NULL,60,55,1500,0,10,1,145.00,27.27,'',7),
('Trent','Boult','Trent Boult','New Zealand','BOWLER','Right-hand bat','Left-arm fast-medium',90,85,200,150,0,0,120.00,16.00,'',7),
('Yashasvi','Jaiswal','Yashasvi Jaiswal','India','BATSMAN','Left-hand bat',NULL,50,48,1200,0,6,1,135.00,25.00,'',7),
('Ravichandran','Ashwin','Ravichandran Ashwin','India','BOWLER','Right-hand bat','Off-spin',150,140,2000,300,8,1,100.00,18.50,'',7),
('Prasidh','Kumar','Prasidh Kumar','India','BOWLER','Right-hand bat','Right-arm fast-medium',50,45,100,35,0,0,115.00,8.00,'',7),
('Chetan','Sakariya','Chetan Sakariya','India','BOWLER','Left-hand bat','Left-arm fast-medium',30,28,20,25,0,0,110.00,3.33,'',7),
('Riyan','Parag','Riyan Parag','India','ALLROUNDER','Right-hand bat','Right-arm offbreak',60,55,1100,30,5,0,120.00,22.00,'',7),
('Aly','Doucette','Aly Doucette','Australia','BOWLER','Right-hand bat','Right-arm fast',5,4,10,2,0,0,110.00,2.50,'',7),
('Yuzvendra','Chahal','Yuzvendra Chahal','India','BOWLER','Right-hand bat','Legbreak',150,140,80,200,0,0,120.00,12.00,'',7);

-- Punjab Kings (team_id = 8)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Shikhar','Dhawan','Shikhar Dhawan','India','BATSMAN','Left-hand bat',NULL,200,190,5500,0,40,8,135.00,30.00,'',8),
('Jonny','Bairstow','Jonny Bairstow','England','WICKETKEEPER','Right-hand bat',NULL,150,145,4200,0,30,7,140.00,30.00,'',8),
('Liam','Livingstone','Liam Livingstone','England','ALLROUNDER','Right-hand bat','Right-arm offbreak',80,75,1800,80,12,0,150.00,26.00,'',8),
('Shahrukh','Khan','Shahrukh Khan','India','BATSMAN','Left-hand bat',NULL,40,38,1100,0,8,0,140.00,28.94,'',8),
('Arshdeep','Singh','Arshdeep Singh','India','BOWLER','Left-hand bat','Left-arm fast-medium',50,45,30,55,0,0,125.00,6.00,'',8),
('Nathan','Ellis','Nathan Ellis','Australia','BOWLER','Right-hand bat','Right-arm fast',10,9,20,12,0,0,120.00,3.33,'',8),
('Harpreet','Brar','Harpreet Brar','India','ALLROUNDER','Left-hand bat','Left-arm orthodox',40,35,600,40,2,0,120.00,18.75,'',8),
('Rahman','ullah2','Rahman Ullah2','India','BOWLER','Right-hand bat','Right-arm fast',5,4,5,4,0,0,100.00,1.25,'',8),
('Prabhsimran','Singh','Prabhsimran Singh','India','WICKETKEEPER','Right-hand bat',NULL,30,28,700,0,5,0,150.00,25.00,'',8),
('Rovman','Powell','Rovman Powell','West Indies','BATSMAN','Right-hand bat',NULL,60,55,1600,0,10,0,150.00,29.09,'',8),
('Kagiso','Rabada','Kagiso Rabada','South Africa','BOWLER','Right-hand bat','Right-arm fast',120,110,200,350,0,0,125.00,18.00,'',8);

-- Delhi Capitals (team_id = 9)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Rishabh','Pant','Rishabh Pant','India','WICKETKEEPER','Left-hand bat',NULL,120,115,2800,0,20,4,140.00,30.43,'',9),
('Prithvi','Shaw','Prithvi Shaw','India','BATSMAN','Right-hand bat',NULL,80,75,2400,0,18,3,135.00,32.00,'',9),
('David','Warner','David Warner','Australia','BATSMAN','Left-hand bat',NULL,190,180,6200,0,40,12,140.00,34.44,'',9),
('Axar','Patel','Axar Patel','India','ALLROUNDER','Left-hand bat','Left-arm orthodox',120,110,1800,150,8,0,110.00,20.45,'',9),
('Kuldeep','Yadav','Kuldeep Yadav','India','BOWLER','Right-hand bat','Left-arm wrist-spin',80,75,200,120,0,0,120.00,16.00,'',9),
('Anrich','Nortje','Anrich Nortje','South Africa','BOWLER','Right-hand bat','Right-arm fast',40,36,50,45,0,0,140.00,8.33,'',9),
('Mitchell','Marsh','Mitchell Marsh','Australia','ALLROUNDER','Right-hand bat','Right-arm medium',60,55,1400,60,8,0,135.00,25.45,'',9),
('Ishant','Sharma','Ishant Sharma','India','BOWLER','Right-hand bat','Right-arm fast',70,65,150,220,0,0,120.00,18.00,'',9),
('Sarfaraz','Khan','Sarfaraz Khan','India','BATSMAN','Right-hand bat',NULL,30,28,800,0,5,0,140.00,28.57,'',9),
('Lalit','Yadav','Lalit Yadav','India','ALLROUNDER','Right-hand bat','Right-arm offbreak',30,28,350,18,2,0,125.00,17.50,'',9),
('Steve','Smith','Steve Smith','Australia','BATSMAN','Right-hand bat',NULL,80,75,2600,0,20,5,120.00,34.66,'',9);

-- Gujarat Titans (team_id = 10)
INSERT INTO players (first_name,last_name,full_name,nationality,player_type,batting_style,bowling_style,matches,innings,runs,wickets,fifties,hundreds,strike_rate,average,photo_url,team_id) VALUES
('Shubman','Gill','Shubman Gill','India','BATSMAN','Right-hand bat',NULL,80,75,3000,0,25,6,140.00,40.00,'',10),
('Hardik','Pandya','Hardik Pandya','India','ALLROUNDER','Right-hand bat','Right-arm medium-fast',110,100,2600,110,10,0,140.00,26.00,'',10),
('Rashid','Khan','Rashid Khan','Afghanistan','BOWLER','Right-hand bat','Legbreak',120,110,700,250,5,0,135.00,10.00,'',10),
('Rahul','Tewatia','Rahul Tewatia','India','ALLROUNDER','Right-hand bat','Legbreak',80,75,1000,30,6,0,130.00,20.00,'',10),
('Alzarri','Joseph','Alzarri Joseph','West Indies','BOWLER','Right-hand bat','Right-arm fast',40,36,200,60,0,0,135.00,10.00,'',10),
('Wriddhiman','Saha','Wriddhiman Saha','India','WICKETKEEPER','Right-hand bat',NULL,80,75,2200,0,12,1,120.00,29.33,'',10),
('Umesh','Yadav','Umesh Yadav','India','BOWLER','Right-hand bat','Right-arm fast',90,85,100,180,0,0,125.00,12.50,'',10),
('Kane','Richardson','Kane Richardson','Australia','BOWLER','Right-hand bat','Right-arm fast-medium',30,28,20,25,0,0,120.00,4.00,'',10),
('Sai','Kumar','Sai Kumar','India','BATSMAN','Right-hand bat',NULL,12,11,250,0,2,0,145.00,22.72,'',10),
('Matthew','Wade','Matthew Wade','Australia','WICKETKEEPER','Right-hand bat',NULL,50,48,1100,0,10,0,140.00,23.00,'',10),
('Jason','Roy','Jason Roy','England','BATSMAN','Right-hand bat',NULL,45,42,1600,0,8,0,150.00,38.09,'',10);


-- ------------------------------
-- 5) Umpires
-- ------------------------------
INSERT INTO umpires (name, nationality, experience_years, photo_url) VALUES
('Nitin Menon','India',12,''),
('Kumar Dharmasena','Sri Lanka',18,''),
('Richard Illingworth','England',20,''),
('Paul Reiffel','Australia',22,''),
('Keshav Maharaj','South Africa',2,'');

-- ------------------------------
-- 6) Referees
-- ------------------------------
INSERT INTO referees (name, nationality, experience_years, photo_url) VALUES
('Javagal Srinath','India',15,''),
('Chris Broad','England',18,''),
('Kumar Sangakkara','Sri Lanka',8,'');

-- ------------------------------
-- 7) Matches (sample IPL 2025 schedule entries)
-- Dates are examples in Apr 2025. Adjust as required.
-- ------------------------------
INSERT INTO matches (scheduled_at, stadium_id, team_a_id, team_b_id, umpire1_id, umpire2_id, referee_id, status) VALUES
('2025-04-01 19:30:00', 1, 1, 2, 1, 2, 1, 'SCHEDULED'),
('2025-04-02 19:30:00', 3, 3, 4, 2, 3, 2, 'SCHEDULED'),
('2025-04-03 19:30:00', 10, 10, 5, 1, 4, 3, 'SCHEDULED'),
('2025-04-04 19:30:00', 9, 9, 8, 3, 1, 1, 'SCHEDULED'),
('2025-04-05 19:30:00', 7, 7, 6, 4, 2, 2, 'SCHEDULED'),
('2025-04-06 19:30:00', 2, 2, 3, 1, 2, 3, 'SCHEDULED'),
('2025-04-07 15:30:00', 4, 4, 5, 3, 4, 1, 'SCHEDULED'),
('2025-04-08 19:30:00', 5, 6, 10, 2, 4, 2, 'SCHEDULED'),
('2025-04-09 19:30:00', 6, 8, 7, 1, 3, 3, 'SCHEDULED'),
('2025-04-10 19:30:00', 8, 9, 1, 2, 3, 1, 'SCHEDULED');

-- ------------------------------
-- 8) Example match_players (optional playing XI) - provide one match example
-- ------------------------------
-- Match 1 (MI vs CSK) = match id likely 1
INSERT INTO match_players (match_id, player_id, team_id, role_in_match) VALUES
(1, 1, 1, 'STARTING'), -- Rohit Sharma (MI)
(1, 2, 1, 'STARTING'), -- Ishan Kishan (MI)
(1, 5, 1, 'STARTING'), -- Jasprit Bumrah (MI)
(1, 4, 1, 'STARTING'), -- Suryakumar (MI)
(1, 3, 1, 'STARTING'),
(1, 6, 1, 'STARTING'),
(1, 7, 1, 'STARTING'),
(1, 10, 1, 'STARTING'),
(1, 11, 1, 'STARTING'),
(1, 9, 1, 'STARTING'),
(1, 8, 1, 'STARTING'),

(1, 12, 2, 'STARTING'), -- Ruturaj Gaikwad (CSK)
(1, 14, 2, 'STARTING'), -- Devon Conway
(1, 16, 2, 'STARTING'),
(1, 18, 2, 'STARTING'),
(1, 17, 2, 'STARTING'),
(1, 15, 2, 'STARTING'),
(1, 19, 2, 'STARTING'),
(1, 20, 2, 'STARTING'),
(1, 13, 2, 'STARTING'),
(1, 21, 2, 'STARTING'),
(1, 22, 2, 'STARTING');

-- ------------------------------
-- 9) Example Users (admin & sample user)
-- Passwords below are example bcrypt hashes — replace with your own secure hashes.
-- You can generate bcrypt in your app or via online tools. These hashes are placeholders.
-- admin password: admin123 (placeholder hash below)
-- user1 password: user123 (placeholder hash below)
-- ------------------------------
INSERT INTO users (username, password, role, enabled) VALUES
('admin', '$2a$10$C6UzMDM.H6dfI/f/IKc7Ne', 'ADMIN', true),
('fan1', '$2a$10$7EqJtq98hPqEX7fNZaFWoO', 'USER', true);

-- ---------------------------------------------------------
-- Done. You now have 10 teams, stadiums, 110 players, umpires,
-- referees and a sample set of scheduled matches for IPL 2025.
-- ---------------------------------------------------------

