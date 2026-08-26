-- ============================================================
-- Drone Delivery Feasibility Analysis -- Hyderabad
-- SQL Queries (run against drone_delivery_clean.db)
-- Tables: zones, weather_logs, delivery_cost, risk_scores
-- ============================================================

-- 1. Safety vs. Cost by Zone
-- Joining all 4 tables to see average safety and average cost per zone.
-- Want to find zones that are both safe AND cheap - that's the sweet spot for rollout.
SELECT 
    z.zone_name,
    z.distance_from_hub_km,
    ROUND(AVG(r.safety_score), 1) AS avg_safety,
    ROUND(AVG(c.cost_per_delivery), 1) AS avg_cost
FROM zones z
JOIN risk_scores r ON z.zone_id = r.zone_id
JOIN delivery_cost c ON z.zone_id = c.zone_id AND r.date = c.date
GROUP BY z.zone_name
ORDER BY avg_safety DESC;


-- 2. Rollout Priority Score by Zone
-- Combining safety and cost into one score so zones can be ranked by both at once,
-- not just eyeballing two columns. Normalizing cost first (cheaper = better),
-- then blending 60% safety + 40% cost-efficiency.
SELECT 
    z.zone_name,
    ROUND(AVG(r.safety_score), 1) AS avg_safety,
    ROUND(AVG(c.cost_per_delivery), 1) AS avg_cost,
    ROUND(
        (AVG(r.safety_score) * 0.6) + 
        ((100 - AVG(c.cost_per_delivery)) * 0.4), 
    1) AS rollout_priority_score
FROM zones z
JOIN risk_scores r ON z.zone_id = r.zone_id
JOIN delivery_cost c ON z.zone_id = c.zone_id AND r.date = c.date
GROUP BY z.zone_name
ORDER BY rollout_priority_score DESC;


-- 3. Safety Consistency by Zone
-- Checking not just the average safety per zone, but the worst and best day too,
-- because two zones can have the same average but very different consistency.
SELECT 
    z.zone_name,
    ROUND(AVG(r.safety_score), 1) AS avg_safety,
    ROUND(MIN(r.safety_score), 1) AS worst_day,
    ROUND(MAX(r.safety_score), 1) AS best_day
FROM zones z
JOIN risk_scores r ON z.zone_id = r.zone_id
GROUP BY z.zone_name
ORDER BY avg_safety DESC;


-- 4. Risky Days per Zone
-- Setting a safety threshold (60) - below this, considered too risky to fly that day.
-- Counting how many of the 90 days each zone actually dropped below that line.
SELECT 
    z.zone_name,
    ROUND(AVG(r.safety_score), 1) AS avg_safety,
    COUNT(CASE WHEN r.safety_score < 60 THEN 1 END) AS risky_days,
    COUNT(*) AS total_days
FROM zones z
JOIN risk_scores r ON z.zone_id = r.zone_id
GROUP BY z.zone_name
ORDER BY risky_days DESC;
