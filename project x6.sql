
select * from pizza;
-- toal revenue
select sum(total_price) as total_revenue from pizza; 

-- Avg order values
select sum(total_price)/count(distinct order_id)as avg_order from pizza;

-- total pizza sold
select sum(quantity) as total_pizza_sold from pizza;

-- total orders
select sum(distinct order_id)as total_orders from pizza;

-- Avg pizza per order
select cast(cast(sum(quantity) as decimal(10,2))/cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as avg_pizza_per_order
from pizza;

-- % sale by pizza category
select pizza_category, cast(sum(total_price)*100/(select sum(total_price) from pizza )as decimal(10,2)) as perct_of_sale_by_category from pizza
 group by 1;
 
 --  % sale by pizza size
 select pizza_size, cast(sum(total_price)*100/(select sum(total_price) from pizza )as decimal(10,2)) as perct_of_sale_by_category from pizza
 group by 1;
 
 -- Total Pizzas Sold by Pizza Category
 select pizza_category, sum(quantity) as pizza_sold from pizza group by 1;
 
 -- top 5 pizza by revenue
 select pizza_name,sum(total_price)as total_revenue from pizza group by 1 order by 2 desc limit 5;
 
  -- top 5 bottom pizza by revenue
   select pizza_name,sum(total_price)as total_revenue from pizza group by 1 order by 2  limit 5;
   
   --  Top 5 Pizzas by Quantity
    select pizza_name,sum(quantity)as total_quantity from pizza group by 1 order by 2 desc limit 5;
    
      --  bottom 5 Pizzas by Quantity 
        select pizza_name,sum(quantity)as total_quantity from pizza group by 1 order by 2  limit 5;
        
        --  Top 5 Pizzas by Total Orders
         select pizza_name,count(distinct order_id)as total_orders from pizza group by 1 order by 2 desc limit 5;
         
         -- bottom 5 Pizzas by Total Orders
          select pizza_name,count(distinct order_id)as total_orders from pizza group by 1 order by 2  limit 5;