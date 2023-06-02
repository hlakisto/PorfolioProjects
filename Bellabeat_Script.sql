/*

The assignment is to focus on a Bellabeat product and analyze smart device usage data in 
order to gain insight into how people are already using their smart devices. Then, using this 
information, she would like high-level recommendations for how these trends can inform Bellabeat
marketing strategy.

Data Source: https://zenodo.org/record/53894#.Yf04O-pBy1t

*/


# To obtain the average BMI for each participant
SELECT 
      Id,
      COUNT(Id) AS NoOfMeasurements,
      ROUND(AVG(BMI),1) AS BMI
 
 FROM `fabled-web-331503.Bellabeat_ver2.BMI` 


GROUP BY Id;


# to obtain the average daily steps per week vs calories burn.
SELECT 
    COUNT(TotalSteps) AS NoOfActivities,
    Weekday, LifestyleSteps,
    ROUND(AVG(TotalSteps)) AS AveSteps,
    ROUND(AVG(Calories)) AS AveCalories
FROM
    `fabled-web-331503.Bellabeat_ver2.DailyActivity` 
GROUP BY 
    Weekday, LifestyleSteps;
 
 #  To measure how different activities (intensity of steps) have an impact on calorie burn
SELECT
    Weekday,
    ROUND(AVG(LightlyActiveMinutes)) AS AveLightlyActiveMinutes,
    ROUND(AVG(ModeratelyActiveMinutes)) AS AveModeratelyActiveMinutes,
    ROUND(AVG(VeryActiveMinutes)) AS AveVeryActiveMinutes,
    ROUND(AVG(SedentaryMinutes)) AS AveSedentaryMinutes,
    ROUND(AVG(VeryActiveSpeed)) AS AveVeryActiveSpeed,
    ROUND(AVG(Calories)) AS AveCalories
FROM
    `fabled-web-331503.Bellabeat_ver2.DailyActivity` 
GROUP BY 
    Weekday;
 
 
ALTER TABLE `fabled-web-331503.Bellabeat_ver2.SleepDay` 
ADD COLUMN TimeInBedAwake INT;
 

#To count the number of participants
SELECT 
    COUNT(DISTINCT Id) AS Participants
FROM    
      `fabled-web-331503.Bellabeat_ver2.SleepDay_v2` ;


/*The following serves to obtain the amount of time spent awake in bed which 
gives me the  amount of time it takes to fall asleep. 
There are however a number of assumptions that need to be made about this data. 
First is to negate the possibility that the time awake in bed before falling asleep 
could be attributed to activities one may endeavour in performing such as reading,
sexual intercourse etc… The assumption is therefore that the participant struggles to fall asleep.*/


SELECT
SD.Id,
SD.SleepDay,
SD.TimeAsleep,
SD.TimeInBedAwake,
DA.SedentaryMinutes,
DA.VeryActiveMinutes + ModeratelyActiveMinutes + LightlyActiveMinutes As ActiveMinutes,
DA.Calories
FROM (    
    SELECT 
Id,
IrregularSleepDays
FROM
(
    SELECT 
        Id,
        COUNT(Id) AS IrregularSleepDays 
    From
    (
        SELECT
            Id,
            SleepDay,
            TimeAsleep,
            TimeInBedAwake
        
        FROM `fabled-web-331503.Bellabeat_ver2.SleepDay_v2` 
 
        WHERE TimeAsleep <= 6.0 OR TimeAsleep > 9.0
        ORDER BY Id 
    )
GROUP BY Id
ORDER By IrregularSleepDays DESC
)
WHERE IrregularSleepDays > 2
) AS SD
INNER JOIN
`fabled-web-331503.Bellabeat_ver2.DailyActivity` AS DA
ON SD.Id = DA.Id;
 




SELECT
    Id, 
    SleepDay,
    ROUND(TotalMinutesAsleep / 60) AS TimeAsleep,
    (TotalTimeINBed - TotalMinutesAsleep) AS TimeInBedAwake,
    ROUND((TotalTimeInBed /60),2) AS  TotalTimeInBed
FROM
    `fabled-web-331503.Bellabeat_ver2.SleepDay` ;

#to obtain the number of participants with normal sleeping patterns.  
SELECT
    COUNT(DISTINCT Id) AS NormalSleepPatterns
FROM
(
    SELECT 
        Id,
        SleepDay,
        TimeAsleep,
        TimeInBedAwake,
        TotalTimeInBed
     FROM   
      `fabled-web-331503.Bellabeat_ver2.SleepDay_v2` 
 
WHERE
    (TimeAsleep >= 7.0 AND TimeAsleep <= 8.0) AND (TimeinBedAwake >= 10 AND TimeinBedAwake <= 20));


 
SELECT
    Id,
    SleepDay,
    TimeAsleep,
    TimeInBedAwake
 
FROM `fabled-web-331503.Bellabeat_ver2.SleepDay_v2` 
 
WHERE (TimeAsleep <= 6.0 OR TimeAsleep > 9.0) AND (TimeInBedAwake < 9 OR TimeInBedAwake > 21)
 
ORDER BY Id ;
 
SELECT 
Id,
IrregularSleepDays
FROM
(
    SELECT 
        Id,
        COUNT(Id) AS IrregularSleepDays 
    From
    (
        SELECT
            Id,
            SleepDay,
            TimeAsleep,
            TimeInBedAwake
        
        FROM `fabled-web-331503.Bellabeat_ver2.SleepDay_v2`
 
        WHERE TimeAsleep <= 6.0 OR TimeAsleep > 9.0
        ORDER BY Id 
    )
GROUP BY Id
ORDER By IrregularSleepDays DESC
)
WHERE IrregularSleepDays > 2;
 
 
 #To determine how irregular sleep patterns affect daily activities and the quantity of calorie burn.
SELECT 
Weekday,
ROUND(AVG(LightlyActiveMinutes)) AS AveLightlyActiveMinutes,
ROUND(AVG(ModeratelyActiveMinutes)) AS AveModeratelyActiveMinutes,
ROUND(AVG(VeryActiveMinutes)) AS AveVeryActiveMinutes,
ROUND(AVG(SedentaryMinutes)) AS AveSedentaryMinutes,
ROUND(AVG(VeryActiveSpeed)) AS AveVeryActiveSpeed,
ROUND(AVG(Calories)) AS AveCalories
 
FROM 
    (
        SELECT
            Id,
            SleepDay,
            TimeAsleep,
            TimeInBedAwake
        
        FROM fabled-web-331503.Bellabeat_ver2.SleepDay_v2 
 
        WHERE TimeAsleep <= 6.0 OR TimeAsleep > 9.0
        
) AS SD
INNER JOIN
`fabled-web-331503.Bellabeat_ver2.DailyActivity` AS DA
ON SD.Id = DA.Id
GROUP BY Weekday;
 
# To obtain the metabolic equivalent of task vs beats per minute.
SELECT 
HR.Id,
ROUND(AVG(MM.METs)) AS AveMets,
ROUND(AVG(HR.Value)) AS AveBPM
FROM `fabled-web-331503.Bellabeat_ver2.Heartrate` AS HR
JOIN
    `fabled-web-331503.Bellabeat_ver2.MinuteMet` AS MM
ON HR.Id = MM.Id
GROUP BY Id;
 

SELECT  
Id,
ROUND(AVG(Mets)) AS AveMETs
FROM `fabled-web-331503.Bellabeat_ver2.MinuteMet` ;
 

SELECT 
Id,
ROUND(AVG(Value)) AS AveBPM
FROM `fabled-web-331503.Bellabeat_ver2.Heartrate` 
GROUP BY Id;
 
