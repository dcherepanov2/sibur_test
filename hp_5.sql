-- =============================================
-- Author:		Черепанов Данил Сергеевич
-- Create date: 18.12.2021
-- Description:	v.1.1 ---- Выполняется условие , что для всех начальников chif_id IS NULL, 
					  ---- если начальника быть у него не может и chif_id = 0, если начальник временно отсутствует или пока не найден
-- =============================================
CREATE PROCEDURE [dbo].[UPDATESALARY] 
	@ID_DEP  NUMERIC(15,4)  = 0,        -- id департамента
	@PRECENT NUMERIC(15,4) = 0          -- процент повышения зарплаты
AS
BEGIN
	
	DECLARE @oldsalary table(old_salary NUMERIC(10,2), employee_id INT)
	INSERT INTO @oldsalary SELECT salary,id FROM employee WHERE department_id = @id_dep--запись данных до повышения

	UPDATE employee SET salary = salary + (salary / 100 * @precent) WHERE department_id = @id_dep AND chif_id NOT IN (SELECT id 
																											      FROM employee WHERE id in (
																																	SELECT DISTINCT chif_id 
																																	FROM employee 
																																	WHERE department_id = @id_dep) 
																																AND department_id != @id_dep) -- поиск начальников среди отдела

	IF @id_dep = (SELECT department_id FROM employee WHERE chif_id IS NULL) -- главный отдел
		UPDATE employee SET salary = (SELECT MAX(salary) FROM employee WHERE department_id = @id_dep) 
		WHERE id IN (SELECT id             -- так как шевов может быть несколько в рамках одного отдела в рамках одного отдела	
					 FROM employee AS e1
					 WHERE id IN (SELECT chif_id 
								  FROM employee
								  WHERE department_id = @id_dep)
								  )
		AND salary < (SELECT MAX(salary) FROM employee WHERE department_id = @id_dep)
	ELSE                                  -- все остальные отделы
		UPDATE employee SET salary = (SELECT MAX(salary) FROM employee WHERE department_id = @id_dep) 
		WHERE id IN (SELECT id             -- так как шевов может быть несколько в рамках одного отдела		
					 FROM employee AS e1
					 WHERE id IN (SELECT chif_id 
								  FROM employee
								  WHERE department_id = @id_dep)  
					 AND chif_id IS NOT NULL)
		AND salary < (SELECT MAX(salary) FROM employee WHERE department_id = @id_dep)	
		
	SELECT e1.*,o1.old_salary FROM employee AS e1 INNER JOIN @oldsalary AS o1 ON e1.id = o1.employee_id 
END
GO

EXEC [dbo].[UPDATESALARY] 5, 23.00