--- Firstly, i will run a query to look for data from the crime scene report.
SELECT *
FROM crime_scene_report
WHERE city = "SQL City"
ORDER BY date;

-- I will run another query to find the exact data that i am looking for in the crime scene report
SELECT description FROM crime_scene_report
WHERE date = '20180115' AND type = 'murder' AND city = 'SQL City'

-- After finding the exact data, it stated that the security footage shows that there were two witnnesses.
-- The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave"
-- I will therefore run a query to look for the witnessessess and view their interview.
WITH witness1 AS (
    SELECT id FROM person
    WHERE address_street_name = 'Northwestern Dr'
    ORDER BY address_number DESC LIMIT 1
), witness2 AS (
    SELECT id FROM person
    WHERE INSTR(name, 'Annabel') > 0 AND address_street_name = 'Franklin Ave'
), witnesses AS (
    SELECT *, 1 AS witness FROM witness1
    UNION
    SELECT *, 2 AS witness FROM witness2
)
SELECT witness, transcript FROM witnesses
LEFT JOIN interview ON witnesses.id = interview.person_id

-- The witnesses stated that the Killer is a man and a member of the gym with a status of gold and having a membership no. starting with 48Z and left in a car with a no. plate of H42W
-- He was working out in the gym on 9th of Jan. 
-- I will now check the gym database with the information provided by the witnesses 
SELECT *
FROM get_fit_now_check_in 
WHERE membership_id like "%48Z%" AND check_in_date = 20180109 
order by check_in_date;

-- Now that i have found two members and their membership ID, i will now go on to find the car information
SELECT *
FROM drivers_license
WHERE plate_number like "%H42W%";

-- I have found two males with number plate containing H42W. I will now use the information found above to check the personal information of both males.
SELECT *
FROM person
WHERE license_id = "423327" OR license_id = "664760";

-- Now that i have found their information, i will check which of them is the member of the gym
SELECT *
FROM get_fit_now_member
WHERE person_id = "51739" OR person_id = "67318";

-- Now that i have finally found out that the muderer is Jeremy Bowers, i will insert query for confirming it.crime_scene_report
INSERT INTO solution VALUES (1, 'Jeremy Bowers'); SELECT value FROM solution;

-- Further investigation about the real villain
SELECT *
FROM interview
WHERE person_id = 67318;

-- Jemery said he was hired by red hair and a Tesla Model S. We also know she attended the SQL Symphony Concert 3 times in December 2017.
SELECT p.name, d.height, d.hair_color, d.car_make, d.car_model, d.gender
from drivers_license as d
JOIN person AS p
ON d.id = p.license_id
where d.height between 65 and 67 and d.hair_color = 'red' and gender = 'female'
      and car_make = 'Tesla' AND car_model = 'Model S'
      and p.id IN (SELECT f.person_id
                   from facebook_event_checkin as f
                   where f.event_name = 'SQL Symphony Concert')
-- Miranda Priestly is the one behind everything.
INSERT INTO solution VALUES (1, "Miranda Priestly");

SELECT value FROM solution;
