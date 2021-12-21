---------------------------------------------- 1 task ---------------------------------------------------------

SELECT e1.id,e1.department_id,e1.chif_id,e1.name,e1.salary
FROM employee AS e1 
INNER JOIN EMPLOYEE AS e2 ON e1.chif_id = e2.id AND e1.salary < e2.salary


---------------------------------------------- 2 task ---------------------------------------------------------

SELECT e1.id,e1.department_id,e1.chif_id,e1.name,e1.salary
FROM employee AS e1 
INNER JOIN
		(SELECT department_id,MIN(salary) as min_salary
		FROM employee
		GROUP BY department_id) AS e2 ON e2.min_salary = e1.salary AND e2.department_id = e1.department_id 

----------------------------------------------3 task ----------------------------------------------------------

WITH dep_empl_count AS(
	SELECT department_id,COUNT(*) as counter
	FROM employee AS e1 
	GROUP BY department_id
) SELECT * 
  FROM department
  WHERE ID IN(SELECT department_id 
			  FROM dep_empl_count
			  WHERE counter <3)

---------------------------------------------- 4 task ----------------------------------------------------------

SELECT * FROM employee AS e1 INNER JOIN 
						    (SELECT department_id 
							FROM employee
							WHERE chif_id IS NULL) AS e2 ON e2.department_id = e1.department_id


---------------------------------------------- 5 task ----------------------------------------------------------

WITH dep_sum AS(
	SELECT department_id,SUM(salary) AS summa 
	FROM employee 
	GROUP BY department_id
) SELECT d1.*,d2.summa
  FROM department AS d1
  INNER JOIN(SELECT department_id,summa
			  FROM dep_sum 
			  WHERE summa = (SELECT MAX(summa) FROM dep_sum)) AS d2 ON d1.id = d2.department_id

---------------------------------------------- 6 task ----------------------------------------------------------

SELECT SUM(salary) as sum_all FROM employee



