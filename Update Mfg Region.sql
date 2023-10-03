-- SQLite
UPDATE car_data_tbl
SET region = CASE 
    WHEN car_model = 'toyota' THEN 'Japan'
    WHEN car_model = 'skoda' THEN 'Czechia'
    WHEN car_model = 'merc' THEN 'Germany'
    WHEN car_model = 'ford' THEN 'USA'
    WHEN car_model = 'vw' THEN 'Germany'
    WHEN car_model = 'bmw' THEN 'Germany'
    WHEN car_model = 'vauxhall' THEN 'France'
    WHEN car_model = 'hyundi' THEN 'Korea'
    WHEN car_model = 'audi' THEN 'Germany'
    ELSE region  -- keeps the original value if no conditions are met
END;

Select * from car_data_tbl