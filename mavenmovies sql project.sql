-- Q1-Write a SQL query to count the number of characters except the spaces for each actor. Return         first 10 actors name length along with their name.

 select first_name, last_name ,length(concat(first_name, last_name))as length_fullname   from actor limit 10 ;

-- Q2-List all Oscar awardees(Actors who received Oscar award) with their full names and length of their names.

select first_name, last_name ,concat(first_name, " ",last_name )as full_name,awards,length(concat(first_name, last_name))as length_fullname from actor_award where awards ='oscar';

-- Q3-Find the actors who have acted in the film ‘Frost Head’

select title as film_name,concat(first_name, " ",last_name )as actor_name from actor
 a join film_actor f on a.actor_id=f.actor_id join film fl on f.film_id=fl.film_id where title='Frost Head'  ;
 
-- Q4-Pull all the films acted by the actor ‘Will Wilson’.

select title,concat(first_name, " ",last_name )as full_name from actor
 a join film_actor f on a.actor_id=f.actor_id join film fl on f.film_id=fl.film_id where first_name='will'  ;
 
-- Q5-Pull all the films which were rented and return in the month of May.

 SELECT title FROM film f join rental r on f.last_update=r.last_update
WHERE rental_date BETWEEN '2005-05-01' AND '2005-05-31' 
AND return_date BETWEEN '2005-05-01' AND '2005-05-31'; 

-- Q6-Pull all the films with ‘Comedy’ category.

 select title as film_name,name from film f join film_category fc on f.film_id=fc.film_id 
  join category c on fc.category_id=c.category_id where name='action';