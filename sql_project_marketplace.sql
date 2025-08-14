-- Задание 1. Сбор данных о пользователях.
-- Отберем данные о клиентах маркетплейса, которые зарегистрировались в 2024 году.
-- Выведем все столбцы таблицы users: user_id, registration_date, os, age, device, gender, region, browser, country, acq_channel, 
-- campaign_id, user_segment, buyer_segment. JSON-значения представим в виде отдельных столбцов для каждого из параметров. 
-- Дополнительно определим неделю привлечения (cohort_week) и месяц привлечения (cohort_month).
-- Отсортируем полученные данные по дате регистрации в порядке возрастания и выведем на экран 100 строк.
SELECT user_id,
    registration_date,   
    user_params->>'age' AS age,
    user_params->>'gender' AS gender,
    user_params->>'country' AS country,
    user_params->>'region' AS region,
    user_params->>'buyer_segment' AS buyer_segment,
    user_params->>'user_segment' AS user_segment,
    user_params->>'device' AS device,
    user_params->>'browser' AS browser,
    user_params->>'os' AS os,
    user_params->>'acq_channel' AS acq_channel,
    user_params->>'campaign_id' AS campaign_id,
    DATE_TRUNC('week', registration_date::timestamp)::DATE AS cohort_week,
    (DATE_TRUNC('month', registration_date::timestamp))::DATE AS cohort_month
FROM pa_graduate.users
WHERE registration_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY registration_date
LIMIT 100;
-- Задание 2. Сбор данных о событиях.
-- Соберем набор данных о событиях, которые произошли в 2024 году. Отсортируем полученные данные по дате события и выведем на экран 100 строк.
SELECT event_id,
    session_id,
    user_id,
    timestamp AS event_date,
    event_type,
    event_params->>'os' AS os,
    event_params->>'device' AS device,
    event_params->>'event_index' AS event_index,
    event_params->>'user_segment' AS user_segment,
    product_name,
    DATE_TRUNC('week', (event_params->>'timestamp')::timestamp)::date AS event_week,
    DATE_TRUNC('month', (event_params->>'timestamp')::timestamp)::date AS event_month
FROM pa_graduate.events
LEFT JOIN pa_graduate.product_dict USING(product_id)
WHERE DATE_TRUNC('year', (event_params->>'timestamp')::timestamp)::DATE = '2024-01-01'
ORDER BY event_date ASC
LIMIT 100;
-- Задание 3. Сбор данных о заказах.
-- Соберем набор данных о заказах, которые были сделаны в 2024 году. Дополнительно создадим неделю заказа (order_week), месяц заказа (order_month).
-- Отсортируем полученные данные по дате заказа и выведем на экран 100 строк.
SELECT order_id,
    user_id,
    order_date,
    product_name,
    quantity,
    unit_price,
    total_price,
    category_name,
    DATE_TRUNC('week', order_date::date)::date AS order_week,
    DATE_TRUNC('month', order_date::date)::date AS order_month
FROM pa_graduate.orders
LEFT JOIN pa_graduate.product_dict USING(product_id)
WHERE order_date::DATE BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY order_date
LIMIT 100;
-- Задание 4. Сбор данных о сессиях.
-- Соберем данные о сессиях пользователей в 2024 году. В итоговый датафрейм должны войти все данные из таблицы с сессиями (после преобразования 
-- столбца в формате JSON). Добавим неделю и месяц сессии. Отсортируем полученные данные по дате начала сессии и выведем на экран 100 строк.
SELECT session_id,
    user_id,
    session_start,
    session_params->>'device' AS device,
    session_params->>'browser' AS browser,
    session_params->>'os' AS os,
    session_params->>'user_segment' AS user_segment,
    session_params->>'entry_path' AS entry_path,
    session_params->>'path_start' AS path_start,
    session_params->>'country' AS country,
    session_params->>'region' AS region,
    session_params->>'screen_size' AS screen_size,
    session_params->>'scroll_depth' AS scroll_depth,
    session_params->>'utm_source' AS utm_source,
    session_params->>'utm_campaign_id' AS utm_campaign_id,
    DATE_TRUNC('week', session_start)::date AS session_week,
    DATE_TRUNC('month', session_start)::date AS session_month
FROM pa_graduate.sessions
WHERE session_start::date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY session_start
LIMIT 100;


