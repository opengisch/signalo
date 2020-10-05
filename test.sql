

DROP TABLE IF EXISTS sign;

CREATE TABLE sign
(
  id serial primary key,
  location int,
  angle int,
  frame int,
  rank int,
  height int
);
--                                                   location,angle,frame,rank,height
insert into sign (location,angle,frame,rank,height) VALUES (1,45,1,1,100);
insert into sign (location,angle,frame,rank,height) VALUES (1,45,1,2,100);
insert into sign (location,angle,frame,rank,height) VALUES (1,90,1,1,110);
insert into sign (location,angle,frame,rank,height) VALUES (1,90,2,1,120);
insert into sign (location,angle,frame,rank,height) VALUES (1,90,2,2,130);
insert into sign (location,angle,frame,rank,height) VALUES (1,90,2,3,140);
insert into sign (location,angle,frame,rank,height) VALUES (2,15,1,1,100);
insert into sign (location,angle,frame,rank,height) VALUES (2,15,1,2,100);
insert into sign (location,angle,frame,rank,height) VALUES (2,15,2,1,100);
insert into sign (location,angle,frame,rank,height) VALUES (2,60,1,1,100);
insert into sign (location,angle,frame,rank,height) VALUES (2,60,1,2,100);
insert into sign (location,angle,frame,rank,height) VALUES (2,60,2,1,100);

WITH ordered_signs AS (
    SELECT
      sign.*,
      ROW_NUMBER () OVER (
        PARTITION BY location, angle ORDER BY frame, rank
      ) AS final_rank
      FROM sign
      ORDER BY location, angle, frame, rank
)
SELECT
    ordered_signs.*,
    SUM( height ) OVER rolling_window AS shift,
    NULLIF(FIRST_VALUE(id) OVER (PARTITION BY location, angle, frame ROWS 1 PRECEDING), id) AS previous_sign_in_frame,
    NULLIF(LAST_VALUE(id) OVER ( PARTITION BY location, angle, frame ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), id) AS next_sign_in_frame,
    NULLIF(FIRST_VALUE(frame) OVER ( PARTITION BY location, angle ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), frame) AS previous_frame,
    NULLIF(LAST_VALUE(frame) OVER ( PARTITION BY location, angle ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), frame) AS next_frame
FROM
    ordered_signs
    WINDOW rolling_window AS ( PARTITION BY location, angle ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
    ORDER BY location, angle, frame, final_rank
;

