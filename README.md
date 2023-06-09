[Table Diagram](https://dbdiagram.io/d/645986badca9fb07c4b9e033)

Functionality Overview
A Coupon belongs to a Merchant
An Invoice optionally belongs to a Coupon. An invoice may only have one coupon.
Note: When creating this new association on Invoice, your existing tests will fail unless the association is optional. Use these guides as a reference.​
Merchants have full CRUD functionality over their coupons with criteria/restrictions defined below:
A merchant can have a maximum of 5 activated coupons in the system at one time.
A merchant cannot delete a coupon, rather they can activate/deactivate them.
A Coupon has a name, unique code (e.g. “BOGO50”), and either percent-off or dollar-off value. The coupon’s code must be unique in the whole database.
If a coupon’s dollar value (ex. “$10 off”) exceeds the total cost of that merchant’s items on the invoice, the grand total for that merchant’s items should then be $0. (In other words, the merchant will never owe money to a customer.)
A coupon code from a Merchant only applies to Items sold by that Merchant.

[] 1. Merchant Coupons Index 

As a merchant
When I visit my merchant dashboard page
I see a link to view all of my coupons
When I click this link
I'm taken to my coupons index page
Where I see all of my coupon names including their amount off 
And each coupon's name is also a link to its show page.

[] 2. Merchant Coupon Create 

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

[] 3. Merchant Coupon Show Page 

As a merchant 
When I visit a merchant's coupon show page 
I see that coupon's name and code 
And I see the percent/dollar off value
As well as its status (active or inactive)
And I see a count of how many times that coupon has been used.

(Note: "use" of a coupon should be limited to successful transactions.)

[] 4. Merchant Coupon Deactivate

As a merchant 
When I visit one of my active coupon's show pages
I see a button to deactivate that coupon
When I click that button
I'm taken back to the coupon show page 
And I can see that its status is now listed as 'inactive'.

* Sad Paths to consider: 
1. A coupon cannot be deactivated if there are any pending invoices with that coupon.

[] 5. Merchant Coupon Activate

As a merchant 
When I visit one of my inactive coupon show pages
I see a button to activate that coupon
When I click that button
I'm taken back to the coupon show page 
And I can see that its status is now listed as 'active'.

[] 6. Merchant Coupon Index Sorted

As a merchant
When I visit my coupon index page
I can see that my coupons are separated between active and inactive coupons. 

[] 7. Merchant Invoice Show Page: Subtotal and Grand Total Revenues

As a merchant
When I visit one of my merchant invoice show pages
I see the subtotal for my merchant from this invoice (that is, the total that does not include coupon discounts)
And I see the grand total revenue after the discount was applied
And I see the name and code of the coupon used as a link to that coupon's show page.

[] 8. Admin Invoice Show Page: Subtotal and Grand Total Revenues

As an admin
When I visit one of my admin invoice show pages
I see the name and code of the coupon that was used (if there was a coupon applied)
And I see both the subtotal revenue from that invoice (before coupon) and the grand total revenue (after coupon) for this invoice.

[] 9: Holidays API

As a merchant
When I visit the coupons index page
I see a section with a header of "Upcoming Holidays"
In this section the name and date of the next 3 upcoming US holidays are listed.

Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)