## Learning Goals
Write migrations to create tables and relationships between tables
Implement CRUD functionality for a resource using forms, buttons, and links, and associated view helpers (form_with, button_to, etc)
Use MVC to organize code effectively, limiting the amount of logic included in views and controllers
Use built-in ActiveRecord methods to join multiple tables of data, make calculations, and group data based on one or more attributes
Write model tests that fully cover the data logic of the application
Write feature tests that fully cover the functionality of the application



## User Stories
In the user stories below, we have outlined a few examples of Sad Paths you may consider adding in. In your project, you should take time to implement at least 2 sad paths total, but you are not limited to the examples we provide.

### 1. Merchant Coupons Index 

As a merchant
When I visit my merchant dashboard page
I see a link to view all of my coupons
When I click this link
I'm taken to my coupons index page
Where I see all of my coupon names including their amount off 
And each coupon's name is also a link to its show page.

### 2. Merchant Coupon Create 

As a merchant
When I visit my coupon index page 
I see a link to create a new coupon.
When I click that link 
I am taken to a new page where I see a form to add a new coupon.
When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount
And click the Submit button
I'm taken back to the coupon index page 
And I can see my new coupon listed.


* Sad Paths to consider: 
1. This Merchant already has 5 active coupons
2. Coupon code entered is NOT unique

### 3. Merchant Coupon Show Page 

As a merchant 
When I visit a merchant's coupon show page 
I see that coupon's name and code 
And I see the percent/dollar off value
As well as its status (active or inactive)
And I see a count of how many times that coupon has been used.

(Note: "use" of a coupon should be limited to successful transactions.)

### 4. Merchant Coupon Deactivate

As a merchant 
When I visit one of my active coupon's show pages
I see a button to deactivate that coupon
When I click that button
I'm taken back to the coupon show page 
And I can see that its status is now listed as 'inactive'.

* Sad Paths to consider: 
1. A coupon cannot be deactivated if there are any pending invoices with that coupon.

### 5. Merchant Coupon Activate

As a merchant 
When I visit one of my inactive coupon show pages
I see a button to activate that coupon
When I click that button
I'm taken back to the coupon show page 
And I can see that its status is now listed as 'active'.

### 6. Merchant Coupon Index Sorted

As a merchant
When I visit my coupon index page
I can see that my coupons are separated between active and inactive coupons. 

### 7. Merchant Invoice Show Page: Subtotal and Grand Total Revenues

As a merchant
When I visit one of my merchant invoice show pages
I see the subtotal for my merchant from this invoice (that is, the total that does not include coupon discounts)
And I see the grand total revenue after the discount was applied
And I see the name and code of the coupon used as a link to that coupon's show page.

### 8. Admin Invoice Show Page: Subtotal and Grand Total Revenues

As an admin
When I visit one of my admin invoice show pages
I see the name and code of the coupon that was used (if there was a coupon applied)
And I see both the subtotal revenue from that invoice (before coupon) and the grand total revenue (after coupon) for this invoice.

### 9: Holidays API

As a merchant
When I visit the coupons index page
I see a section with a header of "Upcoming Holidays"
In this section the name and date of the next 3 upcoming US holidays are listed.

Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)

## Extensions
Students can pick one or more of these extension features/stories to add to their project:

On the Merchant Coupon Index page, active and inactive coupons are sorted in order of popularity, from most to least.
Coupons can be used by multiple customers, but may only be used one time per customer.
Inactive coupons cannot be added to an Invoice.
A Coupon has a maximum number of uses before it is automatically deactivated. When implemented, prove that the number of times used on the Merchant Coupon Show Page is updated accordingly.
Holiday Coupons can be used up to 1 week from the actual holiday date. The coupon should automatically inactivate once someone tries to create an Invoice with that Coupon after a week of the holiday.
Generate unique coupon codes as suggestions when creating a new coupon.
7. Create a Holiday Coupon

As a merchant,
when I visit my coupons index page,
In the Holiday Coupons section, I see a `Create Coupon` button next to each of the 3 upcoming holidays.
When I click on the button I am taken to the new coupon page where I see a pre-filled name in the form, similar to:

   Name: <name of holiday> coupon
   Code: <uniquely generated code suggestion>

All other fields, I will need to fill out myself
I can leave the information as-is, or modify it before saving.
When I click save, 
I am redirected to my coupon index page where I see the newly-created coupon added to the list.
8. View a Holiday Coupon

As a merchant (if I have created a holiday coupon for a specific holiday),
when I visit my coupon index page,
within the `Upcoming Holidays` section I should not see the button to 'Create a Coupon' next to that holiday,
instead I should see a `View coupon` link.
When I click the link 
I am taken to the coupon show page for that holiday coupon.
