# class CouponValidator < ActiveModel::Validator
#   def validate(record)
#     if record.coupons.where("coupons.status = 0").size >= 5
#       errors.add(:active_coupon_error, "Too Many Active Coupons")
#     end

#     # if options[:fields].any? { |field| record.send(field) == "Evil" }
#     # # if options[:fields].any? { |field| record.send(field) == "Evil" }
#     #   record.errors.add :base, "This person is evil"
#     # end
#   end
# #     # if record.coupons.active_coupon_count >= 5
# #     #   record.errors.add :base, "Too Many Active Coupons"
# #     # end
# #     # if options[:fields].count >= 5 { |field| record.send(field) == 0 }
# #     # # if options[:fields].sum("coupons.status = 0") >= 5
# #     # # if coupons.where("coupons.status = 0").size >= 5
# #     #   record.errors.add :base, "Too Many Active Coupons"
# #     # end

# #     # if active_coupon_count >= 5
# #     #   record.errors.add :base, "Too Many Active Coupons"
# #     # end

# #     # if record.first_name == "Evil"
# #     #   record.errors.add :base, "This person is evil"
# #     # end

# #       def active_coupon_count
# #         coupons.where("coupons.status = 0").size
# #       end
# #   end

# #   # def active_coupon_count #(merchant_id)
# #   #   .select("coupons.*, COUNT('coupons.status = 0') AS active_coupons")
# #   #   .where("coupons.status = 0") # AND coupons.merchant_id = #{merchant_id}")
# #   #   .group(:merchant_id)
# #   # end

# end

# # # class Person < ApplicationRecord
# # #   validates_with GoodnessValidator
# # # end
