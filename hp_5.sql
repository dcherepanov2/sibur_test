-- =============================================
-- Author:		��������� ����� ���������
-- Create date: 18.12.2021
-- Description:	v.1.1 ---- ����������� ������� , ��� ��� ���� ����������� chif_id IS NULL, 
					  ---- ���� ���������� ���� � ���� �� ����� � chif_id = 0, ���� ��������� �������� ����������� ��� ���� �� ������
-- =============================================
CREATE PROCEDURE [dbo].[UPDATESALARY] 
	@ID_DEP  NUMERIC(15,4)  = 0,        -- id ������������
	@PRECENT NUMERIC(15,4) = 0          -- ������� ��������� ��������
AS
BEGIN
	
	DECLARE @oldsalary table(old_salary NUMERIC(10,2), employee_id INT)
	INSERT INTO @oldsalary SELECT salary,id FROM employee WHERE department_id = @id_dep--������ ������ �� ���������

	UPDATE employee SET salary = salary + (salary / 100 * @precent) WHERE department_id = @id_dep AND chif_id NOT IN (SELECT id 
																											      FROM employee WHERE id in (
																																	SELECT DISTINCT chif_id 
																																	FROM employee 
																																	WHERE department_id = @id_dep) 
																																AND department_id != @id_dep) -- ����� ����������� ����� ������

	IF @id_dep = (SELECT department_id FROM employee WHERE chif_id IS NULL) -- ������� �����
		UPDATE employee SET salary = (SELECT MAX(salary) FROM employee WHERE department_id = @id_dep) 
		WHERE id IN (SELECT id             -- ��� ��� ����� ����� ���� ��������� � ������ ������ ������ � ������ ������ ������	
					 FROM employee AS e1
					 WHERE id IN (SELECT chif_id 
								  FROM employee
								  WHERE department_id = @id_dep)
								  )
		AND salary < (SELECT MAX(salary) FROM employee WHERE department_id = @id_dep)
	ELSE                                  -- ��� ��������� ������
		UPDATE employee SET salary = (SELECT MAX(salary) FROM employee WHERE department_id = @id_dep) 
		WHERE id IN (SELECT id             -- ��� ��� ����� ����� ���� ��������� � ������ ������ ������		
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