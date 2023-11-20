-- USE madrid

-- Establishing connections between the tables:
ALTER TABLE main_info
	ADD PRIMARY KEY (id);

-- 1
ALTER TABLE location
	ADD PRIMARY KEY (location_id);

ALTER TABLE main_info
	ADD CONSTRAINT fk_main_info_location
		FOREIGN KEY (location_id) REFERENCES location(location_id);
-- 2
ALTER TABLE features
	ADD PRIMARY KEY (feature_id);

ALTER TABLE main_info
	ADD CONSTRAINT fk_main_info_features
		FOREIGN KEY (feature_id) REFERENCES features(feature_id);
RENAME TABLE type TO property_type;
-- 3
ALTER TABLE property_type
	ADD PRIMARY KEY (type_id);

ALTER TABLE main_info
	ADD CONSTRAINT fk_main_info_property_type
		FOREIGN KEY (type_id) REFERENCES property_type(type_id);
        
-- 4

ALTER TABLE pricing
	ADD PRIMARY KEY (price_id);

ALTER TABLE property_type
	ADD CONSTRAINT fk_property_type_pricing
		FOREIGN KEY (price_id) REFERENCES pricing(price_id);


-- Now that all the connections are stablished i will proceed with the queries in order to look for the needed data.
-- In the following query we can look at the average buy and rent prices  by the house and neighborhood id.
SELECT
    location.neighborhood_id,
    property_type.house_type_id,
		AVG(pricing.buy_price) AS average_buy_price,
		AVG(pricing.rent_price) AS average_rent_price
FROM pricing
	JOIN property_type ON pricing.price_id = property_type.price_id
	JOIN main_info ON property_type.type_id = main_info.type_id
	JOIN location ON main_info.location_id = location.location_id
GROUP BY location.neighborhood_id, property_type.house_type_id;

-- In this second query i will be looking for all the basic features off the properties along with its buy and rent prices
SELECT
	main_info.id,
    features.has_lift,
	features.is_exterior,
    features.has_parking,
    main_info.sq_mt_built,
    main_info.n_rooms,
    main_info.n_bathrooms,
		pricing.buy_price AS buy_price,
		pricing.rent_price AS rent_price
FROM pricing
	JOIN property_type ON pricing.price_id = property_type.price_id
	JOIN main_info ON property_type.type_id = main_info.type_id
	JOIN features ON main_info.feature_id = features.feature_id;
    
    -- In case our clients were a family of four who just moved in to madrid that want to buy a property and their conditions are:
    -- at least 3 bedrooms 3 to 4 bathrooms with more than 150sq_mt built that has lift they do not really care about the floor and they do not want parking;
    -- but they need the apartment to be less than 1M€

SELECT
	main_info.id,
    main_info.floor,
    features.has_lift,
    features.has_parking,
    main_info.sq_mt_built,
    main_info.n_rooms,
    main_info.n_bathrooms,
		pricing.buy_price AS buy_price
FROM pricing
	JOIN property_type ON pricing.price_id = property_type.price_id
	JOIN main_info ON property_type.type_id = main_info.type_id
	JOIN features ON main_info.feature_id = features.feature_id
WHERE
    main_info.n_rooms >= 3
    AND main_info.n_bathrooms BETWEEN 3 AND 4
    AND main_info.sq_mt_built > 150
    AND features.has_lift = 1
    AND features.has_parking = 0
    AND pricing.buy_price < 1000000;
    
-- Many people nowadays may worry about the enrgy certifcate as well as how new might the property be thanks to the complete database we can see if a renewal might be needed.
SELECT
	main_info.id,
    features.energy_certificate,
    property_type.house_type_id,
    property_type.is_renewal_needed,
    property_type.is_new_development,
		pricing.rent_price AS rent_price
FROM pricing
	JOIN property_type ON pricing.price_id = property_type.price_id
	JOIN main_info ON property_type.type_id = main_info.type_id
	JOIN features ON main_info.feature_id = features.feature_id;
    
    
-- 5 in this query we can look at many of the characetristics of some of the properties while they have been ranked with the price per square metre

WITH RankedProperties AS (
    SELECT
        main_info.id,
        location.title,
        location.subtitle,
        main_info.n_rooms,
        main_info.n_bathrooms,
        main_info.sq_mt_built,
        main_info.floor,
        pricing.buy_price,
        location.neighborhood_id,
			ROW_NUMBER() OVER (PARTITION BY location.neighborhood_id ORDER BY pricing.buy_price / main_info.sq_mt_built) AS price_per_sqm_rank
    FROM pricing
		JOIN property_type ON pricing.price_id = property_type.price_id
		JOIN main_info ON property_type.type_id = main_info.type_id
		JOIN location ON main_info.location_id = location.location_id

)
SELECT 
	id, title, subtitle, n_rooms, n_bathrooms, sq_mt_built, floor, buy_price, neighborhood_id, price_per_sqm_rank
FROM
    RankedProperties
WHERE
    price_per_sqm_rank <= 5
ORDER BY price_per_sqm_rank DESC;

-- 6 In the following query we look for properties similar to a specified target property

WITH TargetProperty AS (
    SELECT
        main_info.id AS target_property_id,
        main_info.n_rooms AS target_n_rooms,
        main_info.n_bathrooms AS target_n_bathrooms,
        main_info.sq_mt_built AS target_sq_mt_built,
        main_info.floor AS target_floor,
        pricing.buy_price AS target_buy_price,
        location.neighborhood_id AS target_neighborhood_id
    FROM
        pricing
        JOIN property_type ON pricing.price_id = property_type.price_id
        JOIN main_info ON property_type.type_id = main_info.type_id
        JOIN location ON main_info.location_id = location.location_id
    WHERE
        main_info.id = 1287  -- Replace with the specific property ID
)
SELECT
    main_info.id,
    location.title,
    location.subtitle,
    main_info.n_rooms,
    main_info.n_bathrooms,
    main_info.sq_mt_built,
    main_info.floor,
    pricing.buy_price,
    location.neighborhood_id
FROM
    pricing
    JOIN property_type ON pricing.price_id = property_type.price_id
    JOIN main_info ON property_type.type_id = main_info.type_id
    JOIN location ON main_info.location_id = location.location_id
    JOIN TargetProperty target ON location.neighborhood_id = target.target_neighborhood_id
WHERE
    ABS(main_info.n_rooms - target.target_n_rooms) <= 1
    AND ABS(main_info.n_bathrooms - target.target_n_bathrooms) <= 1
    AND ABS(main_info.sq_mt_built - target.target_sq_mt_built) <= 20
    AND main_info.floor = target.target_floor
    AND main_info.id <> target.target_property_id
ORDER BY
    ABS(pricing.buy_price - target.target_buy_price)
LIMIT 5;