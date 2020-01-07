-- Exercice 1
-- Q1 
select * from airplane where capacity > 350;
-- Q2 
select NumAP, NameAP from airplane where localisation='Nice';
-- Q3 
select NumP, Dep_T from Flight;
-- Q4 
select * from Pilot;
-- Q5 
select NameP from Pilot where Salary > 15000 and Adress = 'Paris';
-- Q6 
select NumAP, NameAP from airplane where localisation='Nice' or capacity < 350;
-- Q7 
select * from Flight where Dep_T = 'Nice' and Arr_T = 'Paris' and Dep_H > 18;
-- Q8 
select NumP from Pilot p where p.NumP not in (select distinct NumP from Flight);
-- Q9 
select NumF, Dep_T from Flight f where NumP = 100 or NumP = 204;

-- Exercice 2

-- Q1 
select Personne from Emprunt where Livre = "Recueil Examens BD";
-- Q2 
select Personne from Emprunt e where e.Personne not in (select Personne from Retard);
-- Q3 
SELECT E1.Personne
  FROM Emprunt E1
    WHERE NOT EXISTS ( SELECT * FROM Emprunt E2 WHERE NOT EXISTS ( SELECT * FROM Emprunt E3 WHERE E3.Personne=E1.Personne AND E3.Livre=E2.Livre ))
-- Q4 
SELECT E1.Livre FROM Emprunt E1
WHERE NOT EXISTS ( SELECT * FROM Emprunt E2 WHERE NOT EXISTS ( SELECT * FROM Emprunt E3 WHERE E2.Livre=E1.Livre AND E3.Personne=E2.Personne))
-- Q5 
SELECT E1.Personne FROM Emprunt E1 WHERE NOT EXISTS (SELECT * FROM Emprunt E2 WHERE E2.Personne=E1.Personne AND NOT EXISTS (SELECT * FROM Retard E3 WHERE E3.Personne=E2.Personne AND E3.Livre=E2.Livre ))
